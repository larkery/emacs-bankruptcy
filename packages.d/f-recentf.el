(req-package recentf
  :demand t
  :require ivy
  :bind ("C-x C-r" . cr-recentf)
  :config
  (setq recentf-save-file (concat (my-state-dir "") "/recentf")
        recentf-exclude '(".ido.last" "org-clock-save.el" "\\`/net/")
        recentf-max-menu-items 50
        recentf-max-saved-items 50)

  (defun cr-recentf ()
    (interactive)
    (find-file (completing-read "recent: " recentf-list)))

  (recentf-mode 1))
