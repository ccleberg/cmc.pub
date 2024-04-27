+++
date = 2023-01-05
title = "	How to Easily Mass Unlike Tumblr Posts with Javascript"
description = ""
draft = false
+++

# The Dilemma

The dilemma I had was pretty simple: I wanted to unlike all the posts I
have liked on Tumblr so that I could follow a new focus on blogs and
start fresh. Otherwise, Tumblr will keep recommending content based on
your previous likes.

# The Solution

I searched the web for a while and noted that most solutions referenced
Tumblr setting and dashboard pages that no longer exist. Additionally, I
did not want to install a third party extension to do this, as some
suggested.

Luckily, I used Javascript for a while a few years ago and figured it
would be easy enough to script a solution, as long as Tumblr had a
system for the unlike buttons.

## Identifying Unlike Buttons

Tumblr\'s unlike buttons are structured as you can see in the following
code block. All unlike buttons have an `aria-label` with a
value of `Unlike`.

``` html
<button class="TRX6J" aria-label="Unlike">
  <span class="EvhBA B1Z5w ztpfZ" tabindex="-1">
    <svg xmlns="http://www.w3.org/2000/svg" height="21" width="23" 
    role="presentation">
      <use href="#managed-icon__like-filled"></use>
    </svg>
  </span>
</button>
```

## Running a Script to Unlike All Likes

To run this script, you will need to load the [Likes \|
Tumblr](https://www.tumblr.com/likes) page while logged in to your
account.

Further, be sure to scroll down to the bottom and force Tumblr to load
more posts so that this script unlikes more posts at a time.

Once you are logged in and the page is loaded, open the Developer Tools
and be sure you\'re on the \"Console\" tab. It should look something
like this (this is in Firefox, Chromium should be similar):

![Firefox Dev
!Tools](https:///img.cleberg.net/blog/20230105-mass-unlike-tumblr-posts/dev_console.png)

All you need to do is paste the following snippet into the dev console.
This code will collect all unlike buttons (`elements`) and
then click each button to unlike it.

Optionally, you can comment-out the line
`elements[i].click();` and uncomment the
`console.log()` lines to simply print out information without
performing any actions. This can be useful to debug issues or confirm
that the code below isn\'t doing anything you don\'t want it to.

``` javascript
const elements = document.querySelectorAll('[aria-label="Unlike"]');
// console.log(elements); // 👉 [button]

for (let i=0; i < elements.length; i++) {
  // console.log(elements[i]);
  elements[i].click();
} 
```

# Results

The results were quick for my situation, as it unliked \~200 posts
within 2-3 seconds. I am not sure how this will perform on larger sets
of likes (or if Tumblr has a limit to unliking posts).

You can see the below screenshot showing that I pasted the snippet into
the console, pressed Enter, and then the posts are automatically
unliked.

![Script
!Results](https:///img.cleberg.net/blog/20230105-mass-unlike-tumblr-posts/script_results.png)

Thinking about this further, I would bet that this would be fairly
simple to package into a browser add-on so that users could install the
add-on, go to their Likes page, and click a button to run the script.
Food for thought.
