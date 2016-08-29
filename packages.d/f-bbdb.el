(req-package bbdb
  :require bbdb-vcard bbdb-ext)

(req-package bbdb-handy
  :commands bbdb-handy-enable
  :init
  (eval-after-load 'message
    (require 'bbdb-handy)
    (bbdb-handy-enable)))
