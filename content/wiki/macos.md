+++
title = "macOS"
updated = 2024-05-01
draft = false
+++

Related:

-   [Hardware](/wiki/hardware/)

My primary OS. Currently running macOS Sonoma 14. This wiki page contains most
of the apps I have used at one point or another across my different Macbooks.

(`*`) = My favorites

## Configuration

### Disable System Services

-   [Disabling and Enabling System Integrity
    Protection](https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection)
-   Disable Gatekeeper: `sudo spctl --master-disable`

### Dotfiles

These are probably out of date, but they give a general idea of how I configure
my machine.

```conf
# ~/.zshrc
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"
export EDITOR="/opt/homebrew/bin/emacs -nw"
ZSH_THEME="bureau"
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh
```

```conf
# ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

```conf
# ~/.config/skhd/skhdrc
cmd - return : /Applications/iTerm.app/Contents/MacOS/iTerm2
cmd + shift - return : /Applications/LibreWolf.app/Contents/MacOS/librewolf
```

```conf
# ~/.config/yabai/yabairc
yabai -m config                                 \
    mouse_follows_focus          off            \
    focus_follows_mouse          off            \
    window_origin_display        default        \
    window_placement             second_child   \
    window_zoom_persist          on             \
    window_shadow                on             \
    window_animation_duration    0.0            \
    window_animation_frame_rate  120            \
    window_opacity_duration      0.0            \
    active_window_opacity        1.0            \
    normal_window_opacity        0.90           \
    window_opacity               off            \
    insert_feedback_color        0xffd75f5f     \
    split_ratio                  0.50           \
    split_type                   auto           \
    auto_balance                 off            \
    top_padding                  15             \
    bottom_padding               15             \
    left_padding                 15             \
    right_padding                15             \
    window_gap                   10             \
    layout                       bsp            \
    mouse_modifier               fn             \
    mouse_action1                move           \
    mouse_action2                resize         \
    mouse_drop_action            swap
echo "yabai configuration loaded.."
```

## Software

### Browsers

-   [Librewolf](https://librewolf.net/) (`*`) - Custom version of Firefox,
    focused on privacy and security
    -   [Bitwarden](https://bitwarden.com/) - An open source password manager
    -   [Dark Reader](https://darkreader.org/) - Dark mode for all the websites
    -   [Libredirect](https://libredirect.github.io/) - Automatic web
        redirections
    -   [Strongbox](https://strongboxsafe.com/) - Keepass password manager for
        iOS & macOS
    -   [uBlock Origin](https://ublockorigin.com/) - Free, open-source ad
        content blocker
-   [Ungoogled
    Chromium](https://github.com/ungoogled-software/ungoogled-chromium) - Google
    Chromium, sans integration with Google
-   [eww](https://www.gnu.org/software/emacs/manual/html_mono/eww.html) - Emacs
    Web Wowser, for TUI browsing

### Command Line Tools

-   [doggo](https://github.com/mr-karan/doggo) - Command-line DNS Client for
    Humans
-   [duf](https://github.com/muesli/duf) - Disk Usage/Free Utility - a better
    'df' alternative
-   [dust](https://github.com/bootandy/dust) - A more intuitive version of du in
    rust
-   [eza](https://github.com/eza-community/eza) - A modern alternative to ls
-   [yt-dlp](https://github.com/yt-dlp/yt-dlp) - A youtube-dl fork with
    additional features and fixes

### Communications

-   [Element](https://element.io/) (`*`) - Matrix's default GUI client
-   [gomuks](https://github.com/tulir/gomuks) - A terminal based Matrix client
-   [Thunderbird](https://www.thunderbird.net/) (`*`) - An open source email
    client by Mozilla
-   [Signal](https://signal.org/) (`*`) - A simple, powerful, and secure
    messenger

### Development

-   [Docker Desktop](https://www.docker.com/products/docker-desktop/) - Docker
    containers for your desktop
    -   [open-webui](https://github.com/open-webui/open-webui) - User-friendly
        WebUI for LLMs
-   [iTerm2](https://iterm2.com/) (`*`) - The best terminal for macOS, hands
    down
-   [Podman Desktop](https://podman-desktop.io/) (`*`) - Open source tool for
    containers and Kubernetes
-   [Xcode](https://developer.apple.com/xcode/) - Apple's IDE
-   [zsh](https://en.wikipedia.org/wiki/Z_shell) (`*`) - My shell preference due
    to its plugin and theme community
    -   [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
        - Fish-like autosuggestions for zsh
    -   [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
        - Fish shell like syntax highlighting for Zsh

### Editors

-   [Doom Emacs](https://github.com/doomemacs/doomemacs) (`*`) - An Emacs
    framework, great for working in org-mode
-   [Obsidian](https://obsidian.md/) - A nice Markdown-based editor based on a
    "vault" structure. Offers a paid sync solution and community extensions
-   [Standard Notes](https://standardnotes.com/) - A simple text editor focused
    on privacy and security. Offers a paid sync solution and community
    extensions
-   [VSCodium](https://vscodium.com/) - VS Code without proprietary blobs

### Media

-   [Luminar](https://skylum.com/luminar) - Luminar offers top-notch photo
    editing features
-   [Minecraft](https://www.minecraft.net/) - Block mining simulator
-   [NetNewsWire](https://netnewswire.com/) - A free and open source RSS reader
    for Mac, iPhone, and iPad
-   [Plex](https://www.plex.tv/) (`*`) - Desktop client for the Plex Media
    Server
-   [Steam](https://store.steampowered.com/) - The top gaming marketplace for
    computers
-   [Transmission](https://transmissionbt.com/) (`*`) - A Fast, Easy and Free
    Bittorrent Client
-   [VLC](https://www.videolan.org/vlc/) - A free and open source cross-platform
    multimedia player

### Package Management

-   [Homebrew](https://brew.sh/) (`*`) - The Missing Package Manager for macOS
    (or Linux)
-   [MacPorts](https://www.macports.org/) - A system to compile, install, and
    manage open source software

### Utilities

-   [BetterDisplay](https://betterdisplay.pro/) - Allows you to tweak a ton of
    features of built-in and external screens, such as scaling, configuration
    overrides, and color/brightness upscaling
-   [Bitwarden](https://bitwarden.com/) - An open source password manager
-   [Ice](https://icemenubar.app/) (`*`)- A powerful menu bar management tool
-   [LittleSnitch](https://obdev.at/products/littlesnitch/index.html) - Shows
    all network connections on your Macbook, including system and privileged
    services
-   [MicroSnitch](https://obdev.at/products/microsnitch/index.html) - Camera &
    microphone monitoring and alterting service
-   [Mullvad](https://mullvad.net/) (`*`) - A private VPN service
-   [Ollama](https://ollama.com/) - Run Llama 2, Code Llama, and other models
    locally on your machine
    -   [Ollama Swift](https://github.com/kghandour/Ollama-SwiftUI) - User
        Interface made for Ollama.ai using Swift
-   [OrbStack](https://orbstack.dev/) - A fast and convenient GUI to manage
    Docker contains and Linux VMs
-   [Raycast](https://www.raycast.com/) - A collection of tools and shortcuts,
    an alternative to Spotlight
-   [skhd](https://github.com/koekeishiya/skhd) (`*`) - Simple hotkey daemon for
    macOS
-   [Strongbox](https://strongboxsafe.com/) - Keepass password manager for iOS &
    macOS
-   [Syncthing](https://syncthing.net/) (`*`) - Continuous file synchronization
-   [TinkerTool](https://www.bresink.com/osx/TinkerTool.html) - Unlock hidden
    configuration options for macOS
-   [yabai](https://github.com/koekeishiya/yabai) (`*`) - Automatic window
    tiling
