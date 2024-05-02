+++
date = 2023-06-28
title = "Getting Started with Backblaze B2 Cloud Storage"
description = ""
draft = false
+++

# Overview

Backblaze [B2 Cloud Storage](https://www.backblaze.com/b2/cloud-storage.html) is
an inexpensive and reliable on-demand cloud storage and backup solution.

The service starts at $5/TB/month ($0.005/GB/month) with a download rate of
$0.01/GB/month.

However, there are free tiers:

-   The first 10 GB of storage is free.
-   The first 1 GB of data downloaded each day is free.
-   Class A transactions are free.
-   The first 2500 Class B transactions each day are free.
-   The first 2500 Class C transactions each day are free.

You can see which API calls fall into categories A, B, or C here: [Pricing
Organized by API
Calls](https://www.backblaze.com/b2/b2-transactions-price.html).

For someone like me, who wants an offsite backup of their server's `/home/`
directory and various other server configs that fall under 10 GB total,
Backblaze is a great solution from a financial perspective.

# Create An Account

To start with Backblaze, you'll need to [create a free
account](https://www.backblaze.com/b2/sign-up.html) - no payment method is
required to sign up.

Once you have an account, you can test out the service with their web GUI, their
mobile app, or their CLI tool. I'm going to use the CLI tool below to test a
file upload and then sync an entire directory to my Backblaze bucket.

# Create a Bucket

Before you can start uploading, you need to create a bucket. If you're familiar
with other object storage services, this will feel familiar. If not, it's pretty
simple to create one.

As their webpage says:

> A bucket is a container that holds files that are uploaded into B2 Cloud
> Storage. The bucket name must be globally unique and must have a minimum of 6
> characters. A limit of 100 buckets may be created per account. An unlimited
> number of files may be uploaded into a bucket.

Once you click the `Create a Bucket` button on their webpage or mobile app, you
need to provide the following:

-   Bucket Unique Name
-   Files in Bucket are: `Private` or `Public`
-   Default Encryption: `Disable` or `Enable`
-   Object Lock: `Disable` or `Enable`

For my bucket, I created a private bucket with encryption enabled and object
lock disabled.

Once your bucket is created, you can test the upload/download feature on their
web GUI or mobile app! At this point, you have a fully functional bucket and
account.

# Linux CLI Tool

## Installation

To install the `b2` CLI tool, you'll need to download it from the [CLI
Tools](https://www.backblaze.com/docs/cloud-storage-command-line-tools) page. I
recommend copying the URL from the link that says `Linux` and using wget to
download it, as shown below.

Once downloaded, make the file executable and move it to a location on your
`$PATH`, so that you can execute that command from anywhere on the machine.

```sh
wget <b2_cli_url>
chmod +x b2_linux
mv b2_linux /usr/bin/b2
```

## Log In

The first step after installation is to log in. To do this, execute the
following command and provide your `<applicationKeyId>` and `<applicationKey>`.

If you don't want to provide these values in the command itself, you can simply
execute the base command and it will request them in an interactive prompt.

```sh
# if you want to provide the keys directly:
b2 authorize-account [<applicationKeyId>] [<applicationKey>]

# or, if you don't want your keys in your shell history:
b2 authorize-account
```

## Upload a Test File

In order to test the functionality of the CLI tool, I'll start by uploading a
single test file to the bucket I created above. We can do this with the
`upload_file` function.

The command is issued as follows:

```sh
b2 upload_file <bucket_name> <local_file> <remote_file>
```

In my situation, I executed the following command with my username.

```sh
b2 upload_file my_unique_bucket /home/<user>/test.md test.md
```

To confirm that the file was uploaded successfully, list the files in your
bucket:

```sh
b2 ls <bucket_name>
```

```txt
test.md
```

## Sync a Directory

If you have numerous files, you can use the `sync` function to perform
functionality similar to `rsync`, where you can check what's in your bucket and
sync anything that is new or modified.

The command is issued as follows:

```sh
b2 sync <source file location> <B2 bucket destination>
```

In my case, I can sync my user's entire home directory to my bucket without
specifying any of the files directly:

```sh
b2 sync /home/<user>/ "b2://<bucketName>/home/<user>"
```

# Caveats

## Timing of Updates to the Web GUI

When performing actions over a bucket, there is a slight delay in the web GUI
when inspecting a bucket or its file. Note that simple actions such as uploading
or deleting files may have a delay of a few minutes up to 24 hours. In my
experience (\<10 GB and ~20,000 files), any actions took only a few minutes to
update across clients.

## Symlinks

Note that symlinks are resolved by b2, so if you have a link from
`/home/<user>/nas-storage` that symlinks out to a `/mnt/nas-storage` folder that
has 10TB of data, `b2` will resolve that link and start uploading all 10TB of
data linked within the folder.

If you're not sure if you have any symlinks, a symlink will look like this (note
the `->` symbol):

```sh
> ls -lha
lrwxrwxrwx  1 root root   20 Jun 28 13:32 nas -> /mnt/nas-storage/
```

You can recursively find symlink in a path with the following command:

```sh
ls -lR /path/to/search | grep '^l'
```
