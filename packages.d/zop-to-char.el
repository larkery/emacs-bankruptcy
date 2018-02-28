;; -*- lexical-binding: t -*-
(req-package zop-to-char
  :commands zop-to-char
  :bind ("M-S-z" . zop-up-to-char)
  :init
  (global-set-key [remap zap-to-char] 'zop-to-char))
