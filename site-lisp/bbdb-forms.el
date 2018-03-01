;; -*- lexical-binding: t -*-

(require 'widget)
(require 'bbdb)
(eval-when-compile
  (require 'wid-edit))

(defun bbdb-edit-with-form (rec)
  (interactive (list (car (bbdb-completing-read-records "Who: "))))
  (switch-to-buffer "*BBDB: Person Name*")
  (kill-all-local-variables)
  (let ((inhibit-read-only t)) (erase-buffer))
  (remove-overlays)
  (widget-create 'editable-field :format "First name: %v" (bbdb-record-firstname rec))
  (widget-create 'editable-field :format "Surname: %v" (bbdb-record-lastname rec))
  (insert "Email:\n")
  (widget-create 'editable-list
                 :value (bbdb-record-mail rec)
                 '(editable-field))

  (insert "Telephone:\n")
  (widget-create 'editable-list
                 :value (bbdb-record-phone rec)
                 '(editable-field))

  ;; postal address

  ;; notes box
  ;; save / cancel

  (widget-create 'push-button "Save")
  (use-local-map widget-keymap)
  (widget-setup))

(provide 'bbdb-forms)
