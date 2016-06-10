(req-package ivy
  :diminish (ivy-mode "")
  :config
  (setq ivy-format-function 'ivy-format-function-line
        ivy-use-virtual-buffers t)
  (ivy-mode))

(req-package counsel
  :diminish (counsel-mode "")
  :config
  (setq counsel-find-file-ignore-regexp "\\`\\.")
  (counsel-mode)
  (defadvice counsel-yank-pop (around sometimes-yank-pop (arg))
    (interactive "p")
    (if (not (memq last-command '(yank)))
        ad-do-it
      (call-interactively 'yank-pop)))
  (ad-activate 'counsel-yank-pop))
