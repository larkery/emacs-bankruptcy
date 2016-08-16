;; (req-package ivy
;;   :diminish (ivy-mode "")
;;   :config
;;   (setq ivy-format-function 'ivy-format-function-line
;;         ivy-use-virtual-buffers t)
;;   (ivy-mode)
;;   (require 'ivy-buffer-extend))


;; (req-package counsel
;;   :demand
;;   :bind (("<menu>" . counsel-imenu))
;;   :diminish (counsel-mode "")
;;   :config
;;   (setq counsel-find-file-ignore-regexp "\\`\\.")
;;   (counsel-mode)
;;   (defadvice counsel-yank-pop (around sometimes-yank-pop (arg))
;;     (interactive "p")
;;     (if (not (memq last-command '(yank)))
;;         ad-do-it
;;       (call-interactively 'yank-pop)))
;;   (ad-activate 'counsel-yank-pop))

(el-get-bundle larkery/ido-match-modes.el)
(el-get-bundle larkery/ido-describe-prefix-bindings.el)
(el-get-bundle larkery/ido-grid.el)

(req-package ido
  :config
  (setq
   ido-auto-merge-delay-time 0.7
   ido-cr+-max-items 50000
   ido-create-new-buffer (quote always)
   ido-default-buffer-method (quote selected-window)
   ido-default-file-method (quote selected-window)
   ido-ignore-buffers (quote ("\\` " "*Help*" "*magit-process"))
   ido-ignore-files
     (quote
      ("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./" "\\`\\./" "^\\.[^\\.]+"))
     ido-max-work-directory-list 100
     ido-separator nil
     ido-show-dot-for-dired t
     ido-use-virtual-buffers (quote auto)
     ido-work-directory-list-ignore-regexps (quote ("^/net/"))
     )
  (ido-mode))


(req-package ido-match-modes :require ido
  :config
  (setq ido-match-modes-list (quote (words substring regex))))

(req-package ido-grid
  :require ido-match-modes
  :config
  (setq ido-grid-indent 0)
  (ido-grid-enable)
  (ido-match-modes-enable))
(req-package ido-ubiquitous
  :config
  (ido-ubiquitous-mode)
  (ido-everywhere 1))
(req-package ido-at-point
  :config
  (ido-at-point-mode 1))
(req-package ido-describe-prefix-bindings
  :demand
  :bind ("M-X" . ido-describe-mode-bindings)
  :config
  (ido-describe-prefix-bindings-mode 1))
(req-package smex
  :commands smex
  :require (ido ido-ubiquitous)
  :bind (("M-x" . smex))
  :config
  (setq smex-save-file (concat (my-state-dir "/") "smex")
        smex-flex-matching nil)

  (defun h/advise-smex-bindings ()
    (define-key ido-completion-map (kbd "<tab>") 'ido-complete))

  (advice-add 'smex-prepare-ido-bindings :after #'h/advise-smex-bindings))
