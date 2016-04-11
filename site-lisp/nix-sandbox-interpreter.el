;;; nix-sandbox-interpreter.el --- switch interpreter commands when there's a sandbox

;;; Commentary:

;; If using nix to sandbox dependencies in development, you can use
;; these functions to locally bind Emacs variables about what
;; interpreter to use so that they run inside the sandbox.

;;; Code:

(defcustom nix-sandbox-interpreter-mode-alist
  '((python-mode . (t python-shell-interpreter python-shell-interpreter-args) ))
  "An alist relating modes to interpreter symbols."
  :type '(alist :key-type (function :tag "Mode name")
                :value-type (list :tag "Interpreter details"
                                  (boolean :tag "Derive command from shebang line")
                                  (variable :tag "Interpreter command")
                                  (variable :tag "Interpreter arguments"))))

(defun nix-sandbox-interpreter-get-shebang ()
  "Get the details of the interpreter in the shebang line.
Checks the first line to see whether it matches
`auto-mode-interpreter-regexp'.  If it does, returns a cons cell
containing the interpreter name as the car, and any arguments as
the cdr."
  (save-match-data
    (save-excursion
      (save-restriction
        (widen)
        (goto-char (point-min))
        (narrow-to-region (line-beginning-position)
                          (line-end-position))
        (when (looking-at auto-mode-interpreter-regexp)
          (cons (match-string-no-properties 2)
                (buffer-substring-no-properties
                 (match-end 2)
                 (point-max))))))))

(defun nix-sandbox-shell-command (program sandbox)
  "Generate a script which will start PROGRAM in the SANDBOX.
Return the script's path.  The script will pass all arguments to
PROGRAM, and connect up its input and output"
  (let ((sandbox-script (concat user-emacs-directory
                                "sandboxes/" sandbox "/run-" program ".sh")))
    (unless
        (file-exists-p sandbox-script)
      (make-directory (file-name-directory sandbox-script) t)
      (with-temp-file
          sandbox-script
        (insert "#!/usr/bin/env bash\n")
        (insert "rest=\"\"\n")
        (insert "for arg in \"$@\"; do\n")
        (insert "  printf -v quoted '%q' \"$arg\"\n")
        (insert "  rest=\"$rest $quoted\"\n")
        (insert "done\n")
        (insert (format "nix-shell %s --run \"%s $rest\""
                        (shell-quote-argument sandbox)
                        program)))
      (chmod sandbox-script #o700))

    (expand-file-name sandbox-script)))

(defun nix-sandbox-interpreter-update ()
  "Set the sandboxed interpreter command for this mode."
  (interactive)
  (message "update interpreter for %s" (buffer-file-name))
  (let ((nix-sandbox-definition (expand-file-name
                                 (locate-dominating-file (buffer-file-name)
                                                         "default.nix"))))
    (when nix-sandbox-definition
      (dolist (item nix-sandbox-interpreter-mode-alist)
        (let ((mode (car item))
              (bindings (cdr item)))
          (when (derived-mode-p mode) ;; TODO only works for major mode
            (let* ((interpreter (cadr bindings))
                   (interpreter-args (caddr bindings))
                   (command-and-arguments
                    (or (and (car bindings)
                             (nix-sandbox-interpreter-get-shebang))
                        (cons (default-value interpreter)
                              (default-value interpreter-args))))
                   (command (car command-and-arguments))
                   (arguments (cdr command-and-arguments))

                   (new-interpreter (nix-sandbox-shell-command
                                     command
                                     nix-sandbox-definition))
                   (new-arguments
                    (when (and arguments
                               (not (string-empty-p arguments)))
                      (concat " '" arguments "'"))))

              (make-local-variable interpreter)
              (if interpreter-args
                  (progn
                    (make-local-variable interpreter-args)
                    (set interpreter new-interpreter)
                    (set interpreter-args new-arguments))

                (set interpreter
                     (if new-arguments (concat new-interpreter " " new-arguments)
                       new-interpreter)
                     )))))))
    ))

(provide 'nix-sandbox-interpreter)

;;; nix-sandbox-interpreter.el ends here
