(req-package tao-theme)
(req-package fish-mode)

(req-package magit
  :commands magit
  :bind ("C-c g" . magit-status)
  :config
  (setq magit-last-seen-setup-instructions "1.4.0"))

(req-package lispy)

(req-package avy
  :bind
  (("M-g g" . avy-goto-line)
   ("M-g M-g" . avy-goto-line)
   ("M-g w" . avy-goto-word-1)
   ("M-g M-w" . avy-goto-word-0)
   ("M-g M-c" . avy-goto-char)
   ))

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
  :require (;helm
            notmuch)
  :demand
  :bind
  (("C-c a" . org-agenda)
   ("C-c l" . org-store-link)
   ("C-c c" . org-capture))
  
  :config
  (add-hook 'org-mode-hook
            (lambda ()
              (visual-line-mode 1)
              (setq mode-name "OM")
              (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t)
              ))

  (defun h/load-org-agenda-files-recursively (dir)
    (unless (file-directory-p dir) (error "Not a directory `%s'" dir))

    (unless (equal (directory-files dir nil org-agenda-file-regexp t) nil)
      (add-to-list 'org-agenda-files dir))
    
    (dolist (file (directory-files dir nil nil t))
      (unless (member file '("." ".."))
        (let ((file (concat dir "/" file)))
          (when (file-directory-p file)
            (h/load-org-agenda-files-recursively file))))))

  (h/load-org-agenda-files-recursively org-directory)
  
  (add-hook 'org-agenda-finalize-hook 'org-agenda-to-appt)
  (run-at-time "24:01" 3600 'org-agenda-to-appt)

  (bind-key "C-M-i" #'completion-at-point org-mode-map)

  (require 'org-contacts)
  (require 'org-notmuch)

  ;; hack things which use org-clock-into-drawer wrongly
  (defun h/drawer-hack (o &rest a)
    (let ((org-clock-into-drawer nil))
      (apply o a)))

  (advice-add 'org-clock-jump-to-current-clock :around #'h/drawer-hack)
  
  )

(req-package org-journal
  :require org
  :config (setq org-journal-dir "~/org/journal/"))

(req-package adaptive-wrap
  :config
  (add-hook 'text-mode-hook #'adaptive-wrap-prefix-mode))

(req-package smartparens
  :config
  (require 'smartparens-config)
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
         ("C->" . mc/mark-next-like-this)
         ;("M-[" . (lambda () (interactive) (mc/create-fake-cursor-at-point)))
         ;("M-]" . (lambda () (interactive) (mc/maybe-multiple-cursors-mode)))
         )
  :config
  (setq mc/list-file (h/ed "state/mc-list-file.el"))

  (require 'mc-hide-unmatched-lines-mode)
  (bind-key "C-;" #'mc-hide-unmatched-lines-mode mc/keymap))

(req-package expand-region
  :bind ("C-#" . er/expand-region))

(req-package projectile
  :commands projectile-project-root projectile-find-file-dwim
  :bind (
         ("M-g P" . projectile-switch-project)
         ("M-g f" . projectile-find-file-dwim)
         ("M-g F" . projectile-find-file-in-known-projects)
         )
  :diminish (projectile-mode . " p")
  :config
  (setq projectile-completion-system 'ido)
  (projectile-global-mode t)
  (projectile-register-project-type 'gradle '("build.gradle") "./gradlew build" "./gradlew test")
  )

(req-package hydra
  :bind (("M-g p" . hydra-projectile/body)
         ("M-g P" . hydra-projectile-other-window/body))
  :config
  (defhydra hydra-projectile-other-window (:color teal)
    "projectile-other-window"
    ("f"  projectile-find-file-other-window        "file")
    ("g"  projectile-find-file-dwim-other-window   "file dwim")
    ("d"  projectile-find-dir-other-window         "dir")
    ("b"  projectile-switch-to-buffer-other-window "buffer")
    ("q"  nil                                      "cancel" :color blue))

  (defhydra hydra-projectile (:color teal
                                     :hint nil)
    "
%(projectile-project-root)
Proj:   _p_roject |  _c_ompile     |  _R_emove     |   _i_buf    |  _b_uffer     |  _K_ill all
File:   _f_ind    |  _r_ecentf     |  _d_irectory  |  root _D_ir |  _v_c
Search: _a_g      |  _g_tags upd   |  find _T_ag   |  _o_ccur    |  _G_rep
"
    ("a"   projectile-ag)
    ("b"   projectile-switch-to-buffer)
    ("d"   projectile-find-dir)
    ("D"   projectile-dired)
    ("f"   projectile-find-file-dwim)
    ("g"   ggtags-update-tags)
    ("T"   ggtags-find-tag-dwim)
    ("G"   projectile-grep)
    ("R"   projectile-remove-current-project-from-known-projects)
    ("i"   projectile-ibuffer)
    ("K"   projectile-kill-buffers)
    ("o"   projectile-multi-occur)
    ("p"   projectile-switch-project)
    ("r"   projectile-recentf)
    ("c"   projectile-compile-project)
    ("v"   projectile-vc)
    ("`"   hydra-projectile-other-window/body "other window")
    ("q"   nil "cancel" :color blue)
    ("C-g" nil "cancel" :color blue))
  (bind-key "C-5" #'hydra-window/body)
  )

(req-package ggtags
  :init
  (add-hook 'java-mode-hook 'ggtags-mode))

(add-hook 'java-mode-hook 'subword-mode)
(add-hook 'java-mode-hook
          #'(lambda nil (c-set-style "stroustrup")))

(req-package smartscan
  :config
  (add-hook 'prog-mode-hook #'smartscan-mode)
  (bind-key "M-p" #'smartscan-symbol-go-backward prog-mode-map)
  (bind-key "M-n" #'smartscan-symbol-go-forward prog-mode-map))

;; something about this breaks other maps if we let it happen here.
;; maybe it is a bad interaction with guide-key mode or something
;; anyway this is modified from undo-tree.el to avoid that problem
(defvar undo-tree-map nil
  "Keymap used in undo-tree-mode.")

(unless undo-tree-map
  (let ((map (make-sparse-keymap)))
    ;; remap `undo' and `undo-only' to `undo-tree-undo'
    (define-key map [remap undo] 'undo-tree-undo)
    (define-key map [remap undo-only] 'undo-tree-undo)
    ;; bind standard undo bindings (since these match redo counterparts)
    (define-key map (kbd "C-/") 'undo-tree-undo)
    (define-key map "\C-_" 'undo-tree-undo)
    ;; redo doesn't exist normally, so define our own keybindings
    (define-key map (kbd "C-?") 'undo-tree-redo)
    (define-key map (kbd "M-_") 'undo-tree-redo)
    ;; just in case something has defined `redo'...
    (define-key map [remap redo] 'undo-tree-redo)
    ;; we use "C-x u" for the undo-tree visualizer
    (define-key map (kbd "\C-x u") 'undo-tree-visualize)
    ;; bind register commands
    ;; set keymap
    (setq undo-tree-map map)))

(req-package undo-tree
  :diminish undo-tree-mode
  :init
  (global-undo-tree-mode)
  (global-set-key (kbd "C-z") 'undo)
  (defalias 'redo 'undo-tree-redo)
  (global-set-key (kbd "C-S-z") 'redo)
  (global-set-key (kbd "C-M-z") 'undo-tree-visualize))

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

(req-package dired+ :commands dired)

(req-package recentf
  :config  
  (setq recentf-save-file (h/ed "state/recentf")
        recentf-max-menu-items 1000
        recentf-max-saved-items 1000)
  (recentf-mode 1))

(req-package wgrep
  :init
  (require 'wgrep))

(req-package cider)

(req-package ag)

(req-package lacarte
  :bind ("M-`" . lacarte-execute-menu-command))

(add-hook 'dired-load-hook (lambda () (require 'dired-x)))

(req-package ido
  :config
  (setq ido-enable-flex-matching nil
        ido-everywhere t
        ido-create-new-buffer 'always
        ido-use-filename-at-point 'guess
        ido-save-directory-list-file (h/ed "state/ido.last")
        ido-use-faces t)

  (ido-mode 1)
  (ido-everywhere 1)

  (defun h/recentf-ido-find-file ()
    "Find a recent file using Ido."
    (interactive)
    (let ((file (completing-read "Choose recent file: " recentf-list nil t)))
      (when file
        (find-file file))))

  ;; it would be nice to uniquify these names?

  (bind-key "C-x C-r" #'h/recentf-ido-find-file)

  (defun h/ido-keys ()
    (define-key ido-completion-map (kbd "M-a") 'ido-toggle-ignore)
    (define-key ido-completion-map (kbd "C-a") 'beginning-of-line))

  (add-hook 'ido-setup-hook #'h/ido-keys))

(req-package ido-match-modes
  :config
  (ido-match-modes-toggle 1))

(req-package
  ido-ubiquitous
  :config
  (ido-ubiquitous-mode 1))

(req-package smex
  :commands smex
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands))
  :config
  (setq smex-save-file (h/ed "state/smex-items"))

  ;; redefine bindings because smex alters tab
  (require 'smex)
  (defun smex-prepare-ido-bindings ()
    (define-key ido-completion-map (kbd "C-h f") 'smex-describe-function)
    (define-key ido-completion-map (kbd "C-h w") 'smex-where-is)
    (define-key ido-completion-map (kbd "M-.") 'smex-find-function)
    (define-key ido-completion-map (kbd "C-a") 'move-beginning-of-line)))

(setq resize-mini-windows t)

(req-package ido-vertical-mode
  :config

  (ido-vertical-mode t))

(req-package swiper
  :bind ("C-." . swiper))


(req-package visual-regexp-steroids
  :require pcre2el
  :bind (("C-c r" . vr/replace)
         ("C-c q" . vr/query-replace)
         ("C-c m" . vr/mc-mark)
         ("C-r" . vr/isearch-backward)
         ("C-s" . vr/isearch-forward))
  :config
  (setq vr/engine 'pcre2el))

(req-package
  ido-at-point
  :config
  (ido-at-point-mode t))

(req-package dired-narrow
  :config
  (bind-key "C-n" #'dired-narrow dired-mode-map))

(req-package dired-sort-menu)

(req-package dired-imenu
  :config
  (require 'dired-imenu))

(req-package discover
  :config
  (global-discover-mode))

(req-package browse-kill-ring+
  :config
  (require 'browse-kill-ring+))

;; (req-package guide-key
;;   :diminish guide-key-mode
;;   :init
;;   (setq guide-key/idle-delay 2
;;         guide-key/recursive-key-sequence-flag t
;;         guide-key/popup-window-position 'bottom
;;         guide-key/guide-key-sequence    '("C-h" "C-x" "C-c" "C-z" "M-g" "M-s")
;;         guide-key/highlight-command-regexp
;;         '("bookmark"
;;           ("dired" . "brown")
;;           ("compile" . "pink")
;;           ("window" . "green")
;;           ("file" . "red")
;;           ("buffer" . "cyan")
;;           ("register" . "purple")
;;           ("project" . "orange")
;;           ))

;;   (defun guide-key/my-hook-function-for-org-mode ()
;;     (guide-key/add-local-guide-key-sequence "C-c C-x")
;;     (guide-key/add-local-highlight-command-regexp '("org-" . "cyan"))
;;     (guide-key/add-local-highlight-command-regexp '("clock" . "hot pink"))
;;     (guide-key/add-local-highlight-command-regexp '("table" . "orange"))
;;     (guide-key/add-local-highlight-command-regexp '("archive" . "grey")))

;;   (add-hook 'org-mode-hook 'guide-key/my-hook-function-for-org-mode)

;;   (guide-key-mode 1))

(req-package ws-butler
  :config
  (ws-butler-global-mode))

(winner-mode 1)

(req-package smartrep
  :config
  (smartrep-define-key
      global-map
      "C-x"
    '(("o" . other-window)
      ("0" . delete-window)
      ("1" . delete-other-windows)
      ("3" . split-window-horizontally)
      ("2" . split-window-vertically)
      ("B" . previous-buffer)
      ))

  (smartrep-define-key
      winner-mode-map
      "C-c"
    '(("<left>" . winner-undo))))

(defun idomenu--guess-default (index-alist symbol)
  "Guess a default choice from the given symbol."
  (when symbol
    (catch 'found
      (let ((regex (concat "\\_<" (regexp-quote symbol) "\\_>")))
        (dolist (item index-alist)
          (if (string-match regex (car item)) (throw 'found (car item))))))))

(defun h/idomenu ()
  (interactive)

  (let ((index-alist (cdr (imenu--make-index-alist))))
    (if (equal index-alist '(nil))
        (message "No imenu tags in buffer")
      (let* ((flat-list (h/flat-ido-menu "" index-alist))
             (names (mapcar 'car flat-list))
             (default (idomenu--guess-default flat-list (thing-at-point 'symbol)))
             (chosen (completing-read "goto " names nil t nil nil default))
             (choice (assoc chosen flat-list)))
        (imenu choice)))))

(defun h/flat-ido-menu (prefix the-alist)
  (mapcan
   (lambda (x)
     (if (consp x)
         (if (imenu--subalist-p x)
             (h/flat-ido-menu (concat prefix (car x) "/")
                              (cdr x))
           (list (cons (concat prefix (car x))
                       (cdr x))))))
   the-alist))

(bind-key "<menu>" #'h/idomenu)

(req-package js2-mode
  :mode "\\.js\\'")

(req-package ac-js2
  :commands ac-js2-mode
  :require js2-mode
  :diminish "js"
  :config
  (add-hook 'js2-mode-hook 'ac-js2-mode))

(req-package pretty-symbols
  :config
  (add-hook 'prog-mode-hook #'pretty-symbols-mode))

(req-package yasnippet
  :config
  (yas-global-mode))

(req-package popwin
  :config
  (require 'popwin)
  (popwin-mode 1)
  (bind-key "C-\\" popwin:keymap)
  (setq
   popwin:popup-window-height 0.4
   popwin:special-display-config
        '((help-mode :noselect nil :stick t)
          ("*Occur*" :noselect nil :stick t)
          ("*Ido Completions*" :noselect t)
          ("*Completions*" :noselect t)
          ))
  )

(req-package anzu
  :config
  :diminish
  (global-anzu-mode +1))

(req-package origami
  :bind
  :config
  (global-origami-mode t)

  (let ((the-hydra (defhydra hydra-fold
              (:body-pre (call-interactively #'origami-recursively-toggle-node))
              "fold"
              ("<tab>" origami-recursively-toggle-node)
              ("C-<tab>" origami-recursively-toggle-node)
              ("n" origami-show-only-node)
              ("w" origami-open-all-nodes)
              ("A" origami-close-all-nodes))))
    (bind-key "C-<tab>" the-hydra origami-mode-map)))
