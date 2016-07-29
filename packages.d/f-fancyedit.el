(req-package pcre2el
  :diminish (pcre-mode . "")
  :config
  (pcre-mode t))

(req-package anzu
  :diminish (anzu-mode . "")
  :config

  (setq anzu-cons-mode-line-p nil)

  (global-anzu-mode)
  (bind-key "M-%" #'anzu-query-replace)
  (bind-key "C-M-%" #'anzu-query-replace-regexp)
  (setq anzu-replace-to-string-separator "→")

  (set-face-attribute
   'anzu-replace-to
   nil
   :inherit 'default
   :box "red")

  (defun my-anzu-wangle-minibuffer-input (f buf beg end use-re overlay-limit)
    (if (and use-re pcre-mode)
        (let ((-minibuffer-contents (symbol-function 'minibuffer-contents)))
          (flet ((minibuffer-contents
                  ()
                  (let ((mc (funcall -minibuffer-contents)))
                    (condition-case nil
                        (rxt-pcre-to-elisp mc)
                      (error mc)))
                  ))
            (funcall f buf beg end use-re overlay-limit)))

      (funcall f buf beg end use-re overlay-limit)))

  (defun my-anzu-pcre-mode (f prompt beg end use-re overlay-limit)
    (if (and use-re pcre-mode)
        (let ((res (funcall f (concat prompt " (PCRE)") beg end use-re overlay-limit)))
          (condition-case nil
              (rxt-pcre-to-elisp res)
            (error res)))
      (funcall f prompt beg end use-re overlay-limit)))

  (advice-add 'anzu--check-minibuffer-input :around #'my-anzu-wangle-minibuffer-input)
  (advice-add 'anzu--query-from-string :around #'my-anzu-pcre-mode))

(req-package multiple-cursors
  :commands my-mc-map
  :require smartrep region-bindings-mode
  :bind (("C-x C-m" . my-mc-map))
  :config

  (define-prefix-command 'my-mc-map)

  (bind-keys
   :map my-mc-map
   ("m" . mc/mark-all-like-this-in-defun)
   ("M" . mc/mark-all-like-this)
   ("a" . mc/edit-beginnings-of-lines)
   ("e" . mc/edit-ends-of-lines)
   ("N" . mc/insert-numbers))

  (bind-keys
   :map region-bindings-mode-map
   ("m" . my-mc-map)
   )

  (smartrep-define-key
      my-mc-map
      ""
      '(("n" . mc/mark-next-like-this)
        ("p" . mc/mark-previous-like-this)))
  )

(req-package wgrep)
(req-package ag :commands ag)

(req-package avy
  :bind (("M-g w" . avy-goto-word-1)
         ("M-g e" . avy-goto-paren)
         ("M-g s" . avy-isearch)
         ("C-c v" . avy-goto-char-in-line))
  :config
  (defun avy-goto-paren ()
    (interactive)
    (avy--generic-jump "(\\|\\[" nil 'at))
  (setq avy-style 'at-full))

(req-package expand-region :bind ("C-=" . er/expand-region))

(req-package adaptive-wrap
  :commands adaptive-wrap-prefix-mode
  :init
  (add-hook 'visual-line-mode-hook #'adaptive-wrap-prefix-mode))
