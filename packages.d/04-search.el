(req-package avy
  :bind
  (("M-g g" . avy-goto-line)
   ("M-g M-g" . avy-goto-line)
   ("M-g w" . avy-goto-word-1)
   ("M-g M-w" . avy-goto-word-0)
   ("M-g M-c" . avy-goto-char)))

(req-package wgrep
  :init
  (require 'wgrep))

(req-package ag)

(req-package phi-search
  :bind (("C-s" . phi-search)
         ("C-r" . phi-search-backward)
         ("M-%" . phi-replace-query)))

(req-package iy-go-to-char
  :bind (("C-c s" . iy-go-up-to-char)
         ("C-c r" . iy-go-up-to-char-backward)))

;;(req-package swiper :bind ("C-S-S" . swiper))

(req-package swoop
  :commands swoop swoop-multi swoop-pcre-regexp swoop-back-to-last-position swoop-from-isearch swoop-multi-from-swoop
  :bind (("C-S-S" . swoop-pcre-regexp))
  :config
  (setq swoop-font-size-change: nil)
  (bind-key "C-S-S" 'swoop-multi-from-swoop swoop-map))
