(initsplit-this-file bos "recentf-")

(req-package recentf
  :demand t
  :require ivy
  :bind ("C-x C-r" . cr-recentf)
  :config

  (defun cr-recentf ()
    (interactive)
    (find-file (completing-read "recent: " recentf-list)))

  (recentf-mode 1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(recentf-exclude
   (quote
    (".ido.last" "org-clock-save.el" "\\`/net/" ".emacs.d/elpa" ".git")))
 '(recentf-max-menu-items 50)
 '(recentf-max-saved-items 500)
 '(recentf-save-file (concat (my-state-dir "") "/recentf")))
