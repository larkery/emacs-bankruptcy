(advice-add 'set-mouse-position :override #'ignore)
(advice-add 'set-mouse-pixel-position :override #'ignore)
(advice-add 'set-mouse-absolute-pixel-position :override #'ignore)

(defun shut-up (o &rest args)
  (let ((inhibit-message t))
    (apply o args)))


(defun my-adv-multi-pop-to-mark (orig-fun &rest args)
  "Call ORIG-FUN until the cursor moves.
Try the repeated popping up to 10 times."
  (let ((p (point)))
    (dotimes (i 10)
      (when (= p (point))
        (apply orig-fun args)))))


(advice-add 'pop-to-mark-command :around #'my-adv-multi-pop-to-mark)
