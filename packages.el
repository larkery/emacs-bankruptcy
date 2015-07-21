(req-package magit
  :commands magit
  :bind ("C-c g" . magit-status)
  :config
  (setq magit-last-seen-setup-instructions "1.4.0"))

(req-package guide-key
  :diminish guide-key-mode
  :init
  (setq guide-key/idle-delay 0.5
        guide-key/recursive-key-sequence-flag t
        guide-key/popup-window-position 'bottom
        guide-key/guide-key-sequence    '("C-h" "C-x" "C-c" "C-z"))
  (guide-key-mode 1))

(req-package avy
  :bind
  (("C-c ;" . avy-goto-line)
   ("C-c '" . avy-goto-word-1)
   ("C-c #" . avy-goto-word-0)))

(req-package smart-mode-line
  :config
  (sml/setup)
  (sml/apply-theme 'dark))

(req-package org
  :bind
  (("C-c a" . org-agenda)
   ("C-c l" . org-capture)))

(req-package smartparens
  :config
  (sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)
  (sp-with-modes sp--lisp-modes
    (sp-local-pair "(" nil :bind "C-("))
  
  (sp-with-modes '(html-mode nxml-mode sgml-mode)
    (sp-local-pair "<" ">"))

  (sp-with-modes sp--lisp-modes
    (sp-local-pair "'" nil :actions nil))
  
  (sp-local-tag '(html-mode nxml-mode sgml-mode)
                "<"  "<_>" "</_>" :transform 'sp-match-sgml-tags)

  (show-smartparens-global-mode t)
  (smartparens-global-mode t)

  (define-key smartparens-mode-map (kbd "C-M-f") 'sp-forward-sexp)
  (define-key smartparens-mode-map (kbd "C-M-b") 'sp-backward-sexp)
  (define-key smartparens-mode-map (kbd "C-M-9") 'sp-forward-slurp-sexp)
  (define-key smartparens-mode-map (kbd "C-M-0") 'sp-forward-barf-sexp))


(req-package multiple-cursors
  :bind (("C-;" . mc/mark-all-like-this-dwim)
	 ("C-'" . mc/mark-next-like-this)))

(req-package expand-region
  :bind ("C-=" . er/expand-region))


(req-package projectile)

(req-package smartscan
  :config
  (add-hook 'prog-mode-hook #'smartscan-mode)
  (bind-key "M-p" #'smartscan-symbol-go-backward prog-mode-map)
  (bind-key "M-p" #'smartscan-symbol-go-forward prog-mode-map))

(req-package undo-tree
  :diminish undo-tree-mode
  :init
  (global-undo-tree-mode))
  
(req-package notmuch)

(req-package graphviz-dot-mode)

(req-package ess)
(req-package ess-smart-underscore)

(req-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(req-package rainbow-identifiers
  :config
  (add-hook 'prog-mode-hook 'rainbow-identifiers-mode))

(req-package saveplace
  :config
  (setq-default save-place t)
  (setq save-place-file (h/ed "temp/saved-places")))
  
(req-package dired+
  :commands dired)

(req-package recentf
  :config
  (recentf-mode 1)
  (setq recentf-max-menu-items 100))

(req-package wgrep
  :init
  (require 'wgrep))

(req-package cider)

(req-package ag)

(req-package lacarte
  :bind ("M-`" . lacarte-execute-menu-command))


(req-package helm
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x b" . helm-buffers-list)
         ("C-x C-r" . helm-recentf))
  
  :config
  (setq helm-echo-input-in-header-line nil
        helm-quick-update t
        helm-idle-delay 0.01
        helm-input-idle-delay 0.01
        helm-always-two-windows nil
        helm-ff-auto-update-initial-value nil
        helm-display-header-line nil
        helm-autoresize-max-height 40
        helm-autoresize-min-height 40
        helm-ff-skip-boring-files nil
        helm-boring-file-regexp-list '("\\.$" "\\.\\.$" "\\..+$")
        )
  
  (set-face-attribute 'helm-source-header
                        nil
                        :foreground (face-attribute 'helm-selection :foreground)
                        :background (face-attribute 'helm-selection :background)
                        :box nil
                        :height 0.1)
  
  (bind-key "<tab>" 'helm-execute-persistent-action helm-map)
  (bind-key "C-i" 'helm-execute-persistent-action helm-map)
  (bind-key "`" 'helm-select-action helm-map)
  (bind-key "C-z" 'helm-select-action helm-map)

  (bind-key "C-." (lambda ()
                    (interactive)
                    (setq helm-ff-skip-boring-files (not helm-ff-skip-boring-files))
                    (helm-update))
            helm-map)

  (defun h/helm-fonts ()
    (interactive)
    (with-helm-buffer
      (setq line-spacing 1)
      (buffer-face-set '(:family "terminus" :height 98))))

  (add-hook 'helm-after-initialize-hook #'h/helm-fonts)
  
  (helm-mode 1)
  (helm-autoresize-mode 1))

(req-package helm-swoop
  :bind ("C-." . helm-swoop))
