(defun idomenu--guess-default (index-alist symbol)
  "Guess a default choice from the given symbol."
  (when symbol
    (catch 'found
      (let ((regex (concat "\\_<" (regexp-quote symbol) "\\_>")))
        (dolist (item index-alist)
          (if (string-match regex (car item)) (throw 'found (car item))))))))

(defun h/idomenu ()
  (interactive)

  (let ((index-alist (cdr (imenu--make-index-alist))))
    (if (equal index-alist '(nil))
        (message "No imenu tags in buffer")
      (let* ((flat-list (h/flat-ido-menu "" index-alist))
             (names (mapcar 'car flat-list))
             (default (idomenu--guess-default flat-list (thing-at-point 'symbol)))
             (chosen (completing-read "goto " names nil t nil nil default))
             (choice (assoc chosen flat-list)))
        (imenu choice)))))

(defun h/flat-ido-menu (prefix the-alist)
  (mapcan
   (lambda (x)
     (if (consp x)
         (if (imenu--subalist-p x)
             (h/flat-ido-menu (concat prefix (car x) "/")
                              (cdr x))
           (list (cons (concat prefix (car x))
                       (cdr x))))))
   the-alist))

(bind-key "<menu>" #'h/idomenu)
