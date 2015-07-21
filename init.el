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

(setq package-archives
      '(("melpa-stable" . "http://stable.melpa.org/packages/")
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

(defun h/load-packages ()
  (condition-case nil
      (require 'req-package)
    (error
     (message "installing req-package")
     (package-refresh-contents)
     (package-install 'req-package)
     (package-install 'bind-key)
     (require 'req-package)))
  (message "loading packages.el")
  (load (h/ed "packages.el"))
  (message "finishing")
  (req-package-finish)
  (load (h/ed "keys.el")))

(add-hook 'after-init-hook #'h/load-packages)
