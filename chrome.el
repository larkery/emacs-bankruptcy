;; chrome

  ;; nice themes:
  ;; tao
  ;; sanityinc-tomorrow-night
  ;;noctilux
  ;;ample

(defvar h/theme-package 'color-theme-sanityinc-tomorrow)
(defvar h/theme-name 'sanityinc-tomorrow-night)

(ignore-errors
  (load-theme h/theme-name t)
  )

;;;;;;;;;;; horrible startup screen
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
