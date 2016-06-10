;; basic keybindings which aren't package-specific
(defun my-kill-this-buffer ()
  (interactive)
  (kill-buffer (buffer-name)))

(defun my-just-one-space ()
  (interactive)
  (cycle-spacing -1 t))

(defun my-tabulate ()
  (interactive)
  (let ((a (region-beginning))
        (b (region-end)))
    (align-regexp
     a b
     "\\(\\s-*\\) "
     0
     1
     t)
    (indent-region a b)))

(dolist (binding
	 `(("C-x C-b" . ibuffer)
	   ("C-x k"   . my-kill-this-buffer)
	   ("M-/" . hippie-expand)
	   ("C-z" . undo)
	   ([remap just-one-space] . my-just-one-space)

           ("C-c t" . my-tabulate)
           ("C-1" . ,(kbd "C-x 1"))
           ("C-2" . ,(kbd "C-x 2"))
           ("C-3" . ,(kbd "C-x 3"))
           ("C-5" . ,(kbd "C-x 0"))
           ("C-4" . ,(kbd "C-x 5 2"))
	   ))
  (let ((key (car binding))
	(action (cdr binding)))
    (global-set-key
     (if (stringp key) (kbd key) key)
     action)))

;; use control h for backspace, we have f1 for help
(define-key key-translation-map [?\C-h] [?\C-?])
