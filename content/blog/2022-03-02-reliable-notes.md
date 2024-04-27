+++
date = 2022-03-02
title = "Easy, Reliable Note-Taking"
description = ""
draft = false
+++

# Choosing Durable File Formats

> TL;DR: Write in a format that can be easily rendered and read in
> plain-text mode (e.g., `.txt`, `.md`, etc.).

As I\'ve written more and more over the years, I\'ve found that my love
of note-taking is always growing. Everything I learn or need to remember
can be written down in a note and saved digitally, with no cost to
myself. Unlike paper copies that need physical storage space, digital
files simply need space on your local disk or cloud storage, which is
fairly abundant these days.

However, I had a historical struggle with migration of notes between
different apps that require different formats and applied proprietary
styling. This meant that I had to go through each note during migration
and edit the file to look presentable again.

For the last year or two, I have written everything exclusively in
[Markdown](https://en.wikipedia.org/wiki/Markdown) format. Small notes,
long-form writings, and even these blog posts are all written in
Markdown.

Why Markdown? While I do appreciate the simplicity of plain-text files
without any formatting, I often need visual cues such as heading and
code blocks to keep my thoughts straight. Markdown provides a minimal
set of styling indicators for me to style my notes without adding any
proprietary, embedded data into the files. If I want a top-level
heading, I simply add a hash (`#`) before the line. An added
bonus is that even if a system doesn\'t understand Markdown, it will
render it as plain-text and I can read it just as easily.

For example, here\'s how TextEdit on macOS will open and display a
Markdown file in plain-text, since it does contain any features to
preview Markdown as HTML:

![Plain Text
Markdown](https://img.cleberg.net/blog/20220302-easy-reliable-note-taking/plain_markdown.png)

## Saving & Syncing Files

In order to read and edit my notes across platforms, I use my personal
cloud storage through Tresorit due to its native integration with macOS
and iOS file managers. In addition, Tresorit works well on Debian-based
Linux distros, which I used before macOS (and will likely switch back to
in a few years).

You can use whatever sync software you want - syncing plain-text or
markdown files is incredibly easy and fast, since the files are
generally tiny.

Since the cloud storage syncs files automatically, there is no need for
me to sync anything manually or kick-off a sync job to update my files.
This means that I can edit on mobile, and it takes about 5-10 seconds to
see the changes on desktop.

### Version Control with Git

A different approach I\'ve contemplated is storing my notes and
attachments is using a hosted Git repository to track changes to the
files. However, I don\'t want to rely on an external service that could
potentially see into my data, even if the repository is private.

I might just do `git init` locally and then commit my changes
each time I write or update a note, but that seems to be a lot of work
just for tracking changes - which I don\'t necessarily care to know.

### Backups!

One small addition to the storage/sync conversation is the idea of
backups. Personally, I manually create periodic backups of my entire
cloud storage, compress it into an archive, and store it on my home
server.

To improve my workflow, I am going to be exploring options to
automatically compress the mounted cloud directory and send it over to
my server on a set schedule.

## Writing on Desktop

> **Update (06.14.22)**: Since writing this post, I have reverted to
> simply keeping my `notes` folder open and opening notes
> individually in TextEdit for a more minimal and relaxing writing
> experience on the desktop.

The bulk of my writing occurs in a desktop environment, with a full
keyboard layout and wide screen. I don\'t illustrate with a smart pen, I
rarely use embedded images, and I love being able to see all of my
notes/directories in a sidebar.

With this simple set of requirements, I chose
[Obsidian](https://obsidian.md) as my desktop text editor. Obsidian has
some in-depth tools like a graph view, command palette, mentions, etc.,
but I\'ve found that using it as a simple Markdown editor is incredibly
easy and straightforward.

Here\'s an example of how my Markdown notes look when opened in
plain-text mode:

![Obsidian Markdown Source
Mode](https://img.cleberg.net/blog/20220302-easy-reliable-note-taking/obsidian_source_mode.png)

Here\'s the \"live preview\" version, where the Markdown is rendered
into its HTML format:

![Obsidian Markdown Live
Preview](https://img.cleberg.net/blog/20220302-easy-reliable-note-taking/obsidian_live_preview.png)

### Programming on Desktop

While I was writing this, I realized I should specify that I don\'t use
the same editor for writing notes and for writing code. For programming
purposes, I use [VSCodium](https://vscodium.com) as my development IDE.

## Writing on Mobile

Personally, I write very little on mobile, except when needing to take
important notes on-the-go. Any long-form writing, journals, etc. are
done at home, where I always have my laptop available.

I wanted a simple and foolproof editor for iOS, preferably open-source.
After a long journey of testing the few (& terrible) open-source iOS
note-taking apps, I finally found a phenomenal one:
[Runestone](https://github.com/simonbs/runestone). This app is fantastic
for note-taking, has plenty of optional features, and integrates
natively with the iOS file manager.

This app opens the iOS file manager and allows you to click any file you
want, opens it up in an editor, and lets me save and close out of that
note.

Quite simple but effective.
