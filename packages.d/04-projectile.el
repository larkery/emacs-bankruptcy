

(req-package projectile
  :commands projectile-project-root projectile-find-file-dwim projectile-project-p
  :require (hydra)
  :bind (("<f8>" . hydra-projectile-start-body))

  :diminish (projectile-mode . " p")
  :config
  (setq projectile-completion-system 'ido)
  (projectile-global-mode t)
  (projectile-register-project-type 'gradle '("build.gradle") "./gradlew build -q" "./gradlew test -q")

  (defun h/projectile-ask-for-project (o &rest args)
    (if (projectile-project-p)
        (apply o args)
      (let ((projectile-switch-project-action o))
        (projectile-switch-project))))

  (advice-add 'projectile-find-file :around #'h/projectile-ask-for-project)
  (advice-add 'projectile-find-file-dwim :around #'h/projectile-ask-for-project)
  (advice-add 'projectile-dired :around #'h/projectile-ask-for-project)
  (advice-add 'projectile-find-dir :around #'h/projectile-ask-for-project)
  (advice-add 'projectile-vc :around #'h/projectile-ask-for-project)

  (defvar hydra-projectile-default-directory nil)

  (defmacro hydra-projectile-in-directory (&rest stuff)
    `(let ((default-directory
             (or hydra-projectile-default-directory default-directory)))
       ,@stuff))

  (defhydra hydra-projectile (:hint nil :exit t)
    "
%s(or hydra-projectile-default-directory (and (projectile-project-p) (projectile-project-root))  (concat default-directory \"*\"))
%s(concat (make-list (- (window-width (minibuffer-window)) 0) ?-))
  _f_: find file   _d_: find directory _D_: root directory _v_: version control
  _a_: ag search   _t_: tags           _c_: compile        _s_: switch
"
    ("f" (hydra-projectile-in-directory
          (call-interactively #'projectile-find-file-dwim)))
    ("<f8>" (hydra-projectile-in-directory
             (call-interactively #'projectile-find-file-dwim)))
    ("D" (hydra-projectile-in-directory (call-interactively #'projectile-dired)))
    ("d" (hydra-projectile-in-directory (call-interactively #'projectile-find-dir)))
    ("t" (hydra-projectile-in-directory (call-interactively #'ggtags-find-tag-dwim)))
    ("v" (hydra-projectile-in-directory (call-interactively #'projectile-vc)))
    ("c" (hydra-projectile-in-directory (call-interactively #'projectile-compile-project)))
    ("a" (hydra-projectile-in-directory (call-interactively #'projectile-ag)))
    ("s" (progn
           (let ((projectile-switch-project-action
                  (lambda ()
                    (setf hydra-projectile-default-directory (projectile-project-root))
                    )
                  ))
             (call-interactively #'projectile-switch-project)))
     :exit nil
     ))

  (defun hydra-projectile-start-body ()
    (interactive)
    (setf hydra-projectile-default-directory nil)
    (call-interactively #'hydra-projectile/body))

  (bind-key "<f8>" #'hydra-projectile-start-body)
  (setq projectile-switch-project-action #'hydra-projectile-start-body))
