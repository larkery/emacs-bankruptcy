;;; Load each thing from packages.d
(setq gc-cons-threshold 8000000)

(eval-after-load "enriched"
  '(defun enriched-decode-display-prop (start end &optional param)
     (list start end)))

(require 'package)

(setq package-archives
      '(("melpa-unstable" . "http://melpa.org/packages/")
        ("melpa-stable" . "http://stable.melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")
        ("gnu" .  "http://elpa.gnu.org/packages/")))

(add-to-list 'package-directory-list "~/.nix-profile/share/emacs/site-lisp/elpa")
(let ((inhibit-message t)
      (inhibit-redisplay t)
      (file-name-handler-alist nil))
  (package-initialize)

  ;; (byte-recompile-directory user-emacs-directory)

  (dolist (f (directory-files
              (concat user-emacs-directory
                      "packages.d/") t "\\.el$"))
    (load f)))
(put 'set-goal-column 'disabled nil)

(setq gc-cons-threshold 80000000)
