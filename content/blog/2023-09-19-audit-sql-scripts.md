+++
date = 2023-09-19
title = "Useful SQL Scripts for Auditing Logical Access"
description = ""
draft = false
+++

# Overview

When you have to scope a database into your engagement, you may be curious how
to best extract the information from the database. While there are numerous
different methods to extract this type of information, I'm going to show an
example of how to gather all users and privileges from three main database
types: Oracle, Microsoft SQL, and MySQL.

# Oracle

You can use the following SQL script to see all users and their privileges in an
Oracle database:

```sql
SELECT
    grantee AS "User",
    privilege AS "Privilege"
FROM
    dba_sys_privs
WHERE
    grantee IN (SELECT DISTINCT grantee FROM dba_sys_privs)
UNION ALL
SELECT
    grantee AS "User",
    privilege AS "Privilege"
FROM
    dba_tab_privs
WHERE
    grantee IN (SELECT DISTINCT grantee FROM dba_tab_privs);
```

This script queries the `dba_sys_privs` and `dba_tab_privs` views to retrieve
system and table-level privileges respectively. It then combines the results
using `UNION ALL` to show all users and their associated privileges. Please note
that this method does not extract information from the `dba_role_privs` table -
use the method below for that data.

Please note that you might need appropriate privileges (e.g., DBA privileges) to
access these views, and you should exercise caution when querying system tables
in a production Oracle database.

## Alternative Oracle Query

You can also extract each table's information separately and perform processing
outside the database to explore and determine the information necessary for the
audit:

```sql
SELECT ** FROM sys.dba_role_privs;
SELECT ** FROM sys.dba_sys_privs;
SELECT ** FROM sys.dba_tab_privs;
SELECT ** FROM sys.dba_users;
```

# Microsoft SQL

You can use the following SQL script to see all users and their privileges in a
Microsoft SQL Server database ([source](https://stackoverflow.com/a/30040784)):

```sql
/*
Security Audit Report
1) List all access provisioned to a sql user or windows user/group directly
2) List all access provisioned to a sql user or windows user/group through a database or application role
3) List all access provisioned to the public role

Columns Returned:
UserName        : SQL or Windows/Active Directory user account.  This could also be an Active Directory group.
UserType        : Value will be either 'SQL User' or 'Windows User'.  This reflects the type of user defined for the
                  SQL Server user account.
DatabaseUserName: Name of the associated user as defined in the database user account.  The database user may not be the
                  same as the server user.
Role            : The role name.  This will be null if the associated permissions to the object are defined at directly
                  on the user account, otherwise this will be the name of the role that the user is a member of.
PermissionType  : Type of permissions the user/role has on an object. Examples could include CONNECT, EXECUTE, SELECT
                  DELETE, INSERT, ALTER, CONTROL, TAKE OWNERSHIP, VIEW DEFINITION, etc.
                  This value may not be populated for all roles.  Some built in roles have implicit permission
                  definitions.
PermissionState : Reflects the state of the permission type, examples could include GRANT, DENY, etc.
                  This value may not be populated for all roles.  Some built in roles have implicit permission
                  definitions.
ObjectType      : Type of object the user/role is assigned permissions on.  Examples could include USER_TABLE,
                  SQL_SCALAR_FUNCTION, SQL_INLINE_TABLE_VALUED_FUNCTION, SQL_STORED_PROCEDURE, VIEW, etc.
                  This value may not be populated for all roles.  Some built in roles have implicit permission
                  definitions.
ObjectName      : Name of the object that the user/role is assigned permissions on.
                  This value may not be populated for all roles.  Some built in roles have implicit permission
                  definitions.
ColumnName      : Name of the column of the object that the user/role is assigned permissions on. This value
                  is only populated if the object is a table, view or a table value function.
*/

--List all access provisioned to a sql user or windows user/group directly
SELECT
    [UserName] = CASE princ.[type]
                    WHEN 'S' THEN princ.[name]
                    WHEN 'U' THEN ulogin.[name] COLLATE Latin1_General_CI_AI
                 END,
    [UserType] = CASE princ.[type]
                    WHEN 'S' THEN 'SQL User'
                    WHEN 'U' THEN 'Windows User'
                 END,
    [DatabaseUserName] = princ.[name],
    [Role] = null,
    [PermissionType] = perm.[permission_name],
    [PermissionState] = perm.[state_desc],
    [ObjectType] = obj.type_desc,--perm.[class_desc],
    [ObjectName] = OBJECT_NAME(perm.major_id),
    [ColumnName] = col.[name]
FROM
    --database user
    sys.database_principals princ
LEFT JOIN
    --Login accounts
    sys.login_token ulogin on princ.[sid] = ulogin.[sid]
LEFT JOIN
    --Permissions
    sys.database_permissions perm ON perm.[grantee_principal_id] = princ.[principal_id]
LEFT JOIN
    --Table columns
    sys.columns col ON col.[object_id] = perm.major_id
                    AND col.[column_id] = perm.[minor_id]
LEFT JOIN
    sys.objects obj ON perm.[major_id] = obj.[object_id]
WHERE
    princ.[type] in ('S','U')
UNION
--List all access provisioned to a sql user or windows user/group through a database or application role
SELECT
    [UserName] = CASE memberprinc.[type]
                    WHEN 'S' THEN memberprinc.[name]
                    WHEN 'U' THEN ulogin.[name] COLLATE Latin1_General_CI_AI
                 END,
    [UserType] = CASE memberprinc.[type]
                    WHEN 'S' THEN 'SQL User'
                    WHEN 'U' THEN 'Windows User'
                 END,
    [DatabaseUserName] = memberprinc.[name],
    [Role] = roleprinc.[name],
    [PermissionType] = perm.[permission_name],
    [PermissionState] = perm.[state_desc],
    [ObjectType] = obj.type_desc,--perm.[class_desc],
    [ObjectName] = OBJECT_NAME(perm.major_id),
    [ColumnName] = col.[name]
FROM
    --Role/member associations
    sys.database_role_members members
JOIN
    --Roles
    sys.database_principals roleprinc ON roleprinc.[principal_id] = members.[role_principal_id]
JOIN
    --Role members (database users)
    sys.database_principals memberprinc ON memberprinc.[principal_id] = members.[member_principal_id]
LEFT JOIN
    --Login accounts
    sys.login_token ulogin on memberprinc.[sid] = ulogin.[sid]
LEFT JOIN
    --Permissions
    sys.database_permissions perm ON perm.[grantee_principal_id] = roleprinc.[principal_id]
LEFT JOIN
    --Table columns
    sys.columns col on col.[object_id] = perm.major_id
                    AND col.[column_id] = perm.[minor_id]
LEFT JOIN
    sys.objects obj ON perm.[major_id] = obj.[object_id]
UNION
--List all access provisioned to the public role, which everyone gets by default
SELECT
    [UserName] = '{All Users}',
    [UserType] = '{All Users}',
    [DatabaseUserName] = '{All Users}',
    [Role] = roleprinc.[name],
    [PermissionType] = perm.[permission_name],
    [PermissionState] = perm.[state_desc],
    [ObjectType] = obj.type_desc,--perm.[class_desc],
    [ObjectName] = OBJECT_NAME(perm.major_id),
    [ColumnName] = col.[name]
FROM
    --Roles
    sys.database_principals roleprinc
LEFT JOIN
    --Role permissions
    sys.database_permissions perm ON perm.[grantee_principal_id] = roleprinc.[principal_id]
LEFT JOIN
    --Table columns
    sys.columns col on col.[object_id] = perm.major_id
                    AND col.[column_id] = perm.[minor_id]
JOIN
    --All objects
    sys.objects obj ON obj.[object_id] = perm.[major_id]
WHERE
    --Only roles
    roleprinc.[type] = 'R' AND
    --Only public role
    roleprinc.[name] = 'public' AND
    --Only objects of ours, not the MS objects
    obj.is_ms_shipped = 0
ORDER BY
    princ.[Name],
    OBJECT_NAME(perm.major_id),
    col.[name],
    perm.[permission_name],
    perm.[state_desc],
    obj.type_desc--perm.[class_desc]
```

# MySQL

You can use the following SQL script to see all users and their privileges in a
MySQL database:

```sh
mysql -u root -p
```

Find all users and hosts with access to the database:

```sql
SELECT ** FROM information_schema.user_privileges;
```

This script retrieves user information and their associated database-level
privileges from the `information_schema.user_privileges` table in MySQL. It
lists various privileges such as SELECT, INSERT, UPDATE, DELETE, CREATE, and
more for each user and database combination.

Please note that you may need appropriate privileges (e.g., `SELECT` privileges
on `information_schema.user_privileges`) to access this information in a MySQL
database. Additionally, some privileges like GRANT OPTION, EXECUTE, EVENT, and
TRIGGER may not be relevant for all users and databases.

## Alternative MySQL Query

You can also grab individual sets of data from MySQL if you prefer to join them
after extraction. I have marked the queries below with `SELECT ...` and excluded
most `WHERE` clauses for brevity. You should determine the relevant privileges
in-scope and query for those privileges to reduce the length of time to query.

```sql
-- Global Permissions
SELECT ... FROM mysql.user;

-- Database Permissions
SELECT ... FROM mysql.db
WHERE db = @db_name;

-- Table Permissions
SELECT ... FROM mysql.tables
WHERE db = @db_name;

-- Column Permissions
SELECT ... FROM mysql.columns_priv
WHERE db = @db_name;

-- Password Configuration
SHOW GLOBAL VARIABLES LIKE 'validate_password%';
SHOW VARIABLES LIKE 'validate_password%';
```
