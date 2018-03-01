;; -*- lexical-binding: t -*-

(use-package persistent-scratch
  :config
  (persistent-scratch-setup-default))
;; (defvar my-scratch-state (concat (my-state-dir "") "scratch.el"))


;; on startup, recover scratch

;; (when (file-exists-p my-scratch-state)
;;   (with-current-buffer (get-buffer-create "*scratch*")
;;     (insert-file-contents my-scratch-state nil nil nil t)))


;; (defun my-save-scratch ()
;;   (let ((scratch-buffer (get-buffer "*scratch*")))
;;     (when scratch-buffer
;;       (with-current-buffer scratch-buffer
;;         (write-file my-scratch-state)))))


;; (add-hook 'kill-emacs-hook #'my-save-scratch)
