+++
date = 2023-02-02
title = "Exploring the Hare Programming Language"
description = ""
draft = false
+++

# A Quick Note

By no means am I a professional developer, so this post will be rather short. I
won't be going into depth on the specification or anything that technical.

Instead, I will simply be talking about how I (a relatively basic hobbyist
programmer) have been playing with Hare and what intrigues me about the
language.

# Hare

The [Hare](https://harelang.org) programming language is a straightforward
language that should look familiar if you've ever programmed with C, Rust, or
other languages that aim to build software at the system-level.

The Hare homepage states the following:

> Hare is a systems programming language designed to be simple, stable, and
> robust. Hare uses a static type system, manual memory management, and minimal
> runtime. It is well-suited to writing operating systems, system tools,
> compilers, networking software, and other low-level, high performance tasks.

I have found this all to be true while playing with it for the first time today.
In the next few sections, I'm going to walk through my installation and first
program.

## Installation

I'm currently running Alpine Linux on my Thinkpad, so the installation was quite
easy as there is a package for Hare in the `apk` repositories.

```sh
doas apk add hare hare-doc
```

However, I was able to install Hare from scratch on Fedora Linux a short while
ago, which was also very easy to do. If you need further instructions and Hare
doesn't have a package on your system, take a look at the [Hare
Installation](https://harelang.org/installation/) page.

## Creating a Test Project

In order to play with the language, I created
[hare-test](https://github.com/ccleberg/daily-poem/learning-hare) and will be putting any of my
Hare-related adventures in here.

> **Update:** I also created a simple Hare program for creating a file from user
> input:
> [files.ha](hhttps://github.com/ccleberg/learning-hare/blob/main/files/files.ha)

Luckily, Hare doesn't require any complex set-up tools or build environment.
Once you have Hare installed, you simply need to create a file ending with `.ha`
and you can run a Hare program.

I created a file called `rgb.ha` in order to test out the random number
generation and passing parameters between functions.

```sh
nano rgb.ha
```

Within this file, I was able to easily import a few of the [standard library
modules](https://harelang.org/tutorials/stdlib/): `fmt`, `math::random`, and
`datetime`.

With these modules, I created two functions:

1. `main`: This function calls the `generate_rgb` function and then prints out
   the returned values.
2. `generate_rgb`: This function uses the current Unix epoch time to generate a
   pseudo-random value and uses this value to create three more random values
   between 0 and 255. These three numbers represent a color in RGB format.

> **Note**: Some syntax coloring may look odd, as Zola currently doesn't have a
> syntax highlighting theme for Hare. Instead, I'm using the C theme, which may
> not be exactly accurate when coloring the code below.

```c
use datetime;
use fmt;
use math::random;

export fn main() void = {
    const rgb = generate_rgb();
    fmt::printfln("RGB: ({}, {}, {})", rgb[0], rgb[1], rgb[2])!;
};

fn generate_rgb() []u64 = {
    // Use the current Unix epoch time as the seed value
    let datetime = datetime::epochunix(&datetime::now());

    // Generate initial pseudo-random value
    // You must cast the datetime from int to u64
    let x = random::init(datetime: u64);

    // Generate RGB values between (0, 255) using pseudo-random init value
    let r = random::u64n(&x, 255);
    let g = random::u64n(&x, 255);
    let b = random::u64n(&x, 255);

    // Structure data as array and return
    let rgb_array: [3]u64 = [r, g, b];
    return rgb_array;
};
```

## Running a Program

Once you have a Hare file written and ready to run, you simply need to run it:

```sh
hare run file.ha
```

You can also compile the program into an executable:

```sh
hare build -o example file.ha
./example
```

## Initial Thoughts

1. Documentation Improvements Would Help

    While I was able to piece everything together eventually, the biggest
    downfall right now in Hare's documentation. For such a new project, the
    documentation is in a great spot. However, bare specifications don't help as
    much as a brief examples section would.

    For example, it took me a while to figure out what the `u64n` function was
    looking for. I could tell that it took two parameters and the second was my
    max value (255), but couldn't figure out what the first value should be.
    Eventually, I inspected the `random.ha` file in the [Hare source
    code](https://git.sr.ht/~sircmpwn/hare/tree/master/item/math/random/random.ha)
    and found the test suite that helped me discover that it needed an `init()`
    value in the form of `&var`.

2. More Basic Modules

    This is another point that comes from Hare being new and awaiting more
    contributions, but there are some basic functions that I would personally
    enjoy seeing in Hare, such as one to convert decimal (base 10) values to
    hexadecimal (base 16).

    If I'm feeling comfortable with my math, I may work on the list of functions
    I want and see if any can make it into the Hare source code.

3. Overall Thoughts

    Overall, I actually really enjoy Hare. It's not as tedious to get a project
    up and running as Rust, but it's also simpler and more user-friendly than
    learning C. I am going to continue playing with it and see if I can make
    anything of particular value.
