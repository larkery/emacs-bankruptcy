;; (el-get-bundle larkery/ido-grid-mode.el)
(el-get-bundle larkery/ido-match-modes.el)
(el-get-bundle larkery/ido-describe-prefix-bindings.el)

(req-package ido-match-modes
  :require ido-grid-mode
  :config
  (ido-match-modes-toggle 1))

(req-package ido
  :demand
  :config
  (setq ido-create-new-buffer 'always
        ido-use-filename-at-point 'guess
        ido-save-directory-list-file (h/ed "state/ido.last")
        ido-use-faces t)
  (ido-mode 1)
  (ido-everywhere 1)

  (defun h/ido-keys ()
    (define-key ido-completion-map (kbd "M-a") 'ido-toggle-ignore)
    (define-key ido-completion-map (kbd "C-a") 'beginning-of-line))

  (add-hook 'ido-setup-hook #'h/ido-keys))

(req-package ido-ubiquitous
  :config
  (message "making ido ubiquitous")
  (ido-ubiquitous-mode))

(req-package ido-grid-mode
  :require (ido ido-ubiquitous)
  :config
  (setq ido-grid-mode-start-collapsed t
        ido-grid-mode-jank-rows 0
        ido-grid-mode-order 'columns
        ido-grid-mode-scroll-up #'ido-grid-mode-previous-row
        ido-grid-mode-scroll-down #'ido-grid-mode-next-row
        ido-grid-mode-prefix-scrolls t
        ido-grid-mode-scroll-wrap nil
        ido-grid-mode-max-columns nil
        ido-grid-mode-jump 'label
        ido-grid-mode-prefix "->"
        ido-grid-mode-exact-match-prefix ">>  "
        ido-grid-mode-padding "  ")

  (ido-grid-mode 1)

  (defun h/advise-grid-tall (o &rest args)
    (let ((ido-grid-mode-min-rows 1)
          (ido-grid-mode-max-rows 15)
          (ido-grid-mode-max-columns 1)
          (ido-grid-mode-order nil)
          (ido-grid-mode-start-collapsed nil))
      (apply o args)))

  (advice-add 'ido-describe-prefix-bindings :around #'h/advise-grid-tall)
  (advice-add 'h/recentf-find-file :around #'h/advise-grid-tall)
  (advice-add 'ido-occur :around #'h/advise-grid-tall)
  (advice-add 'lacarte-execute-menu-command :around #'h/advise-grid-tall))

(req-package ido-at-point
  :config
  (ido-at-point-mode 1))

(req-package ido-exit-target
  :config
  (require 'ido-exit-target))

(req-package ido-describe-prefix-bindings
  :config
  (ido-describe-prefix-bindings-mode 1))

(req-package smex
  :commands smex
  :require (ido ido-grid-mode ido-ubiquitous)
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands))
  :config
  (setq smex-save-file (h/ed "state/smex-items")
        smex-flex-matching nil)

  (defun h/advise-smex-bindings ()
    (define-key ido-completion-map (kbd "<tab>") 'ido-complete))

  (advice-add 'smex-prepare-ido-bindings :after #'h/advise-smex-bindings))

;(req-package ido-cycle-matching)
