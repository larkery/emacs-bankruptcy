(require 'cl)

(defmacro add-prog-hooks (&rest fns)
  `(progn
     ,@(let (result)
         (dolist (f fns result)
           (push `(add-hook 'prog-mode-hook ,f) result)
           (push `(add-hook 'ess-mode-hook  ,f) result)))))

(defmacro set-mode-name (mode name)
  `(add-hook (quote ,(intern (concat (symbol-name mode) "-hook")))
             (lambda () (interactive) (setq mode-name ,name))))

;;; PCRE mode - use perlish regex
;; global PCRE mode rather than annoying emacs regex mode.

(req-package pcre2el
  :diminish (pcre-mode . "")
  :config
  (pcre-mode t))

;;; dired
;;;; enables the use of 'a' in dired to reuse the buffer
(put 'dired-find-alternate-file 'disabled nil)
(add-hook
 'dired-mode-hook
 (lambda () (interactive) (local-set-key (kbd "V") #'magit-status)))

;;;; use key ')' to toggle omitted files in dired
(req-package dired-x
  :commands dired-omit-mode
  :init
  (add-hook 'dired-load-hook (lambda () (require 'dired-x)))
  (bind-key ")" #'dired-omit-mode dired-mode-map))

(set-mode-name dired-mode "dir")

;;;; insert dired subtree indented rather than at bottom
(req-package dired-subtree
  :commands dired-subtree-toggle dired-subtree-cycle
  :init
  (bind-key "<tab>" #'dired-subtree-toggle dired-mode-map))

;;;; enable dired filtering - joined up with a hydra below
(req-package dired-filter :defer t)

;;; editing
;;;; Outshine outline

(defvar outline-minor-mode-prefix "\M-o")

(req-package outshine
  :commands outshine-hook-function outshine-cycle-buffer
  :init
  (add-hook 'outline-minor-mode-hook 'outshine-hook-function)
  (add-hook 'emacs-lisp-mode-hook 'outline-minor-mode)
  (setq outshine-use-speed-commands t)
  :config

  (diminish 'outline-minor-mode "")

  (progn
    (dolist (key '("M-<up>" "M-<down>" "M-S-<down>" "M-<right>" "M-<left>" "C-S-<left>" "C-S-<up>" "C-S-<down>" "M-TAB"))
      (define-key outline-minor-mode-map (kbd key) nil))
    (bind-key "<backtab>" #'outshine-cycle-buffer outline-minor-mode-map)))

;;;; Adaptive wrap

(req-package adaptive-wrap
  :commands adaptive-wrap-prefix-mode
  :init
  (add-hook 'visual-line-mode-hook #'adaptive-wrap-prefix-mode))

;;;; Expand-region

(req-package expand-region :bind ("C-=" . er/expand-region))

;;;; Undo-tree

(req-package undo-tree
  :diminish undo-tree-mode
  :init
  (global-undo-tree-mode)
  (global-set-key (kbd "C-z") 'undo)
  (defalias 'redo 'undo-tree-redo)
  (global-set-key (kbd "C-S-z") 'redo)
  (global-set-key (kbd "C-M-z") 'undo-tree-visualize))

;;;; saveplace

(req-package saveplace
  :init
  (setq-default save-place t)
  (setq save-place-file (h/ed "state/saved-places")))

;;;; hippie-expand on M-?

(req-package hippie-exp
  :init
  (bind-key* "M-?" (make-hippie-expand-function '(try-expand-line) t)))

;;;; Cleanup whitespace

(req-package ws-butler
  :diminish ""
  :commands ws-butler-global-mode
  :init
  (ws-butler-global-mode))

;;;; yasnippet

(req-package yasnippet
  :diminish (yas-minor-mode . "")
  :config
  (yas-global-mode))

;;;; convenience for align-regexp

(defun h/tabulate ()
  (interactive)
  (let ((a (region-beginning))
        (b (region-end)))
    (align-regexp
     a b
     "\\(\\s-*\\) "
     0
     1
     t)
    (indent-region a b)))

(bind-key "C-x t" #'h/tabulate)

(req-package avy-zap
  :bind ("M-z" . avy-zap-to-char-dwim))

;;;; comment-dwim

(req-package comment-dwim-2
  :bind ("M-;" . comment-dwim-2))

;;;; multiple-cursors

(req-package multiple-cursors
  :bind (("C-; C-;" . mc/mark-all-like-this-dwim)
         ("C-; C-a" . mc/edit-beginnings-of-lines)
         ("C-; C-e" . mc/edit-ends-of-lines)
         ("C-<" . mc/mark-previous-like-this)
         ("C->" . mc/mark-next-like-this)
         ("C-; o" . mc-hide-unmatched-lines-mode)
         ("C-S-<mouse-1>" . mc/add-cursor-on-click))

  :config
  (setq mc/list-file (h/ed "state/mc-list-file.el"))
  (require 'mc-hide-unmatched-lines-mode))

;;;; smartparens

(req-package smartparens
  :diminish ""
  :config

  (require 'smartparens-config)

  (defun h/slurp-appropriately ()
    (interactive)
    (if (derived-mode-p 'lisp-mode 'emacs-lisp-mode 'clojure-mode)
        (call-interactively #'sp-forward-slurp-sexp)
      (call-interactively #'sp-slurp-hybrid-sexp)))

  (defun h/kill-sexp-appropriately ()
    (interactive)
    (if (derived-mode-p 'lisp-mode 'emacs-lisp-mode 'clojure-mode)
        (call-interactively #'sp-kill-sexp)
      (call-interactively #'sp-kill-hybrid-sexp)))

                                        ;(sp-local-pair 'org-mode "$" "$")
                                        ;(sp-local-pair 'org-mode "/" "/" :actions '(wrap))
                                        ;(sp-local-pair 'org-mode "*" "*" :actions '(wrap))

  (defmacro my-define-wrap-command (open close)
    (let ((function-name (intern (concat "my-wrap-with-" open))))
      `(progn (defun ,function-name
                  (arg)
                (interactive "P")
                (cond
                 ((equalp '(4) arg)
                  (sp-rewrap-sexp '(,open . ,close)))
                 (t (sp-wrap-with-pair ,open))))
              (bind-key ,(concat "C-c " open)
                        (quote ,function-name)
                        smartparens-mode-map))))

  (my-define-wrap-command "(" ")")
  (my-define-wrap-command "[" "]")
  (my-define-wrap-command "{" "}")

  (bind-keys
   :keymap smartparens-mode-map
   ("C-c ^" . sp-splice-sexp-killing-around)

   ("C-M-;" . h/comment-sexp)
   ("C-M-<space>" . sp-select-next-thing)

   ("M-<up>" . sp-backward-up-sexp)
   ("M-<down>" . sp-down-sexp)
   ("M-S-<down>" . sp-up-sexp)
   ("C-M-k" . h/kill-sexp-appropriately)
   ("C-S-k" . sp-kill-sexp)

   ("M-<right>" . sp-forward-sexp)
   ("M-<left>" . sp-backward-sexp)

   ("C-S-<right>" . h/slurp-appropriately)
   ("C-S-<left>"  . sp-forward-barf-sexp)
   ("C-S-<up>"    . sp-backward-slurp-sexp)
   ("C-S-<down>"  . sp-backward-barf-sexp))

  (defun h/comment-sexp (arg)
    (interactive "P")
    (when arg
      (sp-backward-up-sexp))

    (mark-sexp)
    (comment-dwim-2))

  (show-smartparens-global-mode t)
  (smartparens-global-mode t))

(req-package mwim :bind (("C-e" . mwim-end-of-code-or-line)))

;;; git

(req-package magit
  :commands magit
  :bind (("C-c g" . magit-status)
         ("C-c C-m" . magit-status))
  :config
  (setq magit-last-seen-setup-instructions "1.4.0"))

(req-package git-timemachine
  :require magit
  :bind ("C-c G" . git-timemachine)
  :commands git-timemachine)

(req-package diff-hl
  :config
  (global-diff-hl-mode))

;;; ibuffer

(req-package ibuffer
  :config
  (setq ibuffer-filter-group-name-face 'outline-2))

;;; ido

(el-get-bundle larkery/ido-match-modes.el)
(el-get-bundle larkery/ido-describe-prefix-bindings.el)
(el-get-bundle larkery/ido-grid.el)

(req-package ido-match-modes :require ido)

(req-package ido-grid
  :require ido-match-modes
  :config
  (ido-grid-enable)
  (ido-match-modes-enable))

(req-package ido-occur
  :bind ("C-S-s" . h/ido-occur)
  :config
  (defun h/ido-occur ()
    (interactive)
    (require 'hl-line)
    (let (old-key
          (calling-window (frame-selected-window))
          (is-hl hl-line-mode))
      (flet ((follow
              (&rest r)
              (with-selected-window calling-window
                (goto-line (string-to-number (car (split-string ido-grid--selection))))
                (hl-line-highlight))))
        (hl-line-mode 1)
        (advice-add 'ido-grid-up :after (symbol-function 'follow))
        (advice-add 'ido-grid-down :after (symbol-function 'follow))
        (unwind-protect
            (call-interactively #'ido-occur)
          (progn
            (advice-remove 'ido-grid-up (symbol-function 'follow))
            (advice-remove 'ido-grid-down (symbol-function 'follow))
            (unless is-hl
              (hl-line-mode -1))
            )))))
  )

(req-package ido
  :demand
  :config
  (setq ido-create-new-buffer 'always
        ido-use-filename-at-point 'guess
        ido-save-directory-list-file (h/ed "state/ido.last")
        ido-use-faces t)
  (ido-mode 1)
  (ido-everywhere 1)

  (defun h/ido-keys ()
    (define-key ido-completion-map (kbd "M-RET")
      (lambda () (interactive) (ido-record-work-directory)))
    (define-key ido-completion-map (kbd "M-a") 'ido-toggle-ignore)
    (define-key ido-completion-map (kbd "C-a") 'beginning-of-line))

  (add-hook 'ido-setup-hook #'h/ido-keys))

(req-package ido-ubiquitous
  :config
  (ido-ubiquitous-mode))

(req-package ido-at-point
  :config
  (ido-at-point-mode 1))

(req-package ido-exit-target
  :config
  (require 'ido-exit-target))

(req-package ido-describe-prefix-bindings
  :bind ("M-X" . ido-describe-mode-bindings)
  :config
  (ido-describe-prefix-bindings-mode 1))

(req-package smex
  :commands smex
  :require (ido ido-ubiquitous)
  :bind (("M-x" . smex))
  :config
  (setq smex-save-file (h/ed "state/smex-items")
        smex-flex-matching nil)

  (defun h/advise-smex-bindings ()
    (define-key ido-completion-map (kbd "<tab>") 'ido-complete))

  (advice-add 'smex-prepare-ido-bindings :after #'h/advise-smex-bindings))

;;; recentf - where to remember, keys

(req-package recentf
  :bind ("C-x C-r" . h/recentf-find-file)
  :demand
  :config
  (setq recentf-save-file (h/ed "state/recentf")
        recentf-exclude '(".ido.last" "org-clock-save.el")
        recentf-max-menu-items 1000
        recentf-max-saved-items 1000)

  (recentf-mode 1)

  (defun h/recentf-find-file ()
    "Find a recent file."
    (interactive)
    (let* ((file (completing-read "Recent files: " recentf-list nil t)))
      (when file
        (find-file file)))))

;;; lacarte - ido for menubar
(req-package lacarte
  :bind (("M-<f10>" . menu-bar-open)
         ("<f10>" . lacarte-execute-menu-command)))

;;; imenu
(req-package imenu
  :init
  (setq imenu-auto-rescan t))
;;;; imenu-anywhere
(req-package imenu-anywhere
  :bind ("M-<menu>" . imenu-anywhere))

;;; programming

(set-mode-name emacs-lisp-mode "eλ")

(req-package highlight-symbol
  :diminish ""
  :commands highlight-symbol-mode highlight-symbol-nav-mode
  :init
  (add-prog-hooks #'highlight-symbol-mode)
  (add-prog-hooks #'highlight-symbol-nav-mode))

(req-package rainbow-delimiters
  :commands rainbow-delimiters-mode
  :init
  (add-prog-hooks #'rainbow-delimiters-mode))

(req-package ggtags
  :commands ggtags-mode
  :init
  (add-hook 'java-mode-hook 'ggtags-mode)

  (defun h/ggtags-abbreviate-adv (o start end)
    (funcall o start end)
    ;; un-invisible the last invisible bit before end

    (goto-char end)
    (iy-go-up-to-char-backward 1 ?\/)
    (remove-list-of-text-properties (1+ (point)) end '(invisible)))

  (advice-add 'ggtags-abbreviate-file :around #'h/ggtags-abbreviate-adv)
  (setq ggtags-completing-read-function
        (lambda (&rest args)
          (apply #'ido-completing-read
                 (car args)
                 (all-completions "" ggtags-completion-table)
                 (cddr args)))))

;;;; ess

(req-package ess
  :require ess-smart-underscore
  :commands R R-mode
  :mode ("\\.R\\'" . R-mode)
  :config
  (require 'ess-site)
  (add-hook 'ess-send-input-hook
            (lambda ()
              (interactive)
              (ess-execute-screen-options t)))


  (defun ess-ediff-fake-mode (&rest args)
    ;; put back ess-mode
    (setq-local major-mode #'ess-mode)
    ;; activate ess mode with its extra argument which is let-bound
    (ess-mode (if (symbolp buffer-ess-customize-alist)
                  (eval buffer-ess-customize-alist)
                buffer-ess-customize-alist)))

  (defun ess-ediff-setup-advice (original
                                 buffer-A file-A buffer-B file-B buffer-C file-C
                                 startup-hooks setup-parameters
                                 &optional merge-buffer-file)
    "ESS and ediff do not work together, because ESS buffers are in ESS-mode,
but to go into ESS-mode you are meant to invoke R-mode or S-mode or similar.
Ediff just invokes the major mode for the buffer, which ESS doesn't like.
So, we patch `ediff-setup' so that it sees the relevant mode invoking function."

    (let* ((buffer-to-use (if (eq ediff-default-variant 'default-B) buffer-B buffer-A))
           (buffer-ess-customize-alist (buffer-local-value 'ess-local-customize-alist buffer-to-use)))

      (if (function-equal (buffer-local-value 'major-mode buffer-to-use) #'ess-mode)
          (unwind-protect
              (progn
                ;; swap the major mode for our hack, which sorts out the annoying customize alist thing
                (with-current-buffer buffer-to-use
                  (setq-local major-mode #'ess-ediff-fake-mode))
                ;; call the original function, but having swapped the mode for
                ;; our hack
                (funcall original
                         buffer-A file-A buffer-B file-B buffer-C file-C
                         startup-hooks setup-parameters
                         merge-buffer-file))
            ;; unpickle the major mode whatever happens
            (with-current-buffer buffer-to-use
              (setq-local major-mode #'ess-mode)))

        ;; call the original function with no messing around.
        (funcall original
                 buffer-A file-A buffer-B file-B buffer-C file-C
                 startup-hooks setup-parameters
                 merge-buffer-file)
        )))

  ;; hack ediff-setup so that our function is called in its place.
  (advice-add 'ediff-setup :around #'ess-ediff-setup-advice))

;;;; clojure

(req-package cider :pin melpa-stable
  :config
  (setq cider-mode-line
        '(:eval (format " cdr[%s]"
                        (let ((x (cider--modeline-info)))
                          (if (string= x "not connected")
                              "ø" x))))))


(req-package clojure-mode :pin melpa-stable
  :config
  (set-mode-name clojure-mode "clj"))

(add-hook 'clojure-mode-hook #'cider-mode)

;;;; javascript

(req-package js2-mode
  :mode "\\.js\\'"
  :config
  (set-mode-name js2-mode "js"))

(req-package ac-js2
  :commands ac-js2-mode
  :require js2-mode
  :init
  (add-hook 'js2-mode-hook 'ac-js2-mode))

(req-package eldoc
  (diminish 'eldoc-mode "")
  (add-prog-hooks #'eldoc-mode))

(add-hook 'java-mode-hook 'subword-mode)
(add-hook 'java-mode-hook
          #'(lambda nil (c-set-style "stroustrup")))

;;;; python

;; (req-package elpy
;;   :require jedi
;;   :commands elpy-enable
;;   :init
;;   (eval-after-load 'python-mode (elpy-enable)))

(req-package anaconda-mode
  :commands anaconda-mode
  :init
  (add-hook 'python-mode-hook #'anaconda-mode)
  (add-hook 'python-mode-hook #'anaconda-eldoc-mode)
  :config
  (bind-key "C-c C-f" 'anaconda-mode-show-doc python-mode-map))

;;;; geiser (scheme)

(req-package geiser)

;;; browse-kill-ring (M-y shows kill ring)

(req-package browse-kill-ring+
  :init
  (require 'browse-kill-ring+))

;;; projectile

(req-package projectile
  :diminish (projectile-mode . "")
  :config
  (setq projectile-completion-system 'ido)

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

  (projectile-global-mode t))

(req-package ibuffer-projectile)

;;; search

(req-package anzu
  :diminish (anzu-mode . "")
  :config
  (global-anzu-mode)
  (bind-key "M-%" #'anzu-query-replace)
  (bind-key "C-M-%" #'anzu-query-replace-regexp)
  (setq anzu-replace-to-string-separator "→")
  (set-face-attribute
   'anzu-replace-to
   nil
   :inherit 'default
   :box "red")

  (defun h/anzu-wangle-minibuffer-input (f buf beg end use-re overlay-limit)
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

  (defun h/anzu-pcre-mode (f prompt beg end use-re overlay-limit)
    (if (and use-re pcre-mode)
        (let ((res (funcall f (concat prompt " (PCRE)") beg end use-re overlay-limit)))
          (condition-case nil
              (rxt-pcre-to-elisp res)
            (error res)))
      (funcall f prompt beg end use-re overlay-limit)))

  (advice-add 'anzu--check-minibuffer-input :around #'h/anzu-wangle-minibuffer-input)
                                        ;(advice-remove 'anzu--check-minibuffer-input #'h/anzu-wangle-minibuffer-input)
  (advice-add 'anzu--query-from-string :around #'h/anzu-pcre-mode)
                                        ;(advice-remove 'anzu--query-from-string #'h/anzu-pcre-mode)
  )

(req-package wgrep)
(req-package ag :commands ag)

;;; erc

(req-package erc
  :config
  (defun h/erc-fill-nicks-thing ()
    (save-match-data
      (goto-char (point-min))
      (when (looking-at "^\\(\\S-+\\)")
        (let ((n (match-string 1)))
          (delete-region (match-beginning 1) (match-end 1))
          (cond
           ((or (equal "<***>" n)
                (equal "***" n))
            (progn
              (insert " •")
              (add-face-text-property (point-min) (point-max) 'highlight)))
           ((equal "*" n)
            (insert "             →" (substring n 1)))

           (t
            (insert (s-pad-left 12 " " (substring n 1 (- (length n) 1))) " •")))
          ))))

  (defvar-local h/last-timestamp-insert 0)

  (defun h/erc-insert-timestamp-at-end (stamp)
    (let ((now (float-time)))
      (when (> (- now h/last-timestamp-insert) 600)
        ;; ten minutes
        (setq h/last-timestamp-insert now)
        (end-of-line)
        (insert " ")
        (insert stamp))))

  (defun h/erc-mode-hook ()
    (erc-fill-mode 1)
    (setq erc-fill-function #'h/erc-fill-nicks-thing)
    (visual-line-mode 1)
    (setq truncate-lines nil)
    (setq-local adaptive-fill-regexp ".+\\(•\\|→\\) +"))

  (add-hook 'erc-mode-hook #'h/erc-mode-hook))

(req-package znc
  :commands znc-all znc-erc
  :config

  (setq
   znc-servers
   `(("lrkry.com" 6667 nil
      ((freenode "hinton"
                 ,(cadr (netrc-credentials "lrkry.com" "6667"))
                 ))))))

;; breaks in eval after load
(require 'epass-authinfo)
(auth-epass-enable)

;;; diminish

(req-package diminish
  :config
  (diminish 'isearch-mode " →")
  (diminish 'adaptive-wrap-prefix-mode "")
  (diminish 'visual-line-mode " ⏎")
  (diminish 'abbrev-mode "")
  (diminish 'mml-mode "")
  )

;;; elfeed

(req-package elfeed
  :commands elfeed
  :bind ("C-c f" . elfeed))

;;; eno / avy

(defun avy-goto-paren ()
  (interactive)
  (avy--generic-jump "(\\|\\[" nil 'at)
  )

(req-package avy
  :bind (("M-g w" . avy-goto-word-1)
         ("M-g [" . avy-goto-paren)
         ("M-g s" . avy-isearch)
         ("C-c v" . avy-goto-char-in-line))
  :config
  (setq avy-style 'at-full))

;;; rainbow mode

(req-package rainbow-mode)

;;; polymode
;;;; r-markdown

;; (req-package markdown-mode)

;; (req-package polymode
;;   :commands poly-markdown+r-mode
;;   :mode ("\\.[Rr]md\\'" . poly-markdown+r-mode))

;;; project explorer

(req-package project-explorer
  :bind ("<f7>" . project-explorer-toggle)
  :config
  (defun h/advise-pe-follow (o &rest args)
    (if (projectile-project-p)
        (apply o args)
      (let ((window (pe/get-project-explorer-window)))
        (if window
            (with-selected-window window
              (with-current-buffer (window-buffer window)
                (pe/quit)))))
      ))

  (advice-add 'pe/follow-current-open :around #'h/advise-pe-follow))

;;; theme
(req-package tao-theme
  :init
  (load-theme 'tao-yang t)
  (load-theme 'adjustments t))

;;; i3 stuffs
(when t
  (el-get-bundle vava/i3-emacs)

  (require 'i3)
  (require 'i3-integration)
  (i3-advise-visible-frame-list-on))


;;; winner
(req-package winner
  :defer nil
  :bind ("C-6" . winner-undo)
  :config
  (winner-mode 1))

;;; flycheck
(req-package flycheck
  :config
  (global-flycheck-mode))



;;; nixos

;; (req-package nix-mode
;;   :mode ("\\.nix\\'" . nix-mode))

;; ;; need to add hooks elsewhere?
;; (req-package nix-sandbox-interpreter
;;   :commands nix-sandbox-interpreter-update
;;   :init
;;   (add-hook 'prog-mode-hook
;;             #'nix-sandbox-interpreter-update))

;;; god mode

(req-package god-mode
  :commands god-mode god-local-mode
  :bind (("C-o" . god-mode-all))
  :config
  (diminish 'god-local-mode " G")
  (define-key god-local-mode-map (kbd ".") 'repeat)
  (define-key god-local-mode-map (kbd "i") 'god-mode)
  (define-key god-local-mode-map (kbd "<escape>") 'god-mode)

  (require 'god-mode-isearch)

  (define-key isearch-mode-map (kbd "<C-escape>") 'god-mode-isearch-activate)
  (define-key god-mode-isearch-map (kbd "<escape>") 'god-mode-isearch-disable)

  (defvar *god-mode-normal-cursor-background* nil)

  (defun my-update-cursor ()
    (unless *god-mode-normal-cursor-background*
      (setq *god-mode-normal-cursor-background* (face-background 'cursor)))
    (let ((red god-local-mode))
      (blink-cursor-mode (if red 1 -1))
      (set-face-background 'cursor (if red "red" *god-mode-normal-cursor-background*))
      ))

  (add-hook 'god-mode-enabled-hook 'my-update-cursor)
  (add-hook 'god-mode-disabled-hook 'my-update-cursor)
  (add-hook 'window-configuration-change-hook 'my-update-cursor))

;; guide key?

(req-package which-key
  :diminish
  :config
  (which-key-setup-minibuffer)
  (which-key-mode)
  (setq max-mini-window-height 0.2))

(req-package w3m
  :config
  (setq w3m-default-symbol
        '("─┼" " ├" "─┬" " ┌" "─┤" " │" "─┐" ""
          "─┴" " └" "──" ""   "─┘" ""   ""   ""
          "─┼" " ┠" "━┯" " ┏" "─┨" " ┃" "━┓" ""
          "━┷" " ┗" "━━" ""   "━┛" ""   ""   ""
          " •" " □" " ☆" " ○" " ■" " ★" " ◎"
          " ●" " △" " ●" " ○" " □" " ●" "≪ ↑ ↓ ")))

;;; end
