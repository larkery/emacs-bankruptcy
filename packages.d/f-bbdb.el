(initsplit-this-file bos "bbdb-")

(req-package bbdb
  :commands bbdb
  :require bbdb-vcard bbdb-ext bbdb-handy
  :config
  (setq bbdb-mail-user-agent (quote message-user-agent)
        bbdb-user-mail-address-re "\\<hinton\\>"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bbdb-file-remote "/ssh:larkery.com:~/bbdb"))
