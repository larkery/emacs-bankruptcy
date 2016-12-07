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
 '(blink-cursor-mode t)
 '(browse-url-browser-function (quote browse-url-generic))
 '(browse-url-chromium-arguments (quote ("--new-window")))
 '(browse-url-generic-program "xdg-open")
 '(custom-safe-themes
   (quote
    ("5cd0afd0ca01648e1fff95a7a7f8abec925bd654915153fb39ee8e72a8b56a1f" "51897d0e185a9d350a124afac8d5e95cda53e737f3b33befc44ab02f2b03dab1" "3b333a6780005b5dbfd1b15525118fe37791387b994008c977c786cd9b464977" "15348febfa2266c4def59a08ef2846f6032c0797f001d7b9148f30ace0d08bcf" "d320493111089afba1563bc3962d8ea1117dd2b3abb189aeebdc8c51b5517ddb" "cdd26fa6a8c6706c9009db659d2dffd7f4b0350f9cc94e5df657fa295fffec71" "cc0dbb53a10215b696d391a90de635ba1699072745bf653b53774706999208e3" "0eea76fe89061a7f6da195f4a976c0b91150de987b942fac2dd10992aea33833" "d8f76414f8f2dcb045a37eb155bfaa2e1d17b6573ed43fb1d18b936febc7bbc2" "4f2ede02b3324c2f788f4e0bad77f7ebc1874eff7971d2a2c9b9724a50fb3f65" "1e67765ecb4e53df20a96fb708a8601f6d7c8f02edb09d16c838e465ebe7f51b" default)))
 '(delete-selection-mode t)
 '(gc-cons-percentage 0.2)
 '(gc-cons-threshold 1600000)
 '(hippie-expand-try-functions-list
   (quote
    (try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-file-name try-expand-line)))
 '(hl-sexp-background-color "#060404")
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
 '(ibuffer-saved-filter-groups nil)
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
 '(mml-secure-openpgp-encrypt-to-self t)
 '(package-selected-packages
   (quote
    (hc-zenburn-theme zenburn-theme greymatters-theme anti-zenburn-theme tangotango-theme apropospriate-theme leuven-theme paradox yasnippet projectile org bbdb bind-key jdee spu xpm ido-exit-target notmuch flatui-theme gruvbox-theme farmhouse-theme minimal-theme spacegray-theme darktooth-theme ggtags gradle-mode pdf-tools orgit thingatpt+ exwm multi-term "initsplit" initsplit ess python heroku-theme paganini-theme dired-atool dired-ranger dired-filetype-face ws-butler wgrep weechat w3m sr-speedbar smex smartrep smartparens req-package rainbow-mode project-explorer pcre2el pass paren-face org-caldav org-bullets nix-mode multiple-cursors magit java-snippets ivy ido-ubiquitous ido-at-point ibuffer-projectile highlight-symbol haskell-mode git-timemachine flimenu expand-region eno elfeed el-get dired-subtree dired-narrow csv-mode comment-dwim-2 clojure-snippets cider browse-kill-ring+ bbdb-vcard bbdb-handy bbdb-ext avy auth-password-store anzu anaconda-mode ag adaptive-wrap)))
 '(paradox-github-token t)
 '(pos-tip-background-color "#36473A")
 '(pos-tip-foreground-color "#FFFFC8")
 '(safe-local-variable-values (quote ((eval org-insert-datetree-entry))))
 '(sentence-end-double-space nil)
 '(when
      (or
       (not
        (boundp
         (quote ansi-term-color-vector)))
       (not
        (facep
         (aref ansi-term-color-vector 0))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ido-first-match ((t (:inverse-video t :weight bold))))
 '(ido-grid-match-1 ((t (:inherit match :slant italic))))
 '(ido-grid-match-2 ((t (:inherit ido-grid-match-1))))
 '(ido-grid-match-3 ((t (:inherit ido-grid-match-1))))
 '(ido-only-match ((t (:inherit ido-first-match)))))
