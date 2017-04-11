(advice-add 'set-mouse-position :override #'ignore)
(advice-add 'set-mouse-pixel-position :override #'ignore)
(advice-add 'set-mouse-absolute-pixel-position :override #'ignore)

(defun shut-up (o &rest args)
  (let ((inhibit-message t))
    (apply o args)))
