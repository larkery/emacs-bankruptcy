(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(defmacro h/ed (x) `(concat user-emacs-directory ,x))
(defmacro h/sd (x) `(concat user-emacs-directory "state/" ,x))

(push (h/ed "site-lisp") load-path)

(ignore-errors
  (require 'quasi-monochrome-hinton-theme)
  (load-theme 'quasi-monochrome-hinton t))

(blink-cursor-mode -1)
(setq-default cursor-type 't)
(setq inhibit-startup-screen t)

(setq load-prefer-newer         t
      gc-cons-threshold         50000000
      history-length            1000
      history-delete-duplicates t
      echo-keystrokes           0.2
      scroll-conservatively     10
      set-mark-command-repeat-pop t
      frame-title-format        '( "[%b] " (buffer-file-name "%f" default-directory)))

(defvar pcache-directory
  (let ((dir (h/sd "pcache/")))
    (make-directory dir t)
    dir))

(let ((backup-directory (h/sd "backups/")))
  (make-directory backup-directory t)

  (setq
    auto-save-list-file-prefix (concat backup-directory "auto-save-list-")
    backup-directory-alist `((".*" . ,backup-directory))
    tramp-backup-directory-alist `((".*" . ,backup-directory))
    auto-save-file-name-transforms `((".*" ,backup-directory t))))

(defalias 'yes-or-no-p 'y-or-n-p)

(setq browse-url-generic-program "xdg-open")
(setq browse-url-browser-function 'browse-url-generic)

