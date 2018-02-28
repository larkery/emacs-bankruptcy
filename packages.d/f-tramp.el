;; -*- lexical-binding: t -*-
(req-package tramp
  :config
  (setq tramp-copy-size-limit 2048
        tramp-default-method "scp"))
