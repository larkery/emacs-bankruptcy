(blink-cursor-mode -1)
(setq-default cursor-type 't)
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(setq frame-title-format
      '( "[%b] " (buffer-file-name
                  "%f"
                  default-directory)))

(require 'package)
(require 'cl)

(defun h/ed (x)
  (concat user-emacs-directory x))

(push (h/ed "site-lisp") load-path)

(defvar pcache-directory
  (let ((dir (h/ed "state/pcache/")))
    (make-directory dir t)
    dir))

(let ((backup-directory (h/ed "state/backups/")))
  (setq backup-directory-alist
        `((".*" . ,backup-directory)))
  (setq auto-save-file-name-transforms
        `((".*" ,backup-directory t))))

(setq auto-save-list-file-prefix
      (h/ed "state/auto-save-list/.saves-"))

(make-directory (h/ed "state/backups/") t)
(make-directory (h/ed "state/auto-save-list/") t)

(setq package-archive-upload-base
      "/home/hinton/packages/emacs/")

(setq package-archives
      '(("local" . package-archive-upload-base)
        ("melpa-unstable" . "http://melpa.org/packages/")
        ("gnu" .  "http://elpa.gnu.org/packages/")))

(package-initialize)

(load (setq custom-file (h/ed "custom.el")))
(load (h/ed "chrome.el"))

(defalias 'yes-or-no-p 'y-or-n-p)

;;;;;;;;;; utf-8
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;;;;;;;;;;; backip files
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq tramp-backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;;;;;;;;;; browse-url
(setq browse-url-generic-program "xdg-open")
(setq browse-url-browser-function 'browse-url-generic)

;;;;;;;;;;; no tabs
(setq-default indent-tabs-mode nil)

;;;;;;;;;;; lowercase search strings are case insensitive
(setq-default case-fold-search t)

(add-hook 'text-mode-hook #'visual-line-mode)

(defvar h/final-setup-hook nil)

(defun h/load-packages ()
  (condition-case nil
      (require 'req-package)
    (error
     (message "installing req-package")
     (package-refresh-contents)
     (package-install 'req-package)
     (package-install 'bind-key)
     (require 'req-package)))
  (load (h/ed "packages.el"))
  ;; TODO package-refresh-contents
  (req-package-finish)
  (load (h/ed "keys.el"))
  (run-hooks 'h/final-setup-hook))

(add-hook 'after-init-hook #'h/load-packages)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(setq set-mark-command-repeat-pop t)

;; not with ido.
;; (setq enable-recursive-minibuffers t)
;; (minibuffer-depth-indicate-mode t)
(setq-default abbrev-mode nil)
