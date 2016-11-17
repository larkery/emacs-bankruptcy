(require 'ansi-color)

(req-package compilation
  :config
  (defun colorize-compilation-buffer ()
    (let ((inhibit-read-only t))
      (ansi-color-apply-on-region (point-min) (point-max))))
  (add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

  (push
   '(nix "^error:.+at \\(.+\\):\\([0-9]+\\):\\([0-9]+\\)$" 1 2 3)
   compilation-error-regexp-alist-alist)

  (push 'nix compilation-error-regexp-alist)
  )

