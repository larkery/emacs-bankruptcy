;; -*- lexical-binding: t -*-
(initsplit-this-file bos "pdf-")

(req-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-tools-enable-minor-modes))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(pdf-info-epdfinfo-program "/home/hinton/.nix-profile/bin/epdfinfo")
 '(pdf-view-midnight-colors (quote ("#eeeeee" . "#000000"))))
