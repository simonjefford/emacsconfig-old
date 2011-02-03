(set-face-font 'default "Consolas 10")
(defun server-ensure-safe-dir (dir) "Noop" t)
(server-start)
(global-set-key "\M-3" "#")

(add-to-list 'auto-mode-alist '("\\.cls$" . fundamental-mode))

