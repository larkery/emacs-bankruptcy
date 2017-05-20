;; (req-package zenburn-theme)
(defun face-rgb-color (face attr)
  (let* ((colr (face-attribute face attr)))
    (unless (eq colr 'unspecified)
      (let* ((rgb (color-name-to-rgb colr))
             (hsl (apply 'color-rgb-to-hsl rgb))
             (hsl2 (list (nth 0 hsl) (min 1.0 (+ 0.3 (nth 1 hsl))) (min 1.0 (+ 0.1 (nth 2 hsl)))))
             (rgb2 (apply 'color-hsl-to-rgb hsl2))
             (result (apply 'color-rgb-to-hex rgb2)))
        ;; (message "%s %s %s : %s -> %s" colr face attr rgb result)

        result
        ))))

(defvar after-load-theme-hook nil
  "Hook run after a color theme is loaded using `load-theme'.")

(defadvice load-theme (after run-after-load-theme-hook activate)
  "Run `after-load-theme-hook'."
  (run-hooks 'after-load-theme-hook))

(defun theme->xresources (&rest _blah)
  "Generate and update xresources from current theme"
  (interactive)

  (when (display-graphic-p)
    (require 'term)
    (with-current-buffer (get-buffer-create "*gen-resources*")
      (erase-buffer)
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
                (let ((att (face-attribute face attr)))
                  (unless (eq att 'unspecified)
                    (insert (format "%s*%s: %s\n" term resource att))))))

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
                  (when nam
                    (insert (format "%s*%s: %s\n" term resource nam)))))))

      ;; (insert (format "*Foreground: %s\n*Background: %s\n"
      ;;                 (face-attribute 'default :foreground)
      ;;                 (face-attribute 'default :background)))

      (goto-char (point-min))
      (unless (search-forward "unspecified" nil t)
        (call-process-region
         (point-min)
         (point-max)
         "xrdb"
         nil nil nil
         "-merge")
        (write-region (point-min) (point-max) "~/.Xresources_emacs")
        (message "updated xresources for theme")
        (remove-hook 'window-configuration-change-hook 'theme->xresources))
      (kill-buffer)))
  t)

(req-package hc-zenburn-theme
  :config
  (add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes"))
  (load-theme 'hc-zenburn t)
  (load-theme 'tweaks t)
  (add-hook 'window-configuration-change-hook 'theme->xresources)
  (add-hook 'after-load-theme-hook 'theme->xresources))
