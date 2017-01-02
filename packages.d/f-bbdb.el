(initsplit-this-file bos "bbdb-")

(req-package bbdb
  :commands bbdb
  :require bbdb-vcard bbdb-ext bbdb-handy
  :config
  (setq bbdb-mail-user-agent (quote message-user-agent)
        bbdb-user-mail-address-re "\\<hinton\\>"))
