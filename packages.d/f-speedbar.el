;; (req-package sr-speedbar
;;   :require projectile-speedbar projectile
;;   :bind ("<f5>" . my-sr-speedbar-toggle)
;;   :config

;;   (defvar my-speedbar-last-buffer nil)
;;   (defvar my-speedbar-not-adjusting t)

;;   (defun my-sr-speedbar-window-hook ()
;;     (when (and nil
;;                my-speedbar-not-adjusting
;;                (sr-speedbar-exist-p))

;;       (let ((my-speedbar-not-adjusting nil)
;;             (last-selected-window (selected-window)))
;;          (sr-speedbar-select-window)

;;          (let ((shrink
;;                 (- (window-width) sr-speedbar-max-width)))
;;            (when (> shrink 0)
;;              (shrink-window-horizontally shrink)))
;;          (select-window last-selected-window))))

;;   (add-hook 'window-configuration-change-hook
;;             'my-sr-speedbar-window-hook)

;;   (defun my-sr-speedbar-toggle ()
;;     (interactive)
;;     (cond
;;      ((sr-speedbar-window-p) (sr-speedbar-close))
;;      ((sr-speedbar-exist-p) (sr-speedbar-select-window))
;;      (t (sr-speedbar-open))))

;;   (defun my-speedbar-timer-hook ()
;;     (condition-case x
;;         (when (and (not (eq my-speedbar-last-buffer (current-buffer)))
;;                    (sr-speedbar-exist-p)
;;                    (projectile-project-p))
;;           (setq my-speedbar-last-buffer (current-buffer))
;;           (save-window-excursion
;;             (projectile-speedbar-open-current-buffer-in-tree)))
;;       (error nil)))

;;   (add-hook 'speedbar-timer-hook 'my-speedbar-timer-hook))

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

(req-package sr-speedbar
  :bind ("<XF86Launch6>" . sr-speedbar-toggle)
  :config

  (defun my-advise-speedbar-open (x)
    (with-current-buffer sr-speedbar-buffer-name
      (setq window-size-fixed 'width))
    x)

  (advice-add 'sr-speedbar-open :filter-return 'my-advise-speedbar-open)
  )
