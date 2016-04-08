(deftheme adjustments "my theme adjustments")

;; theme only works properly in X, but there we go fails on server
;; start - presumably X resources not yet loaded.

(let* ((x-resource-class "XTerm")
       (x-resource-name "xterm")
       (xterm-font (x-get-resource "faceName" "faceName"))
       (xterm-foreground (x-get-resource "foreground" "foreground"))
       (xterm-background (x-get-resource "background" "background"))

       (parts (split-string xterm-font ":"))
       (font-name (car parts))
       (font-attributes (split-string (cadr parts) "="))
       (base-height (* 10 (string-to-number
                           (progn
                             (while (and font-attributes
                                         (not (string= (car font-attributes)
                                                       "size")))
                               (setq font-attributes (cdr font-attributes)))
                             (or (cadr font-attributes) "12"))))))
  (custom-theme-set-faces
   'adjustments
   `(default ((t :height ,base-height
                 :foreground ,xterm-foreground
                 :background ,xterm-background
                 :family ,font-name
                 )))
   '(ido-first-match ((t (:inverse-video t))))
   '(ido-only-match ((t (:inverse-video t))))
   '(ido-virtual ((t (:slant italic))))

   '(ido-grid-match-1 ((t (:background "#d0a195"))))
   '(ido-grid-match-2 ((t (:background "#94a7b6"))))
   '(ido-grid-match-3 ((t (:background "#d0bc95"))))

   '(cursor ((t (:background "black"))))
   '(message-cited-text ((t (:inherit shadow :slant italic))))

   '(show-paren-match ((t (:underline t))))
   '(highlight-symbol-face ((t (:background "#ddd"))))
   '(font-lock-comment-delimiter-face ((t (:foreground "steel blue"))))
   '(font-lock-comment-face ((t (:foreground "lightsteelblue4"))))

   '(notmuch-message-summary-face ((t (:inherit highlight))))

   '(mode-line-highlight ((t (:slant normal :foreground "firebrick"))))
   '(mode-line ((t (:overline "steel blue"))))
   '(org-mode-line-clock ((t ())))

   '(erc-timestamp-face ((t :inherit shadow)))

   '(eno-hint-face ((t (:inherit default :inverse-video t))))

   '(indent-guide-face ((t (:foreground "steel blue"))))
   '(dired-directory ((t (:foreground "steel blue"))))

   '(dired-subtree-depth-1-face ((t (:background "cornsilk2"))))
   '(dired-subtree-depth-2-face ((t (:background "cornsilk3"))))
   '(dired-subtree-depth-3-face ((t (:background "cornsilk4"))))
   '(dired-subtree-depth-4-face ((t (:background "cornsilk4"))))
   '(dired-subtree-depth-5-face ((t (:background "cornsilk4"))))

   '(org-agenda-date ((t (:inherit outline-2))))
   '(org-agenda-date-today ((t (:inherit outline-2 :foreground "firebrick"))))
   '(org-agenda-date-weekend ((t (:inherit outline-2 :slant italic))))

   `(outline-1 ((t (:height ,(+ base-height 10) :foreground "cadetblue4" :slant normal))))
   `(outline-2 ((t (:height ,(+ base-height 8) :foreground "cadetblue4" :slant normal))))
   `(outline-3 ((t (:height ,(+ base-height 6) :foreground "cadetblue4" :slant normal))))
   `(outline-4 ((t (:height ,(+ base-height 4) :foreground "cadetblue4" :slant normal))))
   `(outline-5 ((t (:height ,(+ base-height 2) :foreground "cadetblue4" :slant normal))))
   `(outline-6 ((t (:height ,(+ base-height 2) :foreground "cadetblue4" :slant normal))))
   `(outline-7 ((t (:height ,(+ base-height 2) :foreground "cadetblue4" :slant normal))))
   `(outline-8 ((t (:height ,(+ base-height 2) :foreground "cadetblue4" :slant normal))))
   `(outline-9 ((t (:height ,(+ base-height 2) :foreground "cadetblue4" :slant normal))))

   '(org-date ((t (:inherit link))))
   '(org-verbatim ((t :foreground "black")))
   '(fringe ((t (:foreground "black"))))

   '(rainbow-delimiters-depth-1-face ((t (:foreground "#8ca5b0"))))
   '(rainbow-delimiters-depth-3-face ((t (:foreground "#809ba8"))))
   '(rainbow-delimiters-depth-5-face ((t (:foreground "#7492a0"))))
   '(rainbow-delimiters-depth-7-face ((t (:foreground "#668497"))))
   '(rainbow-delimiters-depth-9-face ((t (:foreground "#5e7a8b"))))
   '(rainbow-delimiters-depth-2-face ((t (:foreground "#b9725e"))))
   '(rainbow-delimiters-depth-4-face ((t (:foreground "#b46751"))))
   '(rainbow-delimiters-depth-6-face ((t (:foreground "#9b543e"))))
   '(rainbow-delimiters-depth-8-face ((t (:foreground "#8d4b38"))))

   '(show-paren-mismatch ((t (:background "dark red" :foreground "white"))))
   '(rainbow-delimiters-unmatched-face ((t (:inherit show-paren-mismatch))))
   '(rainbow-delimiters-mismatched-face ((t (:inherit show-paren-mismatch))))
   ))

(provide-theme 'adjustments)
