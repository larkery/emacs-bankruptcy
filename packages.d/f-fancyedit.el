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
  :bind ("C-;" . my-mc-map)
  :commands

  mc/mark-all-like-this-in-defun
  mc/mark-all-like-this
  mc/edit-beginnings-of-lines
  mc/edit-ends-of-lines
  mc/insert-numbers

  :require smartrep
  :init

  (define-prefix-command 'my-mc-map)
  (bind-keys
   :map my-mc-map
   ("C-;" . mc/mark-all-dwim)
   ("C-o" . mc-hide-unmatched-lines-mode)
   ("C-m" . mc/mark-all-like-this-in-defun)
   ("C-M" . mc/mark-all-like-this)
   ("C-a" . mc/edit-beginnings-of-lines)
   ("C-e" . mc/edit-ends-of-lines)
   ("#" . mc/insert-numbers))

  (smartrep-define-key
      my-mc-map
      ""
      '(("C-n" . mc/mark-next-like-this)
        ("C-p" . mc/mark-previous-like-this))))


(req-package wgrep)
(req-package ag :commands ag)

;; (req-package eno
;;   :bind (("M-g w" . eno-word-goto)
;;          ("M-g e" . eno-paren-goto)
;;          ("M-g s" . eno-symbol-goto)
;;          ("M-g M-w" . eno-word-copy)
;;          ("M-g M-s" . eno-symbol-copy)
;;          ("M-g M-e" . eno-paren-copy))
;;   :config
;;   (eno-set-all-letter-str " sdfjkla;weioqpruvncmghxz,./")
;;   (eno-set-same-finger-list '("qaz" "wsx" "edc" "rfvg" "ujmhn" "ik," "ol." "p;/"))
;;   (setq eno-stay-key-list '("<prior>" "<next>" "<wheel-up>" "<wheel-down>")))


;; (req-package avy
;;   :bind (("M-g w" . avy-goto-word-1)
;;          ("M-g e" . avy-goto-paren)
;;          ("M-g s" . avy-isearch)
;;          ("C-c v" . avy-goto-char-in-line))
;;   :config
;;   (defun avy-goto-paren ()
;;     (interactive)
;;     (avy--generic-jump "(\\|\\[" nil 'at))
;;   (setq avy-style 'at-full))


(req-package expand-region :bind ("C-=" . er/expand-region)
  :config

  (with-eval-after-load 'notmuch
    (er/enable-mode-expansions 'notmuch-show-mode
                               'er/add-text-mode-expansions))

  )

(req-package adaptive-wrap
  :commands adaptive-wrap-prefix-mode
  :init
  (add-hook 'visual-line-mode-hook #'adaptive-wrap-prefix-mode))

(req-package tiny
  :bind ("C-#" . tiny-expand))
