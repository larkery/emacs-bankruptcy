(defvar dark-theme 'punpun-dark)
(defvar light-theme 'punpun-light)
(defvar dark-mode nil)

;(req-package punpun-theme
;  :config
  (add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes"))
  (defun toggle-dark-mode ()
    (interactive)
    (dolist (theme custom-enabled-themes) (disable-theme theme))
    (setq dark-mode (not dark-mode))
    (load-theme (if dark-mode dark-theme light-theme) t)
    (load-theme 'tweaks t)

    (shell-command (if dark-mode "xrdb ~/.Xresources -DDARK" "xrdb ~/.Xresources -UDARK"))
    (shell-command (if dark-mode "xsetroot -solid black" "xsetroot -solid gray50"))
    ;; (when dark-mode
    ;;   (setq punpun-colors
    ;;         '((base0  ("#eeeeee" "#2e3436") ("color-255" "color-232"))
    ;;           (base1  ("#d0d0d0" "#5a5a5a") ("color-252" "color-234"))
    ;;           (base2  ("#b2b2b2" "#686868") ("color-249" "color-237"))
    ;;           (base3  ("#949494" "#868686") ("color-246" "color-240"))
    ;;           (base4  ("#767676" "#7bbbbb") ("color-243" "color-243"))
    ;;           (base5  ("#585858" "#eeeeee") ("color-240" "color-246"))
    ;;           (base6  ("#3a3a3a" "#d6d6d6") ("color-237" "color-249"))
    ;;           (base7  ("#1c1c1c" "#eeeeee") ("color-234" "color-252"))
    ;;           (yellow ("#ffaf00" "#ffd700") ("color-214" "color-220"))
    ;;           (orange ("#d75f00" "#ff5f00") ("color-166" "color-202"))
    ;;           (red    ("#d70000" "#ff0000") ("color-160" "color-196"))
    ;;           (green  ("#00af00" "#00d700") ("color-34"  "color-40" ))
    ;;           (blue   ("#5f00ff" "#005fff") ("color-57"  "color-27" ))
    ;;           (cyan   ("#0087ff" "#00d7ff") ("color-33"  "color-45" ))
    ;;           (pink   ("#ff005f" "#ff0087") ("color-197" "color-198"))
    ;;           (violet ("#8700d7" "#af00d7") ("color-92"  "color-128"))))
    ;;   (punpun-set-faces 'punpun-dark t))

    )
  (bind-key "<f11>" 'toggle-dark-mode)
  (toggle-dark-mode)
