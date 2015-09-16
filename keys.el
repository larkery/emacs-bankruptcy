(bind-key "C-x C-b" 'ibuffer)
(bind-key "C-0" 'delete-window)
(bind-key "C-1" 'delete-other-windows)
(bind-key "C-2" (lambda () (interactive) (split-window-vertically) (other-window 1 nil)))
(bind-key "C-3" (lambda () (interactive) (split-window-horizontally) (other-window 1 nil)))
(bind-key "C-4" 'make-frame-command)
(bind-key "C-x k" (lambda () (interactive) (kill-buffer (buffer-name))))
(bind-key "C-x C-k" 'kill-buffer)
(bind-key "M-/" 'hippie-expand)

(defun sacha/smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

(global-set-key [remap move-beginning-of-line]
                'sacha/smarter-move-beginning-of-line)

(defun sacha/fill-or-unfill-paragraph (&optional unfill region)
  "Fill paragraph (or REGION).
  With the prefix argument UNFILL, unfill it instead."
  (interactive (progn
                 (barf-if-buffer-read-only)
                 (list (if current-prefix-arg 'unfill) t)))
  (let ((fill-column (if unfill (point-max) fill-column)))
    (fill-paragraph nil region)))

(bind-key "M-q" 'sacha/fill-or-unfill-paragraph)
