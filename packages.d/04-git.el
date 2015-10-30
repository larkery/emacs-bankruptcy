(req-package magit
  :commands magit
  :bind ("C-c g" . magit-status)
  :config
  (setq magit-last-seen-setup-instructions "1.4.0"))

(req-package git-timemachine
  :require magit
  :bind ("C-c G" . git-timemachine)
  :commands git-timemachine)

(req-package git-gutter-fringe
  :config
  (require 'git-gutter-fringe)
  (setq git-gutter-fr:side 'right-fringe)
  (global-git-gutter-mode t))
