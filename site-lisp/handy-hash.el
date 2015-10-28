;;; handy-hash.el --- Make the hash key do other stuff

;; Copyright (C) 2015 Tom Hinton

;; Author: Tom Hinton <t@larkery.com>
;; Version: 1.0
;; Package-Requires: ((hydra "1.0))
;; Keywords: convenience
;; URL: https://github.com/larkery/handy-hash.el

;;; Commentary:

;; A mode which makes # do some things I want done

;;; Code:

(defvar handy-hash-did-something 0)

(defhydra handy-hash-hydra (:idle
                            0.5
                            :pre
                            (cl-incf handy-hash-did-something)
                            :post
                            (progn
                              (unless (> handy-hash-did-something 1) (insert "#"))
                              (setq handy-hash-did-something 0)))

  "hash"
  ("#" (insert "#") :exit t)
  ("q" (message "bye") :exit t)
  ("z" zzz-to-char "zap")
  ("k" (kill-buffer (buffer-name)) "close")
  ("g" magit-status "git" :exit t)
  ("u" undo-tree-undo "undo")
  ("r" undo-tree-redo "redo")
  ("b" ido-switch-buffer "buf" :exit t)
  ("o" occur "occur" :exit t)
  ("s" save-buffer "save")
  ("f" ido-find-file :exit t)
  ("p f" projectile-find-file "pff" :exit t)
  ("\'" hydra-projectile-start-body :exit t)
  ("d" (dired (file-name-directory (buffer-file-name))) "dired" :exit t))

(define-minor-mode handy-hash-mode
  "Handy hash!"
  :keymap (make-sparse-keymap)
  :global t
  :lighter " #")

(define-key handy-hash-mode-map "#"
  #'handy-hash-hydra/body)

;;; handy-hash.el ends here
