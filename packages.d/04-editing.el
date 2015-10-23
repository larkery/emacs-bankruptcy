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
  :bind (("C-;" . mc/mark-all-like-this-dwim)
         ("C-:" . mc/edit-beginnings-of-lines)
         ("C-<" . mc/mark-previous-like-this)
         ("C->" . mc/mark-next-like-this)
         ;("M-[" . (lambda () (interactive) (mc/create-fake-cursor-at-point)))
         ;("M-]" . (lambda () (interactive) (mc/maybe-multiple-cursors-mode)))
         )
  :config
  (setq mc/list-file (h/ed "state/mc-list-file.el"))

  (require 'mc-hide-unmatched-lines-mode)
  (bind-key "C-;" #'mc-hide-unmatched-lines-mode mc/keymap))

(req-package smartparens
  :config
  (require 'smartparens-config)
  (sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)
  (sp-with-modes sp--lisp-modes
    (sp-local-pair "(" nil :bind "C-("))
  
  (sp-with-modes '(html-mode nxml-mode sgml-mode)
    (sp-local-pair "<" ">"))

  (sp-with-modes sp--lisp-modes
    (sp-local-pair "'" nil :actions nil))
  
  (sp-local-tag '(html-mode nxml-mode sgml-mode)
                "<"  "<_>" "</_>" :transform 'sp-match-sgml-tags)

  (setf blink-matching-paren nil)
  (show-smartparens-global-mode t)
  (smartparens-global-mode t)

  (define-key smartparens-mode-map (kbd "C-M-f") 'sp-forward-sexp)
  (define-key smartparens-mode-map (kbd "C-M-b") 'sp-backward-sexp)
  (define-key smartparens-mode-map (kbd "C-M-9") 'sp-forward-slurp-sexp)
  (define-key smartparens-mode-map (kbd "C-M-0") 'sp-forward-barf-sexp))

(req-package swiper
  :bind ("C-S-S" . swiper))
