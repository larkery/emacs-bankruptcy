(req-package recentf
  :demand t
  :require ivy
  :bind ("C-x C-r" . ivy-recentf)
  :config
  (setq recentf-save-file (concat (my-state-dir "") "/recentf")
        recentf-exclude '(".ido.last" "org-clock-save.el" "\\`/net/")
        recentf-max-menu-items 50
        recentf-max-saved-items 50)

  (recentf-mode 1))
