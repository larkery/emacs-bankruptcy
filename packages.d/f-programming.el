(defvar my-prog-mode-hook ())
(defun my-run-prog-mode-hook () (run-hooks 'my-prog-mode-hook))
(add-hook 'prog-mode-hook #'my-run-prog-mode-hook)

(req-package highlight-symbol
  :diminish ""
  :commands highlight-symbol-mode highlight-symbol-nav-mode
  :init
  (add-hook 'my-prog-mode-hook #'highlight-symbol-mode)
  (add-hook 'my-prog-mode-hook #'highlight-symbol-nav-mode)
  :config
  (bind-key "M-s s" #'highlight-symbol-occur highlight-symbol-nav-mode-map))

(req-package eldoc
  :init
  (add-hook 'h-prog-mode-hook #'eldoc-mode)
  :commands eldoc-mode
  :config
  (diminish 'eldoc-mode ""))

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

(req-package key-combo
  :commands key-combo-mode
  :init
  (add-hook 'my-prog-mode-hook 'key-combo-mode)
  :config
  (key-combo-define-hook '(ess-mode-hook)
                         'my-ess-combo-hook
                         '(("<" . ("<" "<- "))
                           (">" . (">" "%>%\n")))))
