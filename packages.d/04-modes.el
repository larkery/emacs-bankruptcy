(req-package graphviz-dot-mode
  :commands graphviz-dot-mode
  :require org)

(req-package ess
  :require ess-smart-underscore
  :commands R)

(req-package cider)

(req-package js2-mode
  :mode "\\.js\\'")

(req-package ac-js2
  :commands ac-js2-mode
  :require js2-mode
  :init
  (add-hook 'js2-mode-hook 'ac-js2-mode))

(req-package ggtags
  :commands ggtags-mode
  :init
  (add-hook 'java-mode-hook 'ggtags-mode)

  (defun h/ggtags-abbreviate-adv (o start end)
    (funcall o start end)
    ;; un-invisible the last invisible bit before end

    (goto-char end)
    (iy-go-up-to-char-backward 1 ?\/)
    (remove-list-of-text-properties (1+ (point)) end '(invisible)))

  (advice-add 'ggtags-abbreviate-file :around #'h/ggtags-abbreviate-adv)
  (setq ggtags-completing-read-function
      (lambda (&rest args)
        (apply #'ido-completing-read
               (car args)
               (all-completions "" ggtags-completion-table)
               (cddr args)))))

(add-hook 'prog-mode-hook #'eldoc-mode)
(which-function-mode 1)

(add-hook 'java-mode-hook 'subword-mode)
(add-hook 'java-mode-hook
          #'(lambda nil (c-set-style "stroustrup")))
