(req-package nav-flash
  :config

  (defun flash-after-advice (x)
    (nav-flash-show)
    x)

  (defun flash-after (fn)
    (advice-add fn :filter-return #'flash-after-advice))

  (flash-after #'recenter-top-bottom))

