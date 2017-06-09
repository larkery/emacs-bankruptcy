;; (defvar tramp-add-space-to-command nil)


;; (defun prefix-tramp-with-space (o &rest args)
;;   "The old bug is fixed, but we want to add a space sometimes."

;;   (let ((tramp-add-space-to-command t))
;;     (apply o args)))


;; (defun tramp-send-command-space (o vec command &optional neveropen nooutput)
;;   (funcall o vec
;;            (if tramp-add-space-to-command
;;                (concat " " command)
;;              command)
;;            neveropen nooutput))


;; (advice-add 'tramp-open-shell :around #'prefix-tramp-with-space)

;; (advice-add 'tramp-send-command :around #'tramp-send-command-space)
