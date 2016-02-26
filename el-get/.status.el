((el-get status "required")
 (i3-emacs status "installed" recipe
           (:name i3-emacs :type github :pkgname "vava/i3-emacs" :after nil))
 (ido-describe-prefix-bindings\.el status "installed" recipe
                                   (:name ido-describe-prefix-bindings\.el :type github :pkgname "larkery/ido-describe-prefix-bindings.el" :after nil))
 (ido-grid\.el status "installed" recipe
               (:name ido-grid\.el :type github :pkgname "larkery/ido-grid.el" :after nil))
 (ido-match-modes\.el status "installed" recipe
                      (:name ido-match-modes\.el :type github :pkgname "larkery/ido-match-modes.el" :after nil)))
