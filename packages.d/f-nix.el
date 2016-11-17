(defvar sandboxes-directory (expand-file-name (concat user-emacs-directory "sandboxes/")))

(defun nix-set-python-interpreter (arg)
  (interactive "p")
  (let* ((nix-folder (expand-file-name
                     (locate-dominating-file buffer-file-name "default.nix")))
         (current-interp (if arg
                             (default-value 'python-shell-interpreter)
                             python-shell-interpreter)))
    (unless (string-match (rx-to-string `(: string-start ,sandboxes-directory))
                          current-interp)
      (let ((sandboxed-interp (nix-wrap-command current-interp nix-folder)))
        (setq-local python-shell-interpreter sandboxed-interp)))))

(defun nix-wrap-command (command directory)
  (let* ((comstr (format
                  "#!/usr/bin/env bash
. <(nix-shell --run 'declare -x' \"%s\")
exec \"%s\" \"$@\""
                  directory command))
         (wrapped-command (concat sandboxes-directory command "-" (md5 comstr))))
    (message "%s\n%s" wrapped-command comstr)
    (with-temp-file wrapped-command (insert comstr))
    (chmod wrapped-command #o700)
    wrapped-command))

(req-package nix-mode)
