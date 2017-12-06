(initsplit-this-file bos (| "web-mode" "js2-mode"))

(req-package web-mode
  :mode (("\\.html\\'" . web-mode))
  )

(req-package js2-mode
  :mode (("\\.js\\'" . js2-mode))
  )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(web-mode-markup-indent-offset 2))
