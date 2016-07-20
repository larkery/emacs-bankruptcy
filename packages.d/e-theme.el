(add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes"))
(load-theme 'tango t)
(load-theme 'tweaks t)

(defvar dark-mode t)

(defun toggle-dark-mode ()
  (interactive)
  (dolist (theme custom-enabled-themes) (disable-theme theme))

  (setq dark-mode (not dark-mode))

  (load-theme (if dark-mode 'tango-dark 'tango) t)
  (load-theme 'tweaks t)
  (shell-command (if dark-mode "xrdb ~/.Xresources -DDARK" "xrdb ~/.Xresources -UDARK")) )
