# Gitmoji for Emacs

The purpose of this package is to make it easier to insert [gitmoji] into a commit message buffer.

I started writing this package because I was never able to find the emoji I was looking for with the `emojify-insert-emoji` function from [emojify].
For instance, I could never remember that I needed to search for "High Voltage Sign" when I wanted ⚡, and I would usually try words like like "zap", "electricity", "lightning", "bolt", etc.
Instead of having to remember unicode names, I'd much rather search for the [gitmoji] meaning (in this case "improve performance"), or the Github name ("zap").

## Installation
This package is not yet available on any package repositories, so it has to be installed directly from Github for now, sorry.

If you use [Doom Emacs], declare the package in your `packages.el` like this: 

``` emacs-lisp
;; ~/.doom.d/packages.el
(package! gitmoji
  :recipe (:host github
           :repo "janusvm/emacs-gitmoji"
           :files ("*.el" "data")))
```

## Usage
Run `M-x gitmoji-insert-emoji` to prompt for an emoji to insert at the point.

In my personal config, I have it bound to `SPC i g` (for "insert Gitmoji").

## Notes
This is my first Emacs package, and I'm still learning all the ins and outs of everything.
Please submit an issue, if something doesn't work.

[gitmoji]: https://github.com/carloscuesta/gitmoji
[emojify]: https://github.com/iqbalansari/emacs-emojify
[Doom Emacs]: https://github.com/hlissner/doom-emacs
