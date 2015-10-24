(req-package smart-mode-line
  :config
  (sml/setup)
  (sml/apply-theme 'respectful))

(req-package recentf
  :bind ("C-x C-r" . h/recentf-find-file)
  :demand
  :config
  (setq recentf-save-file (h/ed "state/recentf")
        recentf-exclude '(".ido.last")
        recentf-max-menu-items 1000
        recentf-max-saved-items 1000)

  (recentf-mode 1)

  (defun h/recentf-find-file ()
    "Find a recent file."
    (interactive)
    (let* ((file (completing-read "Recent files: " recentf-list nil t)))
      (when file
        (find-file file)))))

(req-package lacarte
  :bind ("M-`" . lacarte-execute-menu-command))

(req-package imenu
  :init
  (setq imenu-auto-rescan t))

(req-package highlight-symbol
  :commands highlight-symbol-mode highlight-symbol-nav-mode
  :init
  (add-hook 'prog-mode-hook #'highlight-symbol-mode)
  (add-hook 'prog-mode-hook #'highlight-symbol-nav-mode))

(req-package rainbow-delimiters
  :commands rainbow-delimiters-mode
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(req-package browse-kill-ring+
  :init
  (require 'browse-kill-ring+))

(req-package winner
  :config
  (winner-mode 1))

(req-package smartrep
  :require winner
  :config

  (smartrep-define-key
      global-map
      "C-x"
    '(("o" . other-window)
      ("O" . ace-window)
      ("0" . delete-window)
      ("1" . delete-other-windows)
      ("3" . split-window-horizontally)
      ("2" . split-window-vertically)
      ("B" . previous-buffer)
      ("DEL" . backward-kill-sentence)
      ("C-t" . transpose-lines)
      ))

  (smartrep-define-key
      winner-mode-map
      "C-c"
    '(("<left>" . winner-undo))))

(req-package back-button
  :diminish " ☜"
  :require smartrep
  :config
  (back-button-mode 1)

  (bind-key "M-<f8>" #'back-button-local-backward back-button-mode-map)
  (bind-key "M-<f9>" #'back-button-local-forward back-button-mode-map)
  (bind-key "<XF86Back>" #'back-button-local-backward back-button-mode-map)
  (bind-key "<XF86Forward>" #'back-button-local-forward back-button-mode-map)
  (bind-key "M-<XF86Back>" #'back-button-global-backward back-button-mode-map)
  (bind-key "M-<XF86Forward>" #'back-button-global-forward back-button-mode-map))

(req-package savehist
  :config
  (setq savehist-file (h/sd "savehist")
        savehist-additional-variables
        '(search-ring regexp-search-ring kill-ring
                      read-expression-history))

  (savehist-mode 1))

;; ??
(req-package clipmon
  :config
  (clipmon-mode))

(req-package color-moccur
  :commands moccur moccur-grep)
