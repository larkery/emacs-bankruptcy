;; -*- lexical-binding: t -*-
(initsplit-this-file bos "bbdb-")

(req-package bbdb-vcard
  :commands
  bbdb-vcard-import-file bbdb-vcard-export
  bbdb-vcard-import-region bbdb-vcard-import-buffer)

(req-package bbdb-ext :defer t
  :init
  (with-eval-after-load 'bbdb
    (require 'bbdb-ext)))

;; (req-package bbdb-handy :defer t
;;   :init
;;   (with-eval-after-load 'bbdb
;;     (require 'bbdb-handy)))

(req-package bbdb
  :commands bbdb
  :require
  :config
  (setq bbdb-mail-user-agent (quote message-user-agent)
        bbdb-user-mail-address-re "\\<hinton\\>"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bbdb-address-label-list (quote ("home" "work" "other")))
 '(bbdb-default-country "United Kingdom")
 '(bbdb-file "~/notes/bbdb")
 '(bbdb-file-remote nil)
 '(bbdb-phone-label-list (quote ("home" "work" "cell" "other")))
 '(bbdb-phone-style nil))
