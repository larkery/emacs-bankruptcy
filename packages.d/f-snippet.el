(req-package yasnippet
  :config
  (yas-global-mode 1)
  (define-key yas-minor-mode-map (kbd "<tab>") nil))

(req-package smart-tab
  :config
  (global-smart-tab-mode)
  (setq smart-tab-using-hippie-expand t)
  (push 'message-mode smart-tab-disabled-major-modes)
  (push 'notmuch-message-mode smart-tab-disabled-major-modes))

(req-package clojure-snippets)
(req-package java-snippets)
