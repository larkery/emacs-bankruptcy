;; -*- lexical-binding: t -*-
(req-package key-seq
  :config
  (key-seq-define-global "jd" 'dired-ffap)

  (key-seq-define-global "jk" 'save-buffer)
  (key-seq-define-global "jx" 'split-window-below)
  (key-seq-define-global "jz" 'delete-other-windows)

  (key-seq-define-global "jv" 'delete-window)
  (key-seq-define-global "jg" 'magit-status)

  (with-eval-after-load 'god-mode
    (key-seq-define god-local-mode-map  "gg"
                    (lambda () (interactive)
                      (setq unread-command-events (listify-key-sequence "G")))))

  (key-chord-mode 1))
