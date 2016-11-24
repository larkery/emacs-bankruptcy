(deftheme tweaks "small adjustments to theme")
(require 'highlight-symbol)
(custom-theme-set-faces
 'tweaks

 '(notmuch-message-summary-face ((t (:inherit (font-lock-builtin-face mode-line-inactive)))))

 '(ivy-remote ((t (:inherit error))))

 '(show-paren-match ((t (:background nil :foreground nil :weight bold
;;                                     :box (:line-width -1)

                                     :underline t
                                     ))))
 '(show-paren-mismatch ((t (:background "black" :foreground "red" :weight bold))))

 '(org-todo ((t (:foreground "white" :background "red3" :weight bold))))
 '(org-done ((t (:foreground "white" :background "green3" :weight bold))))

 '(ido-grid-match-1 ((t (:inherit match))))
 `(ido-grid-match-2 ((t (:foreground ,(nth 1 highlight-symbol-colors)))))
 `(ido-grid-match-3 ((t (:foreground ,(nth 2 highlight-symbol-colors)))))

 '(dired-subtree-depth-1-face ((t ())))
 '(dired-subtree-depth-5-face ((t ())))
 '(dired-subtree-depth-3-face ((t ())))
 '(dired-subtree-depth-2-face ((t ())))
 '(dired-subtree-depth-4-face ((t ())))
 '(dired-subtree-depth-6-face ((t ())))
 '(dired-symlink ((t (:underline t :foreground nil))))
 '(dired-directory ((t (:weight bold))))

 '(w3m-lnum ((t (:background "#F0F0F0" :foreground "dark orange"))))
 '(w3m-anchor ((t (:inherit link))))

 '(outline-1 ((t (:height 1.3 :family "Sans" :weight bold))))
 '(outline-2 ((t (:height 1.2 :family "Sans" :weight bold))))
 '(outline-3 ((t (:height 1.1 :family "Sans" :weight bold))))
 '(outline-4 ((t (:height 1.1 :family "Sans" :weight bold))))
 '(outline-5 ((t (:height 1.1 :family "Sans" :weight bold))))
 '(outline-6 ((t (:height 1.1 :family "Sans" :weight bold))))
 '(outline-7 ((t (:height 1.1 :family "Sans" :weight bold))))
 '(outline-8 ((t (:height 1.1 :family "Sans" :weight bold))))
 '(outline-9 ((t (:height 1.1 :family "Sans" :weight bold))))

 '(org-level-1 ((t (:height 1.4 :family "Sans" :weight bold))))
 '(org-level-2 ((t (:height 1.3 :family "Sans" :weight bold))))
 '(org-level-3 ((t (:height 1.2 :family "Sans" :weight bold))))
 '(org-level-4 ((t (:height 1.1 :family "Sans" :weight bold))))
 '(org-level-5 ((t (:height 1.1 :family "Sans" :weight bold))))
 '(org-level-6 ((t (:height 1.1 :family "Sans" :weight bold))))
 '(org-level-7 ((t (:height 1.1 :family "Sans" :weight bold))))
 '(org-level-8 ((t (:height 1.1 :family "Sans" :weight bold))))
 '(org-level-9 ((t (:height 1.1 :family "Sans" :weight bold))))

 '(message-cited-text ((t (:weight bold))))

 '(ido-first-match ((t (:inverse-video t))))
 '(ido-only-match ((t (:inherit ido-first-match))))
 '(ido-virtual ((t (:inherit nil :slant italic))))

 '(weechat-nick-self-face ((t (:inherit highlight))))
 )

(provide-theme 'tweaks)
