;;; Minimal chrome - no scroll / menu / toolbar

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; no cursor blinky
(blink-cursor-mode -1)
(setq-default cursor-type 't) ;; box cursor
(setq inhibit-startup-screen t) ;; no startup screen

;;; Macros for emacs directory

(defmacro h/ed (x) `(concat user-emacs-directory ,x))
(defmacro h/sd (x) `(concat user-emacs-directory "state/" ,x))

;;; Allow loading from my site-lisp dir

(push (h/ed "site-lisp") load-path)
(push (h/ed "site-lisp") custom-theme-load-path)

;;; Load my theme

(load-theme 'plain t)

;;; Misc settings which are quite basic

;; eldoc mode for these

(setq load-prefer-newer         t
      gc-cons-threshold         50000000
      history-length            1000
      history-delete-duplicates t
      echo-keystrokes           0.2
      scroll-conservatively     10
      set-mark-command-repeat-pop t
      frame-title-format        '( "[%b] " (buffer-file-name "%f" default-directory)))

;; Make various files go in the state/ dir

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

;; Makes yes / no questions into y/n ones - dangerous
(defalias 'yes-or-no-p 'y-or-n-p)

;; linux-specific - open urls with xdg
(setq browse-url-generic-program "xdg-open")
(setq browse-url-browser-function 'browse-url-generic)
(put 'erase-buffer 'disabled nil)
