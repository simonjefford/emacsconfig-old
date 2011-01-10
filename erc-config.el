(defvar my-nick)
(defvar my-password)

(if (file-exists-p "~/.emacs.d/erc-credentials.el")
    (load "~/.emacs.d/erc-credentials.el")
  (message "Couldn't load credentials"))

(global-set-key "\C-c\C-e" (lambda () (interactive)
                             (erc :server "irc.freenode.net"
                                  :port "6667"
                                  :nick my-nick
                                  :password my-password)))
