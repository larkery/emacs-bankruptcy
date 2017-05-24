(req-package project-explorer
  :bind ("<f5>" . project-explorer-toggle)
  :config
  (bind-keys
   :map project-explorer-mode-map
   ("o" . pe/find-file))

  (add-hook 'project-explorer-mode-hook
            'hl-line-mode)

  (defun my-project-explorer-hl-advice (o &rest args)
    (lexical-let ((buf (current-buffer)))
      (run-with-timer 0 nil (lambda ()
                              (with-current-buffer buf
                                (hl-line-highlight)))))
    (apply o args))

  (advice-add 'pe/goto-file :around 'my-project-explorer-hl-advice)
  (setq pe/cache-directory (my-state-dir "project-explorer-cache"))
  )
