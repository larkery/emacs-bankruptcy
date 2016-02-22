;;; password-server.el --- supply passwords

;;; Code:

(define-minor-mode password-server-mode
  "Minor mode for password databases in org files; does secondary export to json"
  nil " PASS" nil
  (add-hook 'after-save-hook #'password-server-save-json nil t))

(defun password-server-element-name (x)
  (if (eq (org-element-type x) 'headline)
      (concat (password-server-element-name
               (org-element-property :parent x))
              ":"
              (org-element-property :raw-value x))
    ""))

(defun password-server-fold-tree (tree)
  (org-element-map tree 'headline
    (lambda (x)
      (let ((name (org-element-property :raw-value x))
            (p (org-element-property :PASSWORD x))
            (u (org-element-property :URL x))
            (l (org-element-property :USERNAME x)))
        (if (or p u l) ;; leaf node
            (remove-if-not #'identity
                       (list (cons 'name name)
                             (if l (cons 'username l))
                             (if p (cons 'password p))
                             (if u (cons 'url u))))

          ;; higher up node
          (list (cons 'name name)
                (cons 'contents (password-server-fold-tree (org-element-contents x))))

          )))
    nil
    nil
    '(headline)))

(defun password-server-save-json ()
  (require 'org-element)
  (when (eq major-mode 'org-mode)
    (let ((tree (org-element-parse-buffer 'headline))
          (filename (file-name-nondirectory (buffer-file-name)))
          (directory (file-name-directory (buffer-file-name)))
          (efet epa-file-encrypt-to))
      (with-temp-file (concat directory (file-name-sans-extension filename) ".json.gpg")
        (setq-local epa-file-encrypt-to efet)
        (insert (json-encode
                 (list
                  (cons 'name (file-name-sans-extension filename))
                  (cons 'contents (password-server-fold-tree tree)))))
        ))))

(defun password-server-lock ()
  ;; save if unsaved, and kill if open
  (dolist (b (buffer-list))
    (with-current-buffer b
      (when password-server-mode
        (save-buffer)
        (kill-buffer)))
    ))

(defun password-server-random (bits)
  (with-temp-buffer
   (set-buffer-multibyte nil)
   (call-process "head" "/dev/urandom" t nil "-c" (format "%d" (/ bits 8)))
   (let ((f (apply-partially #'format "%02x")))
     (string-to-number (mapconcat f (buffer-string) "") 16))))

(defun password-server-generate-password (&optional n)
  (with-current-buffer
      (find-file-noselect "/usr/share/dict/words")
    (let* (words
           pick
           (l (count-lines (point-min) (point-max)))
           (bits (/ (log (+ l 1)) (log 2))))
      (dotimes (i n)
        (setq pick (% (password-server-random bits) l))
        (goto-char (point-min))
        (forward-line pick)
        (push (buffer-substring (point) (line-end-position)) words))
      (mapconcat #'identity words " ")
      )))

(defun password-server-add-password (p)
  (interactive "P")
  (let* ((p (cond
            ((not p) 4)
            ((listp p) (truncate (/ (log (car p)) (log 4))))
            (t p)))
         (phrase (password-server-generate-password p))
         (readin (read-string (format "Password [%s]: " phrase)))
         (phrase (or (unless (eq "" readin) readin)
                     phrase)))
    (org-set-property "PASSWORD" phrase)))

(provide 'password-server)

;;; password-server.el ends here
