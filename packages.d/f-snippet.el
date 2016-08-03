(req-package yasnippet
  :config
  (yas-global-mode 1)
  (define-key yas-minor-mode-map (kbd "<tab>") nil))

(req-package smart-tab
  :config
  (global-smart-tab-mode)
  (setq smart-tab-using-hippie-expand t))

(req-package clojure-snippets)
(req-package java-snippets)
