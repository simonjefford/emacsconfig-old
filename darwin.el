(if (display-graphic-p)
    (progn
      (global-set-key "\M-3" "#")
      (set-face-font 'default "-apple-Menlo-medium-normal-normal-*-12-*-*-*-m-0-iso10646-1")))

(load "growl.el")
(setq ecb-source-path (quote ("~/code/rails" "~/code/redis" "~/code/MyJob" "~/.emacs.d" "~/code/delivery_manager")))

