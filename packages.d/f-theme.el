(req-package alect-themes
  :demand
  :bind ("C-c b" . toggle-theme)
  :config

  ;; (setq seoul256-background 236
  ;;       seoul256-alternate-background 253
  ;;       seoul256-override-colors-alist
  ;;       '((65 . "#999"))
  ;;       seoul256-colors-alist
  ;;       (append seoul256-override-colors-alist seoul256-default-colors-alist))

  (load-theme 'alect-dark t)
  (add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes"))
  (load-theme 'tweaks t)

  (defun toggle-theme ()
    (interactive)
    ;; (seoul256-switch-background)

    (theme->xresources))

  (defun face-rgb-color (face attr)
    (let* ((colr (face-attribute face attr))
           (rgb (color-name-to-rgb colr))
           (hsl (apply 'color-rgb-to-hsl rgb))
           (hsl2 (list (nth 0 hsl) (max 1.0 (- (nth 1 hsl) 0.1)) (min 1.0 (+ 0.1 (nth 2 hsl)))))
           (rgb2 (apply 'color-hsl-to-rgb hsl2)))
      (apply 'color-rgb-to-hex rgb2)))

  (defun theme->xresources ()
    "Generate and update xresources from current theme"
    (interactive)
    (require 'term)
    (with-temp-buffer
      (cl-loop
       for term in '("XTerm" "URxvt" "st")
       do (cl-loop
           for spec in '(("background" default :background)
                         ("foreground" default :foreground)
                         ("cursorColor" cursor :background)
                         ;; normal versions of colors
                         ("color0" term-color-black :background)
                         ("color1" term-color-red :background)
                         ("color2" term-color-green :background)
                         ("color3" term-color-yellow :background)
                         ("color4" term-color-blue :background)
                         ("color5" term-color-magenta :background)
                         ("color6" term-color-cyan :background)
                         ("color7" term-color-white :background))
           do (destructuring-bind
                  (resource face attr) spec
                (insert (format "%s*%s: %s\n" term resource
                                (face-attribute face attr)))))
       do (cl-loop
           for spec in '(("color8" term-color-black :background)
                         ("color9" term-color-red :background)
                         ("color10" term-color-green :background)
                         ("color11" term-color-yellow :background)
                         ("color12" term-color-blue :background)
                         ("color13" term-color-magenta :background)
                         ("color14" term-color-cyan :background)
                         ("color15" term-color-white :background))
           do (destructuring-bind
                  (resource face attr) spec
                (let ((nam (face-rgb-color face attr)))
                  (insert (format "%s*%s: %s\n" term resource nam))))))

      (insert (format "*Foreground: %s\n*Background: %s\n"
                      (face-attribute 'default :foreground)
                      (face-attribute 'default :background)))

      (call-process-region
       (point-min)
       (point-max)
       "xrdb"
       nil nil nil
       "-merge")
      (write-region (point-min) (point-max) "~/.emacs-xresources")
      (kill-buffer)))

  (theme->xresources)
  )
