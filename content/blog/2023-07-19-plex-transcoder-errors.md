+++
date = 2023-07-19
title = "How to Avoid Plex Error: 'Conversion failed. The transcoder failed to start up.'"
description = ""
draft = false
+++

# Plex Transcoder Error

Occasionally, you may see an error in your Plex client that references a failure
with the transcoder conversion process. The specific error wording is:

``` txt
Conversion failed. The transcoder failed to start up.
```

# Debugging the Cause

In order to get a better look at what is causing the error, I'm going to
observe the Plex console while the error occurs. To do this, open the Plex web
client, go to `Settings` > `Manage` > `Console`. Now, try to play the title
again and watch to see which errors occur.

In my case, you can see the errors below are related to a subtitle file (`.srt`)
causing the transcoder to crash.

``` txt
Jul 19, 2023 16:49:34.945 [140184571120440] Error — Couldn't find the file to stream: /movies/Movie Title (2021)/Movie Title (2021).srt
Jul 19, 2023 16:49:34.947 [140184532732728] Error — [Req#7611/Transcode/42935159-67C1-4192-9336-DDC6F7BC9330] Error configuring transcoder: TPU: Failed to download sub-stream to temporary file
Jul 19, 2023 16:49:35.225 [140184532732728] Warning — [Req#760d/Transcode] Got a request to stop a transcode session without a valid session GUID.
Jul 19, 2023 16:49:45.561 [140184532732728] Info — [Req#7648] AutoUpdate: no updates available
Jul 19, 2023 16:51:23.402 [140184510081848] Info — Library section 1 (Movies) will be updated because of a change in "/movies/Movie Title (2021)/Movie Title (2021).srt"
```

# Solving the Error

In my case, I simply removed the subtitle file because it was not critical to
keep. You may also avoid this by turning off subtitles if you don't want to
delete the file.

```sh
rm -rf "/movies/Movie Title (2021)/Movie Title (2021).srt"
```

Once the subtitle is removed from the directory or subtitles are turned off, try
to play the title again. At this point, it should play without error. If not,
reopen or refresh your Plex client and the Plex server:

```sh
sudo systemctl restart plexmediaserver.service
```

# Related Discussion

Looking at [a related Plex forum
post](https://forums.plex.tv/t/subtitles-crashing-plex-transcoder-samsung-q80-tv-with-or-without-hardware-transcode/741441/2),
it seems that `.srt` subtitles are the core issue here. However, Plex does not
seem to have a resolution that fixes these errors.

Unfortunately, I would suggest converting subtitle formats, burning the
subtitles into the title, or simply removing subtitles when they cause crashes.
