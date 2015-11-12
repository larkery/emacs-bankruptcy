;;; Load each thing from packages.d

(dolist (f (directory-files (concat user-emacs-directory
                                    "packages.d/") t "\\.el$"))
  (load f))

;;; Start emacs server

;; (unless (server-running-p)
;;   (server-start))
(put 'erase-buffer 'disabled nil)
