;; prerequisites for auto-instaling packages

;; configure package.el

(require 'package)

(setq package-archives
      '(("melpa-unstable" . "http://melpa.org/packages/")
        ("gnu" .  "http://elpa.gnu.org/packages/")))

(package-initialize)

;; make sure req-package exists, and el-get

(condition-case nil
    (progn
      (require 'req-package)
      (require 'el-get))
  (error
   (message "installing req-package")
   (package-refresh-contents)
   (package-install 'req-package)
   (package-install 'bind-key)
   (require 'req-package)
   (req-package-force el-get)
   (require 'el-get)))

;; (req-package--log-set-level 'trace)

;; do all the req-package stuff at the end of init
(add-hook 'after-init-hook #'req-package-finish)
  