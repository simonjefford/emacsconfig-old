(defvar my-nick)
(defvar my-password)

(if (file-exists-p "~/.emacs.d/erc-credentials.el")
    (load "~/.emacs.d/erc-credentials.el")
  (message "Couldn't load credentials"))

(defun erc-enable-conference-mode ()
  (interactive)
  (setq erc-hide-list (quote ("JOIN" "QUIT" "MODE")))
  (setq erc-minibuffer-ignored t)
  (message "Now ignoring JOINs, QUITs, and MODEs"))

(defun erc-disable-conference-mode ()
  (interactive)
  (setq erc-hide-list nil)
  (setq erc-minibuffer-ignored nil)
  (message "Now showing everything"))

(global-set-key "\C-c\C-e" (lambda () (interactive)
                             (erc :server "irc.freenode.net"
                                  :port "6667"
                                  :nick my-nick
                                  :password my-password)))
