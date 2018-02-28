;; -*- lexical-binding: t -*-
(req-package yasnippet
  :diminish ""
  :config
  (yas-global-mode)
  (diminish 'yas-minor-mode ""))

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
