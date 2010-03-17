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

(require 'setnu)

(add-to-list 'load-path (concat dotfiles-dir "/vendor/color-theme"))
(require 'color-theme)
(color-theme-initialize)
(color-theme-blackboard)

(add-to-list 'load-path (concat dotfiles-dir "/vendor/org-6.34c/lisp"))

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)


(require 'edit-server)
(edit-server-start)
(idle-highlight)
(require 'ack-emacs)

(defun ack-in-project (pattern)
  "Run ack, with user-specified ARGS, and collect output in a buffer.
While ack runs asynchronously, you can use the \\[next-error] command to
find the text that ack hits refer to. The command actually run is
defined by the ack-command variable."
  (interactive (list (read-string "Ack for (in app root): " (thing-at-point 'symbol))))
 
  (let (compile-command
        (compilation-error-regexp-alist grep-regexp-alist)
        (compilation-directory default-directory)
        (ack-full-buffer-name (concat "*ack-" pattern "*")))

    ;; lambda defined here since compilation-start expects to call a function to get the buffer name
    (compilation-start (concat ack-command " -i  --noheading --nocolor " pattern " " (rinari-root)) 'ack-mode
                       (when ack-use-search-in-buffer-name
                         (function (lambda (ignore)
                                     ack-full-buffer-name)))
                       (regexp-quote pattern))))

(global-set-key "\C-cfa" 'ack-in-project)

