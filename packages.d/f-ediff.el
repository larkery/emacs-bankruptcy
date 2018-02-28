;; -*- lexical-binding: t -*-
(initsplit-this-file bos "ediff-")

(defun ediff-expand-org-mode ()
  (when (derived-mode-p 'org-mode)
    (org-cycle '(64))))

(add-hook 'ediff-prepare-buffer-hook 'ediff-expand-org-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ediff-window-setup-function (quote ediff-setup-windows-plain)))
