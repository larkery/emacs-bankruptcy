;;; Load each thing from packages.d


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(require 'package)

(setq package-archives
      '(("melpa-unstable" . "http://melpa.org/packages/")
        ("melpa-stable" . "http://stable.melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")
        ("gnu" .  "http://elpa.gnu.org/packages/")))

(add-to-list 'package-directory-list "~/.nix-profile/share/emacs/site-lisp/elpa")

(package-initialize)

;; (byte-recompile-directory user-emacs-directory)

(dolist (f (directory-files
	    (concat user-emacs-directory
                "packages.d/") t "\\.el$"))
  (load f))
(put 'set-goal-column 'disabled nil)
