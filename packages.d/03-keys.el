(defun really-kill-this-buffer ()
  (interactive)
  (kill-buffer (buffer-name)))

(defun kill-this-buffer-and-close-window ()
  (interactive)
  (really-kill-this-buffer)
  (if (> (length (window-list)) 1)
      (delete-window)
    (delete-frame)))

(bind-key "C-x C-b" 'ibuffer)
(bind-key "C-0" 'delete-window)
(bind-key "C-1" 'delete-other-windows)
(bind-key "C-2" (lambda () (interactive) (split-window-vertically) (other-window 1 nil)))
(bind-key "C-3" (lambda () (interactive) (split-window-horizontally) (other-window 1 nil)))
(bind-key "C-4" 'make-frame-command)
(bind-key "C-x k" 'really-kill-this-buffer)
(bind-key "C-x C-k" 'kill-this-buffer-and-close-window)
(bind-key "C-x K" 'kill-buffer)
(bind-key "M-/" 'hippie-expand)
(bind-key "M-#" 'calc-dispatch)
(autoload 'comint-dynamic-complete-filename "comint" nil t)
(bind-key "M-]" 'comint-dynamic-complete-filename)
(bind-key "C-!" 'winner-undo)
(bind-key "C-\"" 'winner-redo)
(bind-key "<f9>" 'hl-line-mode)
(bind-key "C-S-SPC" 'set-rectangular-region-anchor)

(substitute-key-definition
 'just-one-space
 (lambda ()
   (interactive)
   (cycle-spacing -1 t))
 (current-global-map))

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

(defun narrow-or-widen (arg)
  (interactive "P")
  (let ((action
         (cond ((and (not arg)
                     (buffer-narrowed-p))   'widen)
               ((region-active-p)           'narrow-to-region)
               ((eq major-mode 'org-mode)   'org-narrow-to-element)
               ((derived-mode-p 'prog-mode) 'narrow-to-defun)
               ((derived-mode-p 'text-mode) 'narrow-to-page))))
    (when action
      (message (symbol-name action))
      (call-interactively action))))

(bind-key "<f8>" 'narrow-or-widen)
