;;; Load each thing from packages.d

(require 'package)

(setq package-archives
      '(("melpa-unstable" . "http://melpa.org/packages/")
        ("melpa-stable" . "http://stable.melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")
        ("gnu" .  "http://elpa.gnu.org/packages/")))

(add-to-list 'package-directory-list "~/.nix-profile/share/emacs/site-lisp/elpa")
(let ((inhibit-message t)
      (inhibit-redisplay t))
  (package-initialize)

  ;; (byte-recompile-directory user-emacs-directory)

  (dolist (f (directory-files
              (concat user-emacs-directory
                      "packages.d/") t "\\.el$"))
    (load f)))
(put 'set-goal-column 'disabled nil)
