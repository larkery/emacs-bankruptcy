;; -*- lexical-binding: t -*-

(require 'widget)
(require 'bbdb)
(eval-when-compile
  (require 'wid-edit))

(defun bbdb-edit-with-form ()
  (interactive)
  (switch-to-buffer "*BBDB: Person Name*")
  (kill-all-local-variables)
  (let ((inhibit-read-only t)) (erase-buffer))
  (remove-overlays)
  (widget-create 'editable-field :format "First name: %v" "Name")
  (widget-create 'editable-field :format "Surname: %v " "Name")

  ;; email addresses
  ;; phone numbers
  ;; postal address

  ;; notes box
  ;; save / cancel

  (widget-create 'push-button "Save")
  (use-local-map widget-keymap)
  (widget-setup)
  )

(provide 'bbdb-forms)
