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

  (defun my-prettify-ess-symbols ()
    (interactive)
    (unless (assoc "%>%" prettify-symbols-alist)
      (push '("%>%" . ?➤) prettify-symbols-alist))
    (unless (assoc "%in%" prettify-symbols-alist)
      (push '("%in%" . ?⊂) prettify-symbols-alist))
    (prettify-symbols-mode 1))

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
   '(ess-mode-hook inferior-ess-mode-hook)
   'my-ess-combo-hook
   '(("<" . ("<" "<- " "<<- "))
     (">" . (">" "%>%\n" "%>%")))))
