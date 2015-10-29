(req-package avy
  :bind
  (("M-g g" . avy-goto-line)
   ("M-g M-g" . avy-goto-line)
   ("M-g w" . avy-goto-word-1)
   ("M-g M-w" . avy-goto-word-0)
   ("M-g M-c" . avy-goto-char)))

(req-package adaptive-wrap
  :commands adaptive-wrap-prefix-mode
  :init
  (add-hook 'visual-line-mode-hook #'adaptive-wrap-prefix-mode))

(req-package expand-region :bind ("C-#" . er/expand-region))

(req-package undo-tree
  :diminish undo-tree-mode
  :init
  (global-undo-tree-mode)
  (global-set-key (kbd "C-z") 'undo)
  (defalias 'redo 'undo-tree-redo)
  (global-set-key (kbd "C-S-z") 'redo)
  (global-set-key (kbd "C-M-z") 'undo-tree-visualize))

(req-package saveplace
  :init
  (setq-default save-place t)
  (setq save-place-file (h/ed "state/saved-places")))

(req-package hippie-exp
  :init
  (bind-key* "M-?" (make-hippie-expand-function '(try-expand-line) t)))

(req-package wgrep
  :init
  (require 'wgrep))

(req-package ag)

(req-package visual-regexp-steroids
  :require pcre2el
  :bind (("C-c r" . vr/replace)
         ("C-c q" . vr/query-replace)
         ("C-c m" . vr/mc-mark)
         ("C-r" . vr/isearch-backward)
         ("C-s" . vr/isearch-forward))
  :config
  (setq vr/engine 'pcre2el))

(req-package anzu
  :diminish ""
  :config
  (global-anzu-mode +1))

(req-package ws-butler
  :diminish ""
  :commands ws-butler-global-mode
  :init
  (ws-butler-global-mode))

(req-package yasnippet
  :diminish (yas-minor-mode . " ⇥")
  :config
  (yas-global-mode))

(defun h/tabulate ()
  (interactive)
  (let ((a (region-beginning))
        (b (region-end)))
    (align-regexp
     a b
     "\\(\\s-*\\) "
     0
     1
     t)
    (indent-region a b)))

(bind-key "C-x t" #'h/tabulate)

(req-package zzz-to-char
  :bind ("M-z" . zzz-to-char))

(req-package comment-dwim-2
  :bind ("M-;" . comment-dwim-2))

(req-package iy-go-to-char
  :bind (("C-c s" . iy-go-up-to-char)
         ("C-c r" . iy-go-up-to-char-backward)))

(req-package multiple-cursors
  :bind (("C-; C-;" . mc/mark-all-like-this-dwim)
         ("C-; C-a" . mc/edit-beginnings-of-lines)
         ("C-; C-e" . mc/edit-ends-of-lines)
         ("C-<" . mc/mark-previous-like-this)
         ("C->" . mc/mark-next-like-this))
  :config
  (setq mc/list-file (h/ed "state/mc-list-file.el"))
  (require 'mc-hide-unmatched-lines-mode)
  (bind-key "C-;" #'mc-hide-unmatched-lines-mode mc/keymap))

(req-package smartparens
  :require hydra
  :config

  (require 'smartparens-config)

  (defhydra hydra-parens ()
    "Parens"
    ;; not sure
    ("[" (sp-wrap-with-pair "["))
    ("(" (sp-wrap-with-pair "("))
    ("{" (sp-wrap-with-pair "{"))
    ("\"" (sp-wrap-with-pair "\""))
    ("|" sp-split-sexp "split")
    ("+" sp-join-sexp "join")
    ("t" sp-transpose-hybrid-sexp "trans")
    ("~" sp-convolute-sexp "conv")
    ("<backspace>" sp-backward-kill-sexp))

  (bind-keys
   :keymap smartparens-mode-map

   ("C-~" . hydra-parens/body)

   ("M-<up>" . sp-backward-up-sexp)
   ("M-<down>" . sp-down-sexp)
   ("M-S-<down>" . sp-up-sexp)
   ("C-M-k" . sp-kill-hybrid-sexp)

   ("M-<right>" . sp-forward-sexp)
   ("M-<left>" . sp-backward-sexp)

   ("C-S-<right>" . sp-slurp-hybrid-sexp)
   ("C-S-<left>"  . sp-forward-barf-sexp)
   ("C-S-<up>"    . sp-backward-slurp-sexp)
   ("C-S-<down>"  . sp-backward-barf-sexp))


  (show-smartparens-global-mode t)
  (smartparens-global-mode t))

(req-package swiper :bind ("C-S-S" . swiper))
(req-package mwim :bind (("C-e" . mwim-end-of-code-or-line)))
