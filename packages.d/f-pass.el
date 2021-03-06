;; -*- lexical-binding: t -*-
(initsplit-this-file bos (| "auth-pass" "pass-"))

(req-package pass
  :commands pass
  :config
  (defun my-pass-display-item (o item &optional indent-level)
    (unless (and (listp item)
                 (string= ".git" (car item)))
      (funcall o item indent-level)))

  (advice-add 'pass-display-item :around 'my-pass-display-item))

(req-package auth-source-pass
  :demand
  :config
  (auth-source-pass-enable))
