(add-to-list 'load-path "/usr/local/lib/erlang/lib/tools-2.6.5.1/emacs")
(setq erlang-root-dir "/usr/local/lib/erlang")
(require 'erlang-start)

(set-frame-position (selected-frame) 800 100)
(set-frame-size (selected-frame) 150 70)

(require 'peepopen)
(add-to-list 'load-path "/usr/local/Cellar/scala/2.8.0/misc/scala-tool-support/emacs")
(require 'scala-mode-auto)

(defun me-turn-off-indent-tabs-mode ()
  (setq indent-tabs-mode nil))
(add-hook 'scala-mode-hook 'me-turn-off-indent-tabs-mode)
