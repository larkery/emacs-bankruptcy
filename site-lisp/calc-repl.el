(defun calc-repl-quick-eval ()
  (interactive)
  (save-excursion
    (goto-char (point-max))
    (search-backward-regexp "^> ")
    (let* ((input (buffer-substring-no-properties (match-end 0) (point-max)))

           (result (save-excursion
                     (calc-create-buffer)
                     (let* ((calc-command-flags nil)
                            (calc-language (if (memq calc-language '(nil big))
                                               'flat calc-language))

                            (alg-exp (mapcar 'math-evaluate-expr (math-read-exprs input)))
                            (buf (mapconcat (function (lambda (x)
                                                        (math-format-value x 1000)))
                                            alg-exp
                                            " ")))
                                        ;TODO: work out how to assign to v1, v2 and so on
                       buf))))
      (goto-char (point-max))
      (insert "\n= ")
      (insert result)
      (insert "\n> ")))
  (goto-char (point-max)))

(define-derived-mode calc-repl-mode fundamental-mode "calc repl"
  "Turn on calc-repl mode"
  ;; do the setup thing
  (goto-char (point-max))
  (insert "\n> ")
  (local-set-key (kbd "RET") 'calc-repl-quick-eval)
  )

(defun calc-repl ()
  (interactive)
  (let ((rbuf (get-buffer-create "*calc-repl*")))
    (pop-to-buffer rbuf)

    (with-current-buffer rbuf
      (calc-repl-mode))))
