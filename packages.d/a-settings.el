;; load path
(add-to-list 'load-path (concat user-emacs-directory
                                "site-lisp/"))
;; basic chrome

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-startup-screen t)
(defalias 'yes-or-no-p 'y-or-n-p)

;; utf8

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; display settings
(run-with-idle-timer 5 t #'garbage-collect)

(setq load-prefer-newer         t

      history-length            1000
      history-delete-duplicates t

      echo-keystrokes           0.2

      scroll-conservatively     20

      set-mark-command-repeat-pop t
      
      frame-title-format
      '((:eval (concat
                (if (buffer-file-name)
                    (abbreviate-file-name (buffer-file-name))
                  "%b")
                (if (frame-parameter nil 'quick)
                    " Q" ""))))



      ;; /net is a bad place
      locate-dominating-stop-dir-regexp "\\`\\(/net/+[^/]+/+[^/]+\\)"
      vc-ignore-dir-regexp locate-dominating-stop-dir-regexp

      ;; control n goes down even where nowhere to go
      next-line-add-newlines t

      focus-follows-mouse t
      mouse-autoselect-window t)

;; otherwise tabs in xmonad have a different title when you can't see them
(setq icon-title-format frame-title-format)

;; "dangerous" functions which are normally disabled
(put 'erase-buffer 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

(defmacro my-state-dir (x)
  "make a directory for holding state, and create it if needs be"
  `(let ((the-dir (concat user-emacs-directory "state/" ,x)))
     (make-directory the-dir t)
     the-dir))

(let ((backup-directory (my-state-dir "backups/")))
  (setq
    auto-save-list-file-prefix (concat backup-directory "auto-save-list-")
    backup-directory-alist `((".*" . ,backup-directory))
    tramp-backup-directory-alist `((".*" . ,backup-directory))
    auto-save-file-name-transforms `((".*" ,backup-directory t))))

(setq-default indent-tabs-mode nil
              case-fold-search t)
