;; prerequisites for auto-instaling packages

;; configure package.el

(require 'package)

(setq package-archives
      '(("melpa-unstable" . "http://melpa.org/packages/")
        ("melpa-stable" . "http://stable.melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")
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

 (req-package--log-set-level 'trace)

;; do all the req-package stuff at the end of init



(if (member "--update" command-line-args)
    (progn
      (message "req-package-finish skipped")
      (package-list-packages)
      (package-menu-mark-upgrades)
      (package-menu-execute))
  
  (add-hook 'after-init-hook #'req-package-finish))
