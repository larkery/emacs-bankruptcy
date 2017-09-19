(initsplit-this-file bos (| "web-mode" "js2-mode"))

(req-package web-mode
  :mode (("\\.html\\'" . web-mode))
  )

(req-package js2-mode
  :mode (("\\.js\\'" . js2-mode))
  )
