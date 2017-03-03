(req-package yasnippet
  :config
  (yas-global-mode))

(req-package clojure-snippets
  :defer t
  :init
  (with-eval-after-load 'clojure-mode
    (require 'clojure-snippets)))
(req-package java-snippets
  :defer t
  :init
  (with-eval-after-load 'java-mode
    (require 'java-snippets)))
