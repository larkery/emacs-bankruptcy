(req-package ess-site
  :ensure ess
  :commands R
  :mode (("/R/.*\\.q\\'" . R-mode)
         ("\\.[rR]\\'" . R-mode))
  :defer t

  :config
  (ess-disable-smart-underscore nil)
  (add-hook 'inferior-ess-mode-hook (lambda ()
                                      (highlight-symbol-nav-mode -1)))
  (add-hook 'inferior-ess-mode-hook 'my-run-prog-mode-hook)

  (with-eval-after-load 'align
    (push 'ess-mode align-c++-modes))

  (key-combo-define-hook
   '(ess-mode-hook inferior-ess-mode-hook)
   'my-ess-combo-hook
   '(("<" . ("<" "<- " "<<- "))
     (">" . (">" "%>%\n" "%>%")))))
