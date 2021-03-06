;; -*- lexical-binding: t -*-
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
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#657b83"])
 '(appt-display-mode-line nil)
 '(auto-revert-remote-files t)
 '(auto-revert-use-notify t)
 '(auto-revert-verbose nil)
 '(back-button-mode t)
 '(beacon-color "#ec4780")
 '(blink-cursor-mode t)
 '(bm-highlight-style (quote bm-highlight-only-fringe))
 '(browse-url-browser-function (quote browse-url-generic))
 '(browse-url-chromium-arguments (quote ("--new-window")))
 '(browse-url-generic-program "xdg-open")
 '(cfw:read-date-command (quote cfw:org-read-date-command))
 '(comint-prompt-read-only t)
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-safe-themes
   (quote
    ("394208a5f86997a33bfe961fada26dff418f246b2756f406bbebdea14247d65f" "5cd0afd0ca01648e1fff95a7a7f8abec925bd654915153fb39ee8e72a8b56a1f" "51897d0e185a9d350a124afac8d5e95cda53e737f3b33befc44ab02f2b03dab1" "3b333a6780005b5dbfd1b15525118fe37791387b994008c977c786cd9b464977" "15348febfa2266c4def59a08ef2846f6032c0797f001d7b9148f30ace0d08bcf" "d320493111089afba1563bc3962d8ea1117dd2b3abb189aeebdc8c51b5517ddb" "cdd26fa6a8c6706c9009db659d2dffd7f4b0350f9cc94e5df657fa295fffec71" "cc0dbb53a10215b696d391a90de635ba1699072745bf653b53774706999208e3" "0eea76fe89061a7f6da195f4a976c0b91150de987b942fac2dd10992aea33833" "d8f76414f8f2dcb045a37eb155bfaa2e1d17b6573ed43fb1d18b936febc7bbc2" "4f2ede02b3324c2f788f4e0bad77f7ebc1874eff7971d2a2c9b9724a50fb3f65" "1e67765ecb4e53df20a96fb708a8601f6d7c8f02edb09d16c838e465ebe7f51b" default)))
 '(debug-on-quit nil)
 '(delete-selection-mode t)
 '(directory-free-space-program nil)
 '(display-battery-mode nil)
 '(display-time-mail-file (quote none))
 '(editorconfig-exclude-regexps (quote ("\\`\\(?:ftp\\|https?\\|rsync\\|sftp\\|/net\\):")))
 '(enable-recursive-minibuffers t)
 '(eshell-prompt-function (quote my-eshell-prompt-function))
 '(evil-emacs-state-cursor (quote ("#E57373" hbar)) t)
 '(evil-insert-state-cursor (quote ("#E57373" bar)) t)
 '(evil-normal-state-cursor (quote ("#FFEE58" box)) t)
 '(evil-visual-state-cursor (quote ("#C5E1A5" box)) t)
 '(fci-rule-color "#5E5E5E" t)
 '(frames-only-mode nil)
 '(fringe-mode (quote (0)) nil (fringe))
 '(git-commit-finish-query-functions nil)
 '(git-commit-summary-max-length 200)
 '(global-auto-revert-mode t)
 '(global-mark-ring-max 500)
 '(grep-command "grep -nHE")
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-indent-guides-auto-enabled nil)
 '(highlight-tail-colors (quote (("#ec4780" . 0) ("#424242" . 100))))
 '(hippie-expand-try-functions-list
   (quote
    (try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-file-name try-expand-line)))
 '(hl-bg-colors
   (quote
    ("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00")))
 '(hl-fg-colors
   (quote
    ("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36")))
 '(hl-paren-attributes (quote ((:weight bold) (:weight bold) (:weight bold))))
 '(hl-paren-colors (quote ("cyan4" "orange3" "green3")))
 '(hl-sexp-background-color "#060404")
 '(ibuffer-display-summary nil)
 '(ibuffer-formats
   (quote
    ((mark modified read-only " "
           (name 40 40 :left :elide)
           " "
           (size 9 -1 :right)
           " "
           (display-time 8 8 :left :elide)
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
 '(kill-ring-max 600)
 '(linum-format " %6d ")
 '(main-line-color1 "#222232")
 '(main-line-color2 "#333343")
 '(mark-ring-max 500)
 '(midnight-mode t)
 '(minibuffer-depth-indicate-mode t)
 '(mml-secure-openpgp-encrypt-to-self t)
 '(nrepl-message-colors
   (quote
    ("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4")))
 '(package-selected-packages (quote (dumb-jump load-dir req-package initsplit el-get)))
 '(pos-tip-background-color "#36473A")
 '(pos-tip-foreground-color "#FFFFC8")
 '(powerline-color1 "#222232")
 '(powerline-color2 "#333343")
 '(rcirc-default-nick "TomHinton")
 '(recenter-positions (quote (middle top bottom)))
 '(rmh-elfeed-org-files (quote ("~/notes/home/feeds.org")))
 '(safe-local-variable-values
   (quote
    ((eval add-hook
           (quote after-save-hook)
           (lambda nil
             (shell-command "xrdb ~/.Xresources")))
     (eval add-hook
           (quote after-save-hook)
           (lambda
             (& rest)
             (shell-command "xrdb ~/.Xresources")))
     (eval org-insert-datetree-entry))))
 '(savehist-additional-variables
   (quote
    (dired-remembered-state kill-ring org-timesheets-history)))
 '(savehist-mode t)
 '(sentence-end-double-space nil)
 '(shr-color-visible-distance-min 8)
 '(shr-color-visible-luminance-min 60)
 '(tab-always-indent (quote complete))
 '(tab-width 4)
 '(tabbar-background-color "#353535")
 '(tramp-remote-path
   (quote
    ("/run/current-system/sw/bin" tramp-default-remote-path "/bin" "/usr/bin" "/sbin" "/usr/sbin" "/usr/local/bin" "/usr/local/sbin" "/local/bin" "/local/freeware/bin" "/local/gnu/bin" "/usr/freeware/bin" "/usr/pkg/bin" "/usr/contrib/bin" "/opt/bin" "/opt/sbin" "/opt/local/bin" "~/.nix-profile/bin")))
 '(vc-annotate-background "#202020")
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#C99090")
     (40 . "#D9A0A0")
     (60 . "#ECBC9C")
     (80 . "#DDCC9C")
     (100 . "#EDDCAC")
     (120 . "#FDECBC")
     (140 . "#6C8C6C")
     (160 . "#8CAC8C")
     (180 . "#9CBF9C")
     (200 . "#ACD2AC")
     (220 . "#BCE5BC")
     (240 . "#CCF8CC")
     (260 . "#A0EDF0")
     (280 . "#79ADB0")
     (300 . "#89C5C8")
     (320 . "#99DDE0")
     (340 . "#9CC7FB")
     (360 . "#E090C7"))))
 '(vc-annotate-very-old-color "#E090C7")
 '(visual-line-fringe-indicators (quote (nil right-curly-arrow)))
 '(weechat-color-list
   (quote
    (unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83")))
 '(when
      (or
       (not
        (boundp
         (quote ansi-term-color-vector)))
       (not
        (facep
         (aref ansi-term-color-vector 0)))))
 '(xterm-color-names
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"])
 '(xterm-color-names-bright
   ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1" "#fdf6e3"])
 '(yas-global-mode t))
