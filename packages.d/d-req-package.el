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

(unless (member "--update" command-line-args)
  (add-hook 'after-init-hook
            (lambda ()
              (let ((inhibit-message t))
                (req-package-finish)))))
