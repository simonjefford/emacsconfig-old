;(setq mac-command-modifier 'meta)
(setq visible-bell nil)

(if (eq system-type 'darwin)
    (set-face-font 'default "-apple-Menlo-medium-normal-normal-*-12-*-*-*-m-0-iso10646-1")
  (set-face-font 'default "Inconsolata 11"))

(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

(ansi-color-for-comint-mode-on)

(add-to-list 'load-path (concat dotfiles-dir "/vendor"))
(require 'textmate)
(textmate-mode)

(color-theme-blackboard)
