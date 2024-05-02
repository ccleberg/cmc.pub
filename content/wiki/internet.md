+++
title = "Internet"
updated = 2024-05-02
draft = false
+++

## Gemini

The [Gemini Protocol](https://geminiprotocol.net/) is a network of
interconnected plaintext documents. If you've used
[Gopher](https://en.wikipedia.org/wiki/Gopher_(protocol)) before, Gemini will
feel very familiar.

Instead of web sites, Gemini uses the term "capsules" that can be access via
`gemini://` links.

In order to browse Gemini capsules, you will need a client capable of supporting
Gemini. The Gemini Protocol website has a [Gemini
software](https://geminiprotocol.net/software/) page with a list of clients for
each platform.


### Gemtext

[Gemtext](https://geminiprotocol.net/docs/cheatsheet.gmi) is a plaintext syntax,
very similar to Markdown.

To quote the Gemini Protocol's documentation:

-   Long lines get wrapped by the client to fit the screen.
-   Short lines _don't_ get joined together.
-   Write paragraphs as single long lines.
-   Blank lines are rendered verbatim.

```md
[//]: <> (Headings)

# Heading

## Sub-heading

### Sub-subheading

[//]: <> (Lists)

-   Mercury
-   Gemini
-   Apollo

[//]: <> (Quotes)

> I contend that text-based websites should not exceed in size the major works of Russian literature.

[//]: <> (Links)
=> gemini://geminiprotocol.net/docs/cheatsheet.gmi
=> gemini://geminiprotocol.net/docs/cheatsheet.gmi Gemtext cheatsheet

[//]: <> (Preformatted text)
Any line starting with three backticks (```) will tell the client to toggle to
"preformatted mode", which disables the client's logical checks to render links,
headings, etc. and will render the text as-is.
```

## Gopher

The [Gopher Protocol](https://en.wikipedia.org/wiki/Gopher_(protocol)) is a
communication protocol, similar to Gemini, that allows for browsing of any ones
of [the 14 supported item
types](https://datatracker.ietf.org/doc/html/rfc1436#section-3.8):

```txt
0   Item is a file
1   Item is a directory
2   Item is a CSO phone-book server
3   Error
4   Item is a BinHexed Macintosh file.
5   Item is DOS binary archive of some sort.
    Client must read until the TCP connection closes.  Beware.
6   Item is a UNIX uuencoded file.
7   Item is an Index-Search server.
8   Item points to a text-based telnet session.
9   Item is a binary file!
        Client must read until the TCP connection closes.  Beware.
+   Item is a redundant server
T   Item points to a text-based tn3270 session.
g   Item is a GIF format graphics file.
I   Item is some kind of image file.  Client decides how to display.
```

### Simplicity is Intentional

Gopher is [meant to be
simplistic](https://datatracker.ietf.org/doc/html/rfc1436#section-4).

```txt
As far as possible we desire any new features to be carried as new
protocols that will be hidden behind new document-types.  The
internet Gopher philosophy is:

    (a) Intelligence is held by the server.  Clients have the option
    of being able to access new document types (different, other types
    of servers) by simply recognizing the document-type character.
    Further intelligence to be borne by the protocol should be
    minimized.

    (b) The well-tempered server ought to send "text" (unless a file
    must be transferred as raw binary).  Should this text include
    tabs, formfeeds, frufru?  Probably not, but rude servers will
    probably send them anyway.  Publishers of documents should be
    given simple tools (filters) that will alert them if there are any
    funny characters in the documents they wish to publish, and give
    them the opportunity to strip the questionable characters out; the
    publisher may well refuse.

    (c) The well-tempered client should do something reasonable with
    funny characters received in text; filter them out, leave them in,
    whatever.
```