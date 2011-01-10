(global-set-key "\M-3" "#")
(set-face-font 'default "-apple-Menlo-medium-normal-normal-*-12-*-*-*-m-0-iso10646-1")

(defvar growl-program "growlnotify")

(defun growl (title message)
  (start-process "growl" " growl"
                 growl-program
                 title
                 "-a" "Emacs")
  (process-send-string " growl" message)
  (process-send-string " growl" "\n")
  (process-send-eof " growl"))

(defun growl-interactive (message)
  (interactive (list (read-string "Message: ")))
  (growl "emacs" message))

(setq aquamacs-scratch-file nil
      initial-major-mode 'emacs-lisp-mode)

(server-start)
