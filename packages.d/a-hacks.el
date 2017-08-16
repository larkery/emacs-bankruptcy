(advice-add 'set-mouse-position :override #'ignore)
(advice-add 'set-mouse-pixel-position :override #'ignore)
(advice-add 'set-mouse-absolute-pixel-position :override #'ignore)

(defun shut-up (o &rest args)
  (let ((inhibit-message t))
    (apply o args)))

(with-current-buffer (get-buffer " *Echo Area 0*")
  (setq-local face-remapping-alist '((default (:weight bold)))))

(defun unless-minibuffer (o &rest args)
  (let ((inhibit-message (not (zerop (minibuffer-depth)))))
    (apply o args)))

(advice-add 'message :around #'unless-minibuffer)

(defadvice pop-to-mark-command
    (around ensure-new-position activate)
  (let ((p (point)))
    (dotimes (i 10)
      (when (= p (point))
        ad-do-it))))

(defun x-set-net-active-window (&rest _)
  (x-send-client-message
   nil                ; DISPLAY - nil is selected frame
   0                  ; DEST - 0 is root window of display
   nil                ; FROM - nil is selected frame
   "_NET_ACTIVE_WINDOW"    ; MESSAGE-TYPE - name of an Atom as a string
   32                 ; FORMAT  - size of the values in bits
   '(1 "_NET_WM_USER_TIME" 0) ; VALUES
   ))

(advice-add 'x-focus-frame :after #'x-set-net-active-window)
