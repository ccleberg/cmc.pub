+++
date = 2018-11-28
title = "AES Encryption"
description = ""
draft = false
+++

# Basic AES

If you\'re not familiar with encryption techniques,
[AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) is the
**Advanced Encryption Standard**. This specification was established by
the National Institute of Standards and Technology, sub-selected from
the Rijndael family of ciphers (128, 192, and 256 bits) in 2001.
Furthering its popularity and status, the US government chose AES as
their default encryption method for top-secret data, removing the
previous standard which had been in place since 1977.

AES has proven to be an extremely safe encryption method, with 7-round
and 8-round attacks making no material improvements since the release of
this encryption standard almost two decades ago.

> Though many papers have been published on the cryptanalysis of AES,
> the fastest single-key attacks on round-reduced AES variants \[20,
> 33\] so far are only slightly more powerful than those proposed 10
> years ago \[23,24\].
>
> -   [Bogdonav, et
>     al.](http://research.microsoft.com/en-us/projects/cryptanalysis/aesbc.pdf)

# How Secure is AES?

In theory, AES-256 is non-crackable due to the massive number of
combinations that can be produced. However, AES-128 is no longer
recommended as a viable implementation to protect important data.

A semi-short [comic
strip](http://www.moserware.com/2009/09/stick-figure-guide-to-advanced.html)
from Moserware quickly explains AES for the public to understand.
Basically AES encrypts the data by obscuring the relationship between
the data and the encrypted data. Additionally, this method spreads the
message out. Lastly, the key produced by AES is the secret to decrypting
it. Someone may know the method of AES, but without the key, they are
powerless.

To obscure and spread the data out, AES creates a
substitution-permutation network. Wikipedia has a wonderful [example of
an SP
network](https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/SubstitutionPermutationNetwork2.png/468px-SubstitutionPermutationNetwork2.png)
available. This network sends the data through a set of S boxes (using
the unique key) to substitute the bits with another block of bits. Then,
a P box will permutate, or rearrange, the bits. This is done over and
over, with the key being derived from the last round. For AES, the key
size specifies the number of transformation rounds: 10, 12, and 14
rounds for 128-bit, 192-bit, and 256-bit keys, respectively.

# The Process

1.  \*KeyExpansion=: Using [Rijndael\'s key
    schedule](https://en.m.wikipedia.org/wiki/Advanced_Encryption_Standard),
    the keys are dynamically generated.
2.  **AddRoundKey**: Each byte of the data is combined with this key
    using bitwise xor.
3.  **SubBytes**: This is followed by the substitution of each byte of
    data.
4.  **ShiftRows**: Then, the final three rows are shifted a certain
    number of steps, dictated by the cipher.
5.  **MixColumns**: After the rows have been shifted, the columns are
    mixed and combined.

This process does not necessarily stop after one full round. Steps 2
through 5 will repeat for the number of rounds specified by the key.
However, the final round excludes the MixColumns step. As you can see,
this is a fairly complex process. One must have a solid understanding of
general mathematic principles to fully understand how the sequence works
(and to even attempt to find a weakness).

According to research done by Bogdanov et al., it would take billions of
years to brute force a 126-bit key with current hardware. Additionally,
this brute force attack would require storing 2^88^ bits of data!
However, there are a few different attacks that have been used to show
vulnerabilities with the use of this technology. Side-channel attacks
use inadvertent leaks of data from the hardware or software, which can
allow attackers to obtain the key or run programs on a user\'s hardware.

Please note that this is not something you should run out and try to
implement in your `Hello, World!` app after only a few hours
of research. While AES (basically all encryption methods) is extremely
efficient in what it does, it takes a lot of time and patience to
understand. If you\'re looking for something which currently implements
AES, check out the [Legion of the Bouncy
Castle](https://www.bouncycastle.org/documentation.html) for Java
implementations of cryptographic algorithms.

# Why Does Encryption Matter?

There are limitless reasons to enable encryption at-rest or in-transit
for various aspects of your digital life. You can research specific
examples, such as [Australia passes new law to thwart strong
encryption](https://arstechnica.com/tech-policy/2018/12/australia-passes-new-law-to-thwart-strong-encryption/).
However, I will simply list a few basic reasons to always enable
encryption, where feasible:

1.  Privacy is a human right and is recognized as a national right in
    some countries (e.g., [US Fourth
    Amendment](https://www.law.cornell.edu/wex/fourth_amendment)).
2.  \"Why not?\" Encryption rarely affects performance or speed, so
    there\'s usually not a reason to avoid it in the first place.
3.  Your digital identity and activity (texts, emails, phone calls,
    online accounts, etc.) are extremely valuable and can result in
    terrible consequences, such as identity theft, if leaked to other
    parties. Encrypting this data prevents such leaks from ruining
    lives.
4.  Wiping or factory-resetting does not actually wipe all data from the
    storage device. There are methods to read data from the physical
    disks/boards inside devices.
5.  Corporations, governments, and other nefarious groups/individuals
    are actively looking for ways to collect personal information about
    anyone they can. If someone\'s data is unencrypted, that person may
    become a target due to the ease of data collection.

​**Read More:**

-   [Federal Information Processing Standards Publication
    197](http://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197.pdf)
