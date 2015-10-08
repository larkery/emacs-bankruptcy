;; chrome

  ;; nice themes:
  ;; tao
  ;; sanityinc-tomorrow-night
  ;;noctilux
  ;;ample

;'sanityinc-tomorrow-night)

(ignore-errors
  (require 'quasi-monochrome-hinton-theme)
  (load-theme 'quasi-monochrome-hinton t)
  )

;;;;;;;;;;; horrible startup screen
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
