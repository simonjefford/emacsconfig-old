;(setq mac-command-modifier 'meta)
(setq visible-bell nil)

(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-c\C-k" 'kill-region)

(ansi-color-for-comint-mode-on)

(add-to-list 'load-path (concat dotfiles-dir "/vendor"))

(require 'textmate)
(textmate-mode)

(require 'setnu)

(require 'tidy)

(add-to-list 'load-path (concat dotfiles-dir "/vendor/color-theme"))
(require 'color-theme)
(color-theme-initialize)
;; (color-theme-blackboard)

(require 'color-theme-ir-black)
(color-theme-ir-black)
;; (color-theme-gtk-ide)

;; (add-to-list 'load-path (concat dotfiles-dir "/vendor/org-6.34c/lisp"))

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
While ack runs asynchronously, you can use the \\[next-error]
command to find the text that ack hits refer to. The command
actually run is defined by the ack-command variable."
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

(global-set-key (kbd "M->") '(lambda ()
                               (interactive)
                               (enlarge-window 1)))

(global-set-key (kbd "M-<") '(lambda ()
                               (interactive)
                               (shrink-window 1)))

(defun ruby-compilation-this-buffer-and-save ()
  "Save and run the current buffer through Ruby compilation."
  (interactive)
  (save-buffer)
  (ruby-compilation-this-buffer))

(add-hook 'ruby-mode-hook
          '(lambda ()
             (define-key ruby-mode-map "\C-xt"
               'ruby-compilation-this-buffer-and-save)))

(add-hook 'c-mode-hook
          '(lambda ()
             (define-key c-mode-map "\C-xt"
               'compile)))

(add-hook 'ruby-mode-hook 'ruby-electric-mode)
(require 'rspec-mode)

(defun load-haskell-stuff ()
  (interactive)
  (load "~/.emacs.d/vendor/haskell-mode-2.7.0/haskell-site-file")
  (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation))

(defun convert-markdown (filter)
  (let ((cmd (concat filter " " (buffer-name))))
    (if (and (boundp 'transient-mark-mode) transient-mark-mode mark-active)
        (shell-command-on-region (region-beginning) (region-end) cmd
                                 "*markdown-output*" nil)
      (shell-command-on-region (point-min) (point-max) cmd
                               "*markdown-output*" nil))))

(defun markdown-to-rtf ()
  "Run markdown on the current buffer, create an RTF file and
preview the results"
  (interactive)
  (convert-markdown "~/bin/mymark2rtf"))

(defun markdown-to-pdf ()
  "Run markdown on the current buffer, create a PDF file and
preview the results"
  (interactive)
  (convert-markdown "~/bin/mymark2pdf"))

(add-hook 'markdown-mode-hook
          '(lambda ()
             (define-key markdown-mode-map "\C-c\C-cf"
               'markdown-to-pdf)))

(add-hook 'markdown-mode-hook
          '(lambda ()
             (define-key markdown-mode-map "\C-c\C-cr"
               'markdown-to-rtf)))


(defun pretty-print-xml-buffer ()
  "Use bf-pretty-print-xml-region to pretty print the xml in the
buffer"
  (interactive)
  (bf-pretty-print-xml-region (point-min) (point-max)))

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


(add-hook 'nxml-mode-hook
          '(lambda ()
             (define-key nxml-mode-map "\C-c\C-p"
               'pretty-print-xml-buffer)))

(require 'csharp-mode)

(setq ns-pop-up-frames nil)

(require 'rvm)
(if (not (eq system-type 'windows-nt))
    (rvm-use-default))

(require 'haml-mode)
(require 'sass-mode)
(require 'multi-eshell)
(if (featurep 'aquamacs)
    (tabbar-mode -1))

(require 'multi-term)
(setq multi-term-program "/usr/local/bin/zsh")

(defun yank-to-gist ()
  "yank from the top of the kill ring, create a gist from it, and
insert the gist url at the point"
  (interactive)
  (save-excursion
    (let ((buffer (current-buffer)))
            (set-buffer (get-buffer-create "*yank-to-gist*"))
            (yank)
            (gist-region
             (point-min)
             (point-max)
             t
             (lexical-let ((buf buffer))
               (function (lambda (status)
                           (let ((location (cadr status)))
                             (set-buffer buf)
                             (message "Paste created: %s" location)
                             (insert location)
                             (kill-new location))))))
            (kill-buffer))))

(require 'go-mode-load)

(load (concat dotfiles-dir "growl.el"))

(add-hook 'slime-repl-mode-hook 'clojure-mode-font-lock-setup)

(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME"
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' alread exists!" new-name)
        (progn (rename-file name new-name 1)
               (rename-buffer new-name)
               (set-visited-file-name new-name)
               (set-buffer-modified-p nil))))))

(global-set-key "\C-cb" 'recompile)

(define-key isearch-mode-map (kbd "C-o")
  (lambda ()
    (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string
               (regexp-quote isearch-string))))))

(defun yas/advise-indent-function (function-symbol)
  (eval `(defadvice ,function-symbol (around yas/try-expand-first activate)
           ,(format
             "Try to expand a snippet before point, then call `%s' as usual"
             function-symbol)
           (let ((yas/fallback-behavior nil))
             (unless (and (interactive-p)
                          (yas/expand))
               ad-do-it)))))

(yas/advise-indent-function 'ruby-indent-line)

(defmacro cmd (name &rest body)
  "declare an interactive command without all the boilerplate"
  `(defun ,name ()
     (interactive)
     ,@body))

;; Setup ibuffer
(setq ibuffer-saved-filter-groups
      '(("home"
         ("emacs-config" (filename . ".emacs.d"))
         ("code" (filename . "code"))
         ("Magit" (name . "\*magit"))
         ("ERC" (mode . erc-mode))
         ("Help" (or (name . "\*Help\*")
		     (name . "\*Apropos\*")
		     (name . "\*info\*"))))))
(add-hook 'ibuffer-mode-hook
          '(lambda ()
             (ibuffer-switch-to-saved-filter-groups "home")
             (ibuffer-auto-mode 1)))
(setq ibuffer-show-empty-filter-groups nil)
(global-set-key (kbd "s-<return>") 'textmate-next-line)
