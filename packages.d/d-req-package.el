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
   (package-refresh-contents)
   (package-install 'req-package)
   (package-install 'bind-key)
   (require 'req-package)
   (req-package-force el-get)
   (require 'el-get)))

(add-hook 'after-init-hook #'req-package-finish)
