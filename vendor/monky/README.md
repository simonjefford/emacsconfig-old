# Monky An Emacs mode for Hg

Monky provides an interactive interface for Hg.

## Installation

````cl
(add-to-list 'load-path "path/to/monky/dir")
(require 'monky)
````

## Usage

open any file in a hg repo and run `M-x monky-status` to see the
current status. Look at the [documentation][monky-documentation] for further details.

## Thanks

Heavily borrowed from [Magit][magit]. Thanks to Marius Vollmer.

[magit]: http://github.com/magit/magit
[monky-documentation]: http://ananthakumaran.github.com/monky/index.html
