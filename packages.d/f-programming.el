;; -*- lexical-binding: t -*-
(initsplit-this-file bos (| "highlight-parentheses" "highlight-symbol" "eldoc"))

(defvar my-prog-mode-hook ())
(defun my-run-prog-mode-hook () (run-hooks 'my-prog-mode-hook))
(add-hook 'prog-mode-hook #'my-run-prog-mode-hook)

(req-package hl-todo
  :commands hl-todo-mode
  :init
  (add-hook 'my-prog-mode-hook 'hl-todo-mode))

(req-package highlight-parentheses
  :diminish ""
  :commands highlight-parentheses-mode
  :init
  (add-hook 'my-prog-mode-hook 'highlight-parentheses-mode))

(req-package highlight-symbol
  :ensure t
  :diminish ""
  :commands highlight-symbol-mode highlight-symbol-nav-mode
  :init
  (add-hook 'my-prog-mode-hook #'highlight-symbol-mode)
  (add-hook 'my-prog-mode-hook #'highlight-symbol-nav-mode)
  :config
  (bind-key "M-s O" #'highlight-symbol-occur highlight-symbol-nav-mode-map)
  (setq highlight-symbol-highlight-single-occurrence nil
        highlight-symbol-on-navigation-p t
        highlight-symbol-idle-delay 5))

(req-package eldoc
  :init
  (add-hook 'h-prog-mode-hook #'eldoc-mode)
  :commands eldoc-mode
  :diminish eldoc-mode
  )

(req-package anaconda-mode
  :commands anaconda-mode
  :init
  (add-hook 'python-mode-hook #'anaconda-mode)
  (add-hook 'python-mode-hook #'anaconda-eldoc-mode)
  :config
  (bind-key "C-c C-f" 'anaconda-mode-show-doc python-mode-map))

(req-package python
  :defer t
  :config
  (setq python-shell-interpreter "python3"))

(req-package comment-dwim-2
  :bind ("M-;" . comment-dwim-2))

(req-package editorconfig
  :diminish ""
  :config
  (editorconfig-mode 1))

(req-package key-combo
  :diminish ""
  :commands key-combo-mode key-combo-define-hook
  :init
  (add-hook 'my-prog-mode-hook 'key-combo-mode))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(highlight-symbol-foreground-color nil)
 '(highlight-symbol-highlight-single-occurrence nil)
 '(highlight-symbol-on-navigation-p t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(highlight-symbol-face ((t (:inherit isearch)))))
