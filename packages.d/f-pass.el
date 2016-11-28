(initsplit-this-file bos (| "auth-pass" "pass-"))

(req-package pass
  :commands pass
  :config
  (defun my-pass-display-item (o item &optional indent-level)
    (unless (and (listp item)
                 (string= ".git" (car item)))
      (funcall o item indent-level)))

  (advice-add 'pass-display-item :around 'my-pass-display-item))

(req-package auth-password-store
  :demand
  :config
  (auth-pass-enable))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(pass-mode-directory-face ((t (:inherit highlight)))))
