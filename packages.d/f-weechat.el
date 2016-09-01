(req-package weechat
  :config
  (setq weechat-mode-default 'ssl
        weechat-color-list
        (quote
         (unspecified
          "black" "dark gray" "dark red"
          "red" "green" "light green"
          "brown" "yellow" "deepskyblue"
          "light blue" "dark magenta" "magenta"
          "dark cyan" "light cyan" "gray"
          "white"))

        weechat-host-default
        "lrkry.com"

        weechat-modules
        '(weechat-button
          weechat-complete
          weechat-tracking
          weechat-notifications
          weechat-image)
        ))
