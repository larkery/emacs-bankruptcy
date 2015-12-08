;;; Encoding

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;;; Misc

(setq-default indent-tabs-mode nil)
(setq-default case-fold-search t)

(add-hook 'text-mode-hook #'visual-line-mode)

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(setq-default abbrev-mode nil)
