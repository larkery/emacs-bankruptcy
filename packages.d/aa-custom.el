(unless (package-installed-p 'initsplit)
  (package-refresh-contents)
  (package-install 'initsplit))
(require 'initsplit)

(defmacro initsplit-this-file (&rest regx)
  `(push (list (rx ,@regx) ,load-file-name nil t)
         initsplit-customizations-alist))

(setq custom-file load-file-name)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   ["#3f3f3f" "#ea3838" "#7fb07f" "#fe8b04" "#62b6ea" "#e353b9" "#1fb3b3" "#d5d2be"])
 '(appt-display-mode-line nil)
 '(back-button-mode t)
 '(beacon-color "#ec4780")
 '(blink-cursor-mode t)
 '(browse-url-browser-function (quote browse-url-generic))
 '(browse-url-chromium-arguments (quote ("--new-window")))
 '(browse-url-generic-program "xdg-open")
 '(comint-prompt-read-only t)
 '(custom-safe-themes
   (quote
    ("394208a5f86997a33bfe961fada26dff418f246b2756f406bbebdea14247d65f" "5cd0afd0ca01648e1fff95a7a7f8abec925bd654915153fb39ee8e72a8b56a1f" "51897d0e185a9d350a124afac8d5e95cda53e737f3b33befc44ab02f2b03dab1" "3b333a6780005b5dbfd1b15525118fe37791387b994008c977c786cd9b464977" "15348febfa2266c4def59a08ef2846f6032c0797f001d7b9148f30ace0d08bcf" "d320493111089afba1563bc3962d8ea1117dd2b3abb189aeebdc8c51b5517ddb" "cdd26fa6a8c6706c9009db659d2dffd7f4b0350f9cc94e5df657fa295fffec71" "cc0dbb53a10215b696d391a90de635ba1699072745bf653b53774706999208e3" "0eea76fe89061a7f6da195f4a976c0b91150de987b942fac2dd10992aea33833" "d8f76414f8f2dcb045a37eb155bfaa2e1d17b6573ed43fb1d18b936febc7bbc2" "4f2ede02b3324c2f788f4e0bad77f7ebc1874eff7971d2a2c9b9724a50fb3f65" "1e67765ecb4e53df20a96fb708a8601f6d7c8f02edb09d16c838e465ebe7f51b" default)))
 '(debug-on-quit nil)
 '(delete-selection-mode t)
 '(directory-free-space-program nil)
 '(evil-emacs-state-cursor (quote ("#E57373" hbar)))
 '(evil-insert-state-cursor (quote ("#E57373" bar)))
 '(evil-normal-state-cursor (quote ("#FFEE58" box)))
 '(evil-visual-state-cursor (quote ("#C5E1A5" box)))
 '(fci-rule-color "#222222")
 '(frames-only-mode nil)
 '(fringe-mode (quote (0)) nil (fringe))
 '(garbage-collection-messages nil)
 '(gc-cons-percentage 0.5)
 '(gc-cons-threshold 535822336)
 '(highlight-indent-guides-auto-enabled nil)
 '(highlight-symbol-colors
   (quote
    ("#FFEE58" "#C5E1A5" "#80DEEA" "#64B5F6" "#E1BEE7" "#FFCC80")))
 '(highlight-symbol-foreground-color "#E0E0E0")
 '(highlight-tail-colors (quote (("#ec4780" . 0) ("#424242" . 100))))
 '(hippie-expand-try-functions-list
   (quote
    (try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-file-name try-expand-line)))
 '(hl-sexp-background-color "#060404")
 '(ibuffer-display-summary nil)
 '(ibuffer-formats
   (quote
    ((mark modified read-only " "
           (name 25 25 :left :elide)
           " "
           (size 9 -1 :right)
           " "
           (mode 16 16 :left :elide)
           " " filename-and-process)
     (mark " "
           (name 16 -1)
           " " filename))))
 '(ibuffer-saved-filter-groups
   (quote
    (("default"
      ("notmuch"
       (or
        (used-mode . notmuch-tree-mode)
        (used-mode . notmuch-search-mode)
        (used-mode . notmuch-show-mode)))
      ("*Internal*"
       (name . "\\`\\*"))))))
 '(ibuffer-saved-filters
   (quote
    (("terms"
      ((used-mode . term-mode)))
     ("gnus"
      ((or
        (mode . message-mode)
        (mode . mail-mode)
        (mode . gnus-group-mode)
        (mode . gnus-summary-mode)
        (mode . gnus-article-mode))))
     ("programming"
      ((or
        (mode . emacs-lisp-mode)
        (mode . cperl-mode)
        (mode . c-mode)
        (mode . java-mode)
        (mode . idl-mode)
        (mode . lisp-mode)))))))
 '(ibuffer-show-empty-filter-groups nil)
 '(ibuffer-use-other-window t)
 '(linum-format " %6d ")
 '(main-line-color1 "#222232")
 '(main-line-color2 "#333343")
 '(midnight-mode t)
 '(mml-secure-openpgp-encrypt-to-self t)
 '(multi-term-scroll-show-maximum-output t)
 '(multi-term-scroll-to-bottom-on-output t)
 '(multi-term-switch-after-close nil)
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(package-selected-packages
   (quote
    (org-agenda-property company solarized-theme metalheart-theme forest-blue-theme direnv zop-to-char back-button ibuffer-tramp elisp-slime-nav org-capture-pop-frame ace-mc tup-mode clues-theme alect-themes afternoon-theme pcmpl-args bash-completion multishell seoul256-theme hc-zenburn-theme zenburn-theme greymatters-theme anti-zenburn-theme tangotango-theme apropospriate-theme leuven-theme paradox yasnippet projectile org bbdb bind-key jdee spu xpm ido-exit-target notmuch flatui-theme gruvbox-theme farmhouse-theme minimal-theme spacegray-theme darktooth-theme ggtags gradle-mode pdf-tools orgit thingatpt+ exwm multi-term "initsplit" initsplit ess python heroku-theme paganini-theme dired-atool dired-ranger dired-filetype-face ws-butler wgrep weechat w3m sr-speedbar smex smartrep smartparens req-package rainbow-mode project-explorer pcre2el pass paren-face org-caldav org-bullets nix-mode multiple-cursors magit java-snippets ivy ido-ubiquitous ido-at-point ibuffer-projectile highlight-symbol haskell-mode git-timemachine flimenu expand-region eno elfeed el-get dired-subtree dired-narrow csv-mode comment-dwim-2 clojure-snippets cider browse-kill-ring+ bbdb-vcard bbdb-handy bbdb-ext avy auth-password-store anzu anaconda-mode ag adaptive-wrap)))
 '(paradox-github-token t)
 '(pos-tip-background-color "#36473A")
 '(pos-tip-foreground-color "#FFFFC8")
 '(powerline-color1 "#222232")
 '(powerline-color2 "#333343")
 '(safe-local-variable-values (quote ((eval org-insert-datetree-entry))))
 '(sentence-end-double-space nil)
 '(shr-color-visible-distance-min 8)
 '(shr-color-visible-luminance-min 60)
 '(tabbar-background-color "#353535")
 '(term-scroll-show-maximum-output t)
 '(term-unbind-key-list (quote ("C-x" "C-c" "C-h" "C-y" "<ESC>")))
 '(vc-annotate-background "#222222")
 '(vc-annotate-color-map
   (quote
    ((20 . "#fa5151")
     (40 . "#ea3838")
     (60 . "#f8ffa0")
     (80 . "#e8e815")
     (100 . "#fe8b04")
     (120 . "#e5c900")
     (140 . "#32cd32")
     (160 . "#8ce096")
     (180 . "#7fb07f")
     (200 . "#3cb370")
     (220 . "#099709")
     (240 . "#2fdbde")
     (260 . "#1fb3b3")
     (280 . "#8cf1f1")
     (300 . "#94bff3")
     (320 . "#62b6ea")
     (340 . "#30a5f5")
     (360 . "#e353b9"))))
 '(vc-annotate-very-old-color "#e353b9")
 '(when
      (or
       (not
        (boundp
         (quote ansi-term-color-vector)))
       (not
        (facep
         (aref ansi-term-color-vector 0)))))
 '(yas-global-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(term-color-blue ((t (:background "steel blue" :foreground "steel blue"))))
 '(term-color-red ((t (:background "red2" :foreground "red2")))))
