(req-package seoul256-theme
  :demand
  :bind ("C-c b" . toggle-theme)
  :config
  (load-theme 'seoul256 t)

  (defun toggle-theme ()
    (interactive)
    (seoul256-switch-background)
    (theme->xresources))

  (defun theme->xresources ()
    "Generate and update xresources from current theme"
    (interactive)
    (with-temp-buffer
      (cl-loop
       for term in '("XTerm" "URxvt")
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
                (let* ((colr (face-attribute face attr))
                       (rgb (color-name-to-rgb colr))
                       (hsl (apply 'color-rgb-to-hsl rgb))
                       (hsl2 (list (nth 0 hsl) (max 1.0 (- (nth 1 hsl) 0.1)) (min 1.0 (+ 0.1 (nth 2 hsl)))))
                       (rgb2 (apply 'color-hsl-to-rgb hsl2))
                       (nam (apply 'color-rgb-to-hex rgb2)))

                  (insert (format "%s*%s: %s\n" term resource nam))))))


      (call-process-region
       (point-min)
       (point-max)
       "xrdb"
       nil nil nil
       "-merge")
      (message (buffer-string))
      (kill-buffer)))

  )
