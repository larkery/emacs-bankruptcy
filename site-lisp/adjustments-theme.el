
(deftheme adjustments "my theme adjustments")

(custom-theme-set-faces
 'adjustments
 '(default ((t :height 105)))
 '(ido-first-match ((t (:inverse-video t))))
 '(ido-only-match ((t (:inverse-video t))))
 '(ido-virtual ((t (:slant italic))))
 '(cursor ((t (:background "#ffffff"))))
 '(message-cited-text ((t (:inherit shadow :slant italic))))
 '(show-paren-match ((t (:underline t))))
 '(diff-hl-change ((t (:background "dim gray" :foreground "dark gray"))))
 '(highlight-symbol-face ((t (:underline t))))
 '(font-lock-function-name-face ((t (:foreground "#4493a1"))))
 '(outline-1 ((t (:height 1.2 :inherit font-lock-function-name-face))))
 '(org-todo ((t :background "darkred" :box "dimgray" :height 0.9)))
 '(org-done ((t :background "darkgreen" :box "dimgray" :height 0.9)))
 '(shadow ((t (:foreground "#929292"))))
 '(outline-2 ((t (:height 1.2 :inherit font-lock-type-face))))
 '(org-date ((t (:inherit link))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "#84ac8f"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "#78a485"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "#6c9c7b"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "#619072"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "#598468"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "#55a9b7"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "#4aa0af"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "#3d8592"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "#367783"))))

 ;; '(button ((t
 ;;            (:underline nil :box
 ;;                        (:line-width 2 :color "grey75" :style released-button)
 ;;                        :foreground "#FFFFFF" :background "#444444" :inherit
 ;;                        (link)))))
 )

(provide-theme 'adjustments)
