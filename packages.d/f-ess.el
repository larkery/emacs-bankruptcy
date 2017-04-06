(req-package ess
  :commands R R-mode
  :mode (("/R/.*\\.q\\'" . R-mode)
         ("\\.[rR]\\'" . R-mode))
  :defer t
  :config
  (add-hook 'ess-mode-hook 'my-run-prog-mode-hook)
  (ess-disable-smart-underscore)
  (push 'ess-mode align-c++-modes)
  (key-combo-define-hook
   '(ess-mode-hook)
   'my-ess-combo-hook
   '(("<" . ("<" "<- "))
     (">" . (">" "%>%\n" "%>%")))))
