(defvar dark-theme 'punpun-dark)
(defvar light-theme 'punpun-light)
(defvar dark-mode nil)

;(req-package punpun-theme
                                        ;  :config
  (add-to-list 'load-path  (concat user-emacs-directory "themes"))
  (add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes"))
  (defun toggle-dark-mode ()
    (interactive)
    (dolist (theme custom-enabled-themes) (disable-theme theme))
    (setq dark-mode (not dark-mode))
    (load-theme (if dark-mode dark-theme light-theme) t)
    (load-theme 'tweaks t)

    (shell-command (if dark-mode "xrdb ~/.Xresources -ULIGHT" "xrdb ~/.Xresources -DLIGHT"))
    )
  (bind-key "<f11>" 'toggle-dark-mode)
  (toggle-dark-mode)
