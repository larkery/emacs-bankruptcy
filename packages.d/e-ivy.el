(initsplit-this-file bos (| "counsel-" "ivy-"))

;; this actually works with completing read so we're good
(el-get-bundle larkery/ido-describe-prefix-bindings.el)

(req-package ido-describe-prefix-bindings
  :demand
  :bind ("M-X" . ido-describe-mode-bindings)
  :config
  (require 's)
  (ido-describe-prefix-bindings-mode 1))

(req-package ivy
  :diminish ""
  :config
  (ivy-mode 1))
(req-package counsel
  :diminish ""
  :config
  (counsel-mode 1))
(req-package counsel-projectile
  :config
  (counsel-projectile-on))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(counsel-find-file-ignore-regexp "\\`\\.")
 '(ivy-use-virtual-buffers t))
