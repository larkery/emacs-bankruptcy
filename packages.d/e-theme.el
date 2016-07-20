(req-package tangotango-theme
  :config
  (defvar dark-theme 'tangotango)
  (defvar light-theme 'tango)
  (defvar dark-mode nil)

  (add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes"))

  (defun toggle-dark-mode ()
    (interactive)
    (dolist (theme custom-enabled-themes) (disable-theme theme))

    (setq dark-mode (not dark-mode))

    (load-theme (if dark-mode dark-theme light-theme) t)
    (load-theme 'tweaks t)
    (shell-command (if dark-mode "xrdb ~/.Xresources -DDARK" "xrdb ~/.Xresources -UDARK")) )

  (bind-key "<f11>" 'toggle-dark-mode)
  (toggle-dark-mode))
