;; -*- lexical-binding: t -*-
(req-package ess-site
  :ensure ess
  :commands R
  :mode (("/R/.*\\.q\\'" . R-mode)
         ("\\.[rR]\\'" . R-mode))
  :defer t

  :config
  (ess-disable-smart-underscore nil)
  (add-hook 'inferior-ess-mode-hook (lambda ()
                                      (highlight-symbol-nav-mode -1)))
  (add-hook 'inferior-ess-mode-hook 'my-run-prog-mode-hook)
  (add-hook 'ess-mode-hook 'my-run-prog-mode-hook)

  (add-hook 'inferior-ess-mode-hook
            (lambda ()
              (setq-local comint-use-prompt-regexp nil)
              (setq-local inhibit-field-text-motion nil)))

  (defun ess-stupid-customize-alist-advice (o arg-alist proc-name)
    (if (not (or arg-alist ess-customize-alist))
        (progn
          (message "Missing customize-alist, hack hack hack")
          (R-mode))
      (funcall o arg-alist proc-name)))

  (advice-add 'ess-mode :around 'ess-stupid-customize-alist-advice)

  (with-eval-after-load 'semantic/symref/grep
    (push '(ess-mode "*.R")
          semantic-symref-filepattern-alist))

  (defun ess-stupid-customize-alist-advice (o &rest rest)
    (if (not (or (car rest) ess-local-customize-alist))
        (R-mode)
      (apply o rest)))

  (advice-add 'ess-mode :around 'ess-stupid-customize-alist-advice)

  (defun my-prettify-ess-symbols ()
    (interactive)
    (unless (assoc "%>%" prettify-symbols-alist)
      (push '("%>%" . ?➤) prettify-symbols-alist))
    (unless (assoc "%in%" prettify-symbols-alist)
      (push '("%in%" . ?⊂) prettify-symbols-alist))
    (prettify-symbols-mode 1))

  (defun projectile-update-R-tags (o &rest args)
    (interactive)
    (if (eq major-mode 'ess-mode)
        (ess-build-tags-for-directory
         (projectile-project-root)
         (concat (projectile-project-root) "/TAGS"))
      (apply o args)))

  (advice-add 'projectile-regenerate-tags :around #'projectile-update-R-tags)
  (add-hook 'ess-mode-hook #'my-prettify-ess-symbols)
  (add-hook 'inferior-ess-mode-hook #'my-prettify-ess-symbols)

  (with-eval-after-load 'align
    (push 'ess-mode align-c++-modes)
    (push `(R-assignment
            (regexp   . ,(concat "[^-=!^&*+<>/| \t\n]\\(\\s-*[-=!^&*+<>/|]*\\)"
                                 "<-\\(\\s-*\\)\\([^ \t\n]+\\|$\\)"))
            (valid    . (lambda ()
                          (not (string-match-p "function\\s-*(" (match-string 3)))))
            (group    . (1 2))
            (modes    . '(ess-mode))
            (justify  . t)
            (tab-stop . nil))
          align-rules-list)
    (push `(R-owl
            (regexp   . ,(concat "[^-=!^&*+<>/| \t\n]\\(\\s-*[-=!^&*+<>/|]*\\)"
                                 "%>%\\(\\s-*\\)\\([^ \t\n]\\)"))
            (group    . (1 2))
            (modes    . '(ess-mode))
            (justify  . t)
            (tab-stop . nil))
          align-rules-list)
    )

  (key-combo-define-hook
   '(ess-mode-hook)
   'my-ess-combo-hook
   '(("<" . ("<" "<- " "<<- "))
     (">" . (">" "%>%" "%>%\n"))))
  )
