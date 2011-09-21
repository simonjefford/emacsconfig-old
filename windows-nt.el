(set-face-font 'default "Consolas 10")
(defun server-ensure-safe-dir (dir) "Noop" t)
(server-start)
(global-set-key "\M-3" "#")

(add-to-list 'auto-mode-alist '("\\.cls$" . fundamental-mode))

(defun open-repository (batchguid)
  (interactive "sEnter batchguid: ")
  (let ((path (concat "//ds-hosp-wn.abs-local.com/tradesimple/_Core/Documents/Repository/" batchguid)))
    (dired path)))

(global-set-key (kbd "M-<") 'beginning-of-buffer)
(global-set-key (kbd "M->") 'end-of-buffer)
