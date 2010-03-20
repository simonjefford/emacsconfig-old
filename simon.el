;(setq mac-command-modifier 'meta)
(setq visible-bell nil)

(if (eq system-type 'darwin)
    (set-face-font 'default "-apple-Menlo-medium-normal-normal-*-12-*-*-*-m-0-iso10646-1")
  (set-face-font 'default "Inconsolata 11"))

(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

(global-set-key "\M-3" "#")

(ansi-color-for-comint-mode-on)

(add-to-list 'load-path (concat dotfiles-dir "/vendor"))

(require 'textmate)
(textmate-mode)

(require 'setnu)

(require 'tidy)

(add-to-list 'load-path (concat dotfiles-dir "/vendor/color-theme"))
(require 'color-theme)
(color-theme-initialize)
(color-theme-blackboard)

(add-to-list 'load-path (concat dotfiles-dir "/vendor/org-6.34c/lisp"))

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(add-to-list 'load-path (concat dotfiles-dir "/vendor/coffee-mode"))
(require 'coffee-mode)

(defun coffee-custom ()
  "coffee-mode-hook"

  (define-key coffee-mode-map [(meta r)] 'coffee-compile-buffer))

(add-hook 'coffee-mode-hook '(lambda () (coffee-custom)))

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

(global-set-key (kbd "s-<") 'beginning-of-buffer)
(global-set-key (kbd "s->") 'end-of-buffer)

(defun ruby-compilation-this-buffer-and-save ()
  "Save and run the current buffer through Ruby compilation."
  (interactive)
  (save-buffer)
  (ruby-compilation-this-buffer))

(add-hook 'ruby-mode-hook
          '(lambda ()
             (define-key ruby-mode-map "\C-xt"
               'ruby-compilation-this-buffer-and-save)))

(add-hook 'ruby-mode-hook 'ruby-electric-mode)

(require 'rspec-mode)

;; Haskell mode
(load "~/.emacs.d/vendor/haskell-mode-2.7.0/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(defun markdown-to-pdf ()
  "Run markdown on the current buffer and preview the output in another buffer."
  (interactive)
    (if (and (boundp 'transient-mark-mode) transient-mark-mode mark-active)
        (shell-command-on-region (region-beginning) (region-end) "~/bin/mymark2pdf"
                                 "*markdown-output*" nil)
      (shell-command-on-region (point-min) (point-max) "~/bin/mymark2pdf"
                               "*markdown-output*" nil)))

(defun markdown-to-rtf ()
  "Run markdown on the current buffer and preview the output in another buffer."
  (interactive)
    (if (and (boundp 'transient-mark-mode) transient-mark-mode mark-active)
        (shell-command-on-region (region-beginning) (region-end) "~/bin/mymark2rtf"
                                 "*markdown-output*" nil)
      (shell-command-on-region (point-min) (point-max) "~/bin/mymark2rtf"
                               "*markdown-output*" nil)))

(add-hook 'markdown-mode-hook
          '(lambda ()
             (define-key markdown-mode-map "\C-c\C-cf"
               'markdown-to-pdf)))

(add-hook 'markdown-mode-hook
          '(lambda ()
             (define-key markdown-mode-map "\C-c\C-cr"
               'markdown-to-rtf)))

(add-hook 'coding-hook 'setnu-mode)

(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
      (nxml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t) 
        (backward-char) (insert "\n"))
      (indent-region begin end))
    (message "Ah, much better!"))
(server-start)
