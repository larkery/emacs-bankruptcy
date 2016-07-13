

(add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes"))
(load-theme 'tango t)
(load-theme 'tweaks t)

(defun my-unload-themes ()
  (interactive)
  (dolist (theme custom-enabled-themes)
    (disable-theme theme)))
