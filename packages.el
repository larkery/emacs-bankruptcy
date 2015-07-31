(req-package magit
  :commands magit
  :bind ("C-c g" . magit-status)
  :config
  (setq magit-last-seen-setup-instructions "1.4.0"))

(req-package guide-key
  :diminish guide-key-mode
  :init
  (setq guide-key/idle-delay 0.5
        guide-key/recursive-key-sequence-flag t
        guide-key/popup-window-position 'bottom
        guide-key/guide-key-sequence    '("C-h" "C-x" "C-c" "C-z" "M-g")
        guide-key/highlight-command-regexp
        '("bookmark"
          ("window" . "green")
          ("file" . "red")
          ("buffer" . "cyan")
          ("register" . "purple")))
  
  
  (defun guide-key/my-hook-function-for-org-mode ()
    (guide-key/add-local-guide-key-sequence "C-c C-x")
    (guide-key/add-local-highlight-command-regexp '("org-" . "cyan"))
    (guide-key/add-local-highlight-command-regexp '("clock" . "hot pink"))
    (guide-key/add-local-highlight-command-regexp '("table" . "orange"))
    (guide-key/add-local-highlight-command-regexp '("archive" . "grey")))
  
  (add-hook 'org-mode-hook 'guide-key/my-hook-function-for-org-mode)

  (guide-key-mode 1))

(req-package lispy)

(req-package avy
  :bind
  (("M-g g" . avy-goto-line)
   ("M-g M-g" . avy-goto-line)
   ("M-g w" . avy-goto-word-1)
   ("M-g M-w" . avy-goto-word-0)))

(req-package smart-mode-line
  :config
  (sml/setup)
  (sml/apply-theme 'dark))

(req-package appt
  :config

  (require 'notifications)
  
  (defun h/appt-notify (mins new-time msg)
    (notifications-notify
     :body (format "In %s minutes" mins)
     :title (format "%s" msg)))

  (setq appt-message-warning-time 60
        appt-display-mode-line t
        appt-disp-window-function #'h/appt-notify
        appt-delete-window-function (lambda ())
        appt-display-interval 10
        appt-display-format 'window)
  
  (appt-activate t))

(req-package org
  :bind
  (("C-c a" . org-agenda)
   ("C-c l" . org-store-link)
   ("C-c c" . org-capture))
  
  :config
  (add-hook 'org-mode-hook
            (lambda ()
              (visual-line-mode 1)
              (setq mode-name "OM")))
  (add-hook 'org-agenda-finalize-hook 'org-agenda-to-appt)
  (run-at-time "24:01" 3600 'org-agenda-to-appt)

  (defvar h/clockin-timer nil)

  (defun h/start-clockin-timer (&optional time)
    (h/cancel-clockin-timer)
    (setq h/clockin-timer
          (run-with-idle-timer
           (or time 30)
           nil
           #'h/maybe-suggest-clocking-in)))

  (defun h/cancel-clockin-timer ()
    (when h/clockin-timer
      (cancel-timer h/clockin-timer))
    (setq h/clockin-timer nil))
  
  (defun h/maybe-suggest-clocking-in ()
    (interactive)
    (require 'org-clock)
    (let ((dow (elt (decode-time) 6)))
      (when (and
             (< 0 dow 6) ;; during the week
             (not (org-clocking-p))
             (let ((use-dialog-box
                    (not (frame-list))))
               (y-or-n-p "Clock in now? ")))
        (helm-org-agenda-files-headings))
      ;; think about asking again in half an hour whatever happened
      (h/start-clockin-timer 1800)
      ))

  (add-hook 'org-clock-in-hook #'h/cancel-clockin-timer)
  (add-hook 'org-clock-out-hook #'h/start-clockin-timer)

  (h/start-clockin-timer)
  
  (require 'org-contacts))

(req-package org-journal
  :require org
  :config (setq org-journal-dir "~/journal/"))

(req-package adaptive-wrap
  :config
  (add-hook 'text-mode-hook #'adaptive-wrap-prefix-mode))

(req-package smartparens
  :config
  (sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)
  (sp-with-modes sp--lisp-modes
    (sp-local-pair "(" nil :bind "C-("))
  
  (sp-with-modes '(html-mode nxml-mode sgml-mode)
    (sp-local-pair "<" ">"))

  (sp-with-modes sp--lisp-modes
    (sp-local-pair "'" nil :actions nil))
  
  (sp-local-tag '(html-mode nxml-mode sgml-mode)
                "<"  "<_>" "</_>" :transform 'sp-match-sgml-tags)

  (show-smartparens-global-mode t)
  (smartparens-global-mode t)

  (define-key smartparens-mode-map (kbd "C-M-f") 'sp-forward-sexp)
  (define-key smartparens-mode-map (kbd "C-M-b") 'sp-backward-sexp)
  (define-key smartparens-mode-map (kbd "C-M-9") 'sp-forward-slurp-sexp)
  (define-key smartparens-mode-map (kbd "C-M-0") 'sp-forward-barf-sexp))

(req-package ace-jump-buffer
  :bind ("C-c b" . ace-jump-buffer))

(req-package multiple-cursors
  :bind (("C-;" . mc/mark-all-like-this-dwim)
         ("C-:" . mc/edit-beginnings-of-lines)
         ("C-<" . mc/mark-previous-like-this)
         ("C->" . mc/mark-next-like-this)))


(req-package expand-region
  :bind ("C-=" . er/expand-region))

(req-package projectile
  :diminish (projectile-mode . " p")
  :config
  (setq projectile-completion-system 'helm)
  (projectile-global-mode))

(req-package helm-projectile
  
  :bind (("M-g f" . helm-projectile)
         ("M-g p" . helm-projectile-switch-project))
  :config
  (helm-projectile-on))

(req-package ggtags)

(req-package smartscan
  :config
  (add-hook 'prog-mode-hook #'smartscan-mode)
  (bind-key "M-p" #'smartscan-symbol-go-backward prog-mode-map)
  (bind-key "M-p" #'smartscan-symbol-go-forward prog-mode-map))

(req-package undo-tree
  :diminish undo-tree-mode
  :init
  (global-undo-tree-mode))

(load (h/ed "notmuch-config.el"))

(req-package graphviz-dot-mode)

(req-package ess)
(req-package ess-smart-underscore)

(req-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(req-package rainbow-identifiers)

(req-package saveplace
  :config
  (setq-default save-place t)
  (setq save-place-file (h/ed "state/saved-places")))
  
(req-package dired+
  :commands dired)

(req-package recentf
  :config  
  (setq recentf-save-file (h/ed "state/recentf")
        recentf-max-menu-items 100)
  (recentf-mode 1))

(req-package wgrep
  :init
  (require 'wgrep))

(req-package cider)

(req-package ag)

(req-package lacarte
  :bind ("M-`" . lacarte-execute-menu-command))

(req-package helm
  :diminish helm-mode
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x b" . helm-buffers-list)
         ("C-x C-r" . helm-recentf))
  
  :config
  (setq helm-echo-input-in-header-line nil
        helm-quick-update t
        helm-idle-delay 0.001
        helm-input-idle-delay 0.001
        helm-always-two-windows nil
        helm-ff-auto-update-initial-value nil
        helm-display-header-line nil
        helm-autoresize-max-height 40
        helm-autoresize-min-height 15
        helm-ff-skip-boring-files nil
        helm-boring-file-regexp-list '("\\.o$" "~$" "\\.bin$" "\\.lbin$" "\\.so$" "\\.a$" "\\.ln$" "\\.blg$" "\\.bbl$" "\\.elc$" "\\.lof$" "\\.glo$" "\\.idx$" "\\.lot$" "\\.svn$" "\\.hg$" "\\.git$" "\\.bzr$" "CVS$" "_darcs$" "_MTN$" "\\.fmt$" "\\.tfm$" "\\.class$" "\\.fas$" "\\.lib$" "\\.mem$" "\\.x86f$" "\\.sparcf$" "\\.dfsl$" "\\.pfsl$" "\\.d64fsl$" "\\.p64fsl$" "\\.lx64fsl$" "\\.lx32fsl$" "\\.dx64fsl$" "\\.dx32fsl$" "\\.fx64fsl$" "\\.fx32fsl$" "\\.sx64fsl$" "\\.sx32fsl$" "\\.wx64fsl$" "\\.wx32fsl$" "\\.fasl$" "\\.ufsl$" "\\.fsl$" "\\.dxl$" "\\.lo$" "\\.la$" "\\.gmo$" "\\.mo$" "\\.toc$" "\\.aux$" "\\.cp$" "\\.fn$" "\\.ky$" "\\.pg$" "\\.tp$" "\\.vr$" "\\.cps$" "\\.fns$" "\\.kys$" "\\.pgs$" "\\.tps$" "\\.vrs$" "\\.pyc$" "\\.pyo$" "\\.$" "\\..$" "^\\..+"))
  
  (bind-key "<tab>" 'helm-execute-persistent-action helm-map)
  (bind-key "C-i" 'helm-execute-persistent-action helm-map)
  (bind-key "`" 'helm-select-action helm-map)
  (bind-key "C-z" 'helm-select-action helm-map)

  (bind-key "C-." (lambda ()
                    (interactive)
                    (setq helm-ff-skip-boring-files (not helm-ff-skip-boring-files))
                    (helm-update))
            helm-map)

  (defun h/helm-fonts ()
    (interactive)
    (with-helm-buffer
      (setq line-spacing 1)
      (buffer-face-set '(:height 110))))

  (add-hook 'helm-after-initialize-hook #'h/helm-fonts)
  
  (helm-mode 1)
  (helm-autoresize-mode 1)
  (remove-hook 'helm-after-update-hook 'helm-ff-update-when-only-one-matched))

(req-package helm-swoop
  :bind ("C-." . helm-swoop))

(req-package popwin)

(defvar spacemacs-helm-display-help-buffer-regexp '("*.*Helm.*Help.**"))
;; display Helm buffer using 40% frame height
(defvar spacemacs-helm-display-buffer-regexp `("*.*helm.**"
                                               (display-buffer-in-side-window)
                                               (inhibit-same-window . t)
                                               (window-height . 0.4)))
(defvar spacemacs-display-buffer-alist nil)
(defun spacemacs//display-helm-at-bottom ()
  "Display the helm buffer at the bottom of the frame."
  ;; avoid Helm buffer being diplaye twice when user
  ;; sets this variable to some function that pop buffer to
  ;; a window. See https://github.com/syl20bnr/spacemacs/issues/1396
  (let ((display-buffer-base-action '(nil)))
    ;; backup old display-buffer-base-action
    (setq spacemacs-display-buffer-alist display-buffer-alist)
    ;; the only buffer to display is Helm, nothing else we must set this
    ;; otherwise Helm cannot reuse its own windows for copyinng/deleting
    ;; etc... because of existing popwin buffers in the alist
    (setq display-buffer-alist nil)
    (add-to-list 'display-buffer-alist spacemacs-helm-display-buffer-regexp)
    ;; this or any specialized case of Helm buffer must be added AFTER
    ;; `spacemacs-helm-display-buffer-regexp'. Otherwise,
    ;; `spacemacs-helm-display-buffer-regexp' will be used before
    ;; `spacemacs-helm-display-help-buffer-regexp' and display
    ;; configuration for normal Helm buffer is applied for helm help
    ;; buffer, making the help buffer unable to be displayed.
    (add-to-list 'display-buffer-alist spacemacs-helm-display-help-buffer-regexp)
    (popwin-mode -1)))

(defun spacemacs//restore-previous-display-config ()
  (popwin-mode 1)
  ;; we must enable popwin-mode first then restore `display-buffer-alist'
  ;; Otherwise, popwin keeps adding up its own buffers to `display-buffer-alist'
  ;; and could slow down Emacs as the list grows
  (setq display-buffer-alist spacemacs-display-buffer-alist))

(add-hook 'helm-after-initialize-hook 'spacemacs//display-helm-at-bottom)
;;  Restore popwin-mode after a Helm session finishes.
(add-hook 'helm-cleanup-hook 'spacemacs//restore-previous-display-config)
