;;; Load each thing from packages.d

(dolist (f (directory-files (concat user-emacs-directory
                                    "packages.d/") t "\\.el$"))
  (load f))

;;; Start emacs server

(server-start)
