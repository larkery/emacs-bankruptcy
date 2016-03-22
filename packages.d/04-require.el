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

;;;; dired-k puts VC information and colours into dired.
(req-package dired-k
  :commands dired-k dired-k-no-revert
  :init
  (defun h/dired-k-no-revert-except-tramp ()
    (unless (file-remote-p default-directory)
      (dired-k-no-revert)))

  (add-hook 'dired-after-readin-hook #'dired-k-no-revert t)
  (setq dired-k-style 'git       ;; show VC status on the left
        dired-k-human-readable t ;; my dired flags include -h for human-readable sizes
        ))

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

  (bind-keys
   :keymap smartparens-mode-map

   ("C-c (" . (lambda () (interactive) (sp-wrap-with-pair "(")))
   ("C-c [" . (lambda () (interactive) (sp-wrap-with-pair "[")))
   ("C-c {" . (lambda () (interactive) (sp-wrap-with-pair "{")))

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
  :bind ("C-c g" . magit-status)
  :config
  (setq magit-last-seen-setup-instructions "1.4.0"))

(req-package git-timemachine
  :require magit
  :bind ("C-c G" . git-timemachine)
  :commands git-timemachine)

(req-package diff-hl
  :config
  (global-diff-hl-mode))

;;; hydras

(req-package hydra
  :commands
  hydra-sp/body
  hydra-projectile-start-body
  hydra-dired/body
  hydra-misc/body

  :init
  (setq projectile-switch-project-action 'hydra-projectile-start-body)
  (bind-key "f" 'hydra-dired/body dired-mode-map)
  (bind-key "C-~" 'hydra-sp/body smartparens-mode-map)
  (bind-key "C-#" 'hydra-misc/body)

  :config

  (defhydra hydra-misc (:exit t :hint nil) "
   org: _a_genda   | _o_rg hls  | _c_apture | _t_ask | _n_otify | _O_rg bs
   run: _P_ackages | _p_rojects | _d_ired   |
   cmd: _C-#_ sel  |"
    ("a" org-agenda)
    ("o" org-goto-agenda)
    ("O" org-iswitchb)
    ("c" org-capture)
    ("t" org-clock-goto)
    ("n" h/appt-notify-now)
    ("p" hydra-projectile-start-body)
    ("P" package-list-packages)
    ("d" (dired default-directory))
    ("C-#" mark-whole-buffer))

  (defhydra hydra-sp (:exit t) "smartparens"
    (")" sp-splice-sexp)

    ("|" sp-split-sexp)
    ("+" sp-join-sexp)
    (";" h/comment-sexp)

    ("<left>" sp-convolute-sexp)
    ("<up>" sp-splice-sexp-killing-around))


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
          (call-interactively #'projectile-find-file)))
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
    (setf hydra-projectile-default-directory
          (and (projectile-project-p) (projectile-project-root)))
    (call-interactively #'hydra-projectile/body))

  (defun hydra-cwheel/body ()
    (interactive)
    (defhydra hydra-cwheel (:foreign-keys run)
      "cwheel"
      ("w"    cwheel-lighten "lighter")
      ("s"  cwheel-darken "darker")
      ("a"  cwheel-hue-up "hue up")
      ("d" cwheel-hue-down "hue down")
      ("q"       cwheel-saturate "saturate")
      ("e"       cwheel-desaturate "desaturate")
      ("ESC" (message "bye") :exit t)
      )

    (call-interactively #'hydra-cwheel/body))


  (defun hydra-dired/body ()
    (interactive)
    (require 'dired-filter)
    (defhydra hydra-dired ()
      "filter"
      ("n" dired-filter-by-name "name")
      ("e" dired-filter-by-extension "ext")
      ("-" dired-filter-negate "negate")
      ("r" dired-filter-by-regexp "regex")
      ("f" dired-filter-pop "pop")
      ("|" dired-filter-or "or")
      ("d" dired-filter-by-directory "dirs")
      ("o" dired-filter-by-omit "omit")
      ("." dired-filter-by-dot-files "dots"))
    (call-interactively 'hydra-dired/body))
  )

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
  :bind (("M-<F10>" . #'menu-bar-open)
         ("<F10>" . lacarte-execute-menu-command)))

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
              (ess-execute-screen-options t))))

;;;; clojure

(req-package cider :pin melpa-stable)
(req-package clojure-mode :pin melpa-stable)

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

(req-package elpy
  :require jedi
  :commands elpy-enable
  :init
  (defun h/elpy-enable ()
    (elpy-enable)
    (remove-hook python-mode-hook #'h/elpy-enable))
  (add-hook python-mode-hook #'h/elpy-enable))

(req-package auto-virtualenv
  :config
  (add-hook 'python-mode-hook 'auto-virtualenv-set-virtualenv)
  (add-hook 'projectile-after-switch-project-hook 'auto-virtualenv-set-virtualenv))

;;;; geiser (scheme)
(req-package geiser)

;;; browse-kill-ring (M-y shows kill ring)

(req-package browse-kill-ring+
  :init
  (require 'browse-kill-ring+))

;;; org-mode

(req-package org-agenda-property)

(req-package graphviz-dot-mode
  :commands graphviz-dot-mode
  :require org)

(req-package appt
  :config
  (require 'notifications)

  (defun h/appt-notify (mins _ msg)
    (let ((mins (if (listp mins) mins (list mins)))
          (msg (if (listp msg) msg (list msg))))
      (cl-mapcar
       (lambda (mins msg)
         (let ((soon (<= (string-to-number mins) 10))
               (now (zerop (string-to-number mins))))
           (notifications-notify
            :body msg
            :urgency (if soon 'critical 'normal)
            :timeout (if now 0 -1)
            :title (if soon
                       "NOW" (format "In %s min" mins)))))
       mins msg)))

  (defun h/appt-notify-now ()
    (interactive)
    (let ((appt-display-interval 1)) (appt-check)))

  (setq appt-message-warning-time 60
        appt-display-mode-line t
        appt-disp-window-function #'h/appt-notify
        appt-delete-window-function (lambda ())
        appt-display-interval 10
        appt-display-format 'window)

  (appt-activate t))

(req-package password-server
  :commands
  password-server-mode)

(req-package org
                                        ;:pin "manual"

  :bind (("C-c a" . org-agenda)
         ("H-a" . org-agenda)
         ("C-c l" . org-store-link)
         ("C-c c" . org-capture)
         ("C-c O" . org-iswitchb)
         ("C-c o" . org-goto-agenda)
         ("C-c t" . org-clock-goto))

  :config

  (defun org-goto-agenda ()
    (interactive "")
    (let* ((org-refile-targets `((org-agenda-files . (:maxlevel . ,org-goto-max-level))))
           (org-refile-use-outline-path t)
           (org-refile-target-verify-function nil)
           (interface org-goto-interface)
           (org-goto-start-pos (point))
           (selected-point (setq *goto* (org-refile-get-location "Goto" nil nil t))))

      (when selected-point
        (set-mark (point))
        (let ((filename (nth 0 (cdr selected-point)))
              (position (nth 2 (cdr selected-point))))
          (find-file filename)
          (goto-char position)
          (org-reveal)))))

  (require 'appt)
  (org-clock-persistence-insinuate)

  (set-mode-name org-mode "o")

  (add-hook 'org-mode-hook
            (lambda ()
              (visual-line-mode 1)
              (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t)))

  (add-hook 'org-agenda-finalize-hook 'org-agenda-to-appt)
  (run-at-time "24:01" 3600 'org-agenda-to-appt)

  (bind-key "C-M-i" #'completion-at-point org-mode-map)
  (bind-key "C-#" nil org-mode-map)
  (bind-key "C-M-<return>"
            (lambda () (interactive)
              (org-insert-heading-respect-content)
              (org-metaright))
            org-mode-map)


  (require 'org-contacts)
  (require 'org-notmuch)

  ;; hack things which use org-clock-into-drawer wrongly
  (defun h/advise-clock-hack (o &rest a)
    (let ((org-clock-into-drawer nil))
      (apply o a)))

  (defun h/advise-clock-string (o &rest args) (concat " " (apply o args)))
  (advice-add 'org-clock-get-clock-string :around #'h/advise-clock-string)
  (advice-add 'org-clock-jump-to-current-clock :around #'h/advise-clock-hack))

(req-package org-journal
  :require org
  :config (setq org-journal-dir "~/notes/journal/"))

(bind-key "<f6>"
          (lambda ()
            (interactive)
            (call-interactively #'org-journal-new-entry)
            (org-agenda nil "n")
            (call-interactively #'other-window)))

(req-package org-caldav
  :commands org-caldav-sync
  :init
  (setq org-caldav-calendars
        '((:url
           "https://lrkry.com:1080/users/"
           :calendar-id
           "tom.hinton@cse.org.uk/calendar"
           :caldav-uuid-extension
           ".EML"
           :files
           ("~/notes/calendar/cse.org")
           :inbox
           "~/notes/calendar/cse-in.org")

          (:url
           "http://horde.lrkry.com/rpc.php/calendars/tom/"
           :calendar-id
           "calendar~Ytc0GVEQhRpkeUZSVkj_zw1"
           :files
           ("~/notes/calendar/horde.org")
           :inbox
           "~/notes/calendar/horde-in.org"
           :caldav-uuid-extension
           ".ics")

          ))
  )

;;; mail

(req-package notmuch
  :commands notmuch h/notmuch/goto-inbox notmuch-mua-new-mail

  :bind (("C-c i" . h/notmuch/goto-inbox)
         ("H-i" . h/notmuch/goto-inbox)
         ("C-c m" . notmuch-mua-new-mail)
         ("H-m" . notmuch-mua-new-mail))

  :config

  (require 'notmuch-calendar)
  (require 'notmuch-extras)

  (defun h/notmuch/show-only-unread ()
    "In a notmuch show view, collapse all the read messages"
    (interactive "")
    (notmuch-show-mapc
     (lambda ()
       (notmuch-show-message-visible
        (notmuch-show-get-message-properties)
        (member "unread" (notmuch-show-get-tags)))
       )))

  (defun h/notmuch/show-next-unread ()
    "in notmuch show, goto the next unread message"
    (interactive "")
    (let (r)
      (while (and (setq r (notmuch-show-goto-message-next))
                  (not (member "unread" (notmuch-show-get-tags))))))
    (recenter 1))


  (defun h/notmuch/goto-inbox ()
    "convenience to go to the inbbox search"
    (interactive)
    (if (string-equal (system-name) "turnpike.cse.org.uk")
        (notmuch-search "tag:inbox AND path:cse/**")
      (notmuch-search "tag:inbox AND path:fm/**")))

  (defun h/notmuch/flip-tags (&rest tags)
    "Given some tags, add those which are missing and remove those which are present"
    (notmuch-search-tag
     (let ((existing-tags (notmuch-search-get-tags)) (amendments nil))
       (dolist (tag tags)
         (push
          (concat
           (if (member tag existing-tags) "-" "+")
           tag)
          amendments))
       amendments)
     ))
  
  (defmacro h/notmuch-toggler (tag)
    "Define a command to toggle the given tags"
    `(lambda ()
       (interactive)
       (h/notmuch/flip-tags ,tag)
       (notmuch-search-next-thread)))

  (defun h/notmuch/sleep ()
    "Tag a particular message as asleep for the next 4 days"
    (interactive)
    (if (member "asleep" (notmuch-search-get-tags))
        (notmuch-search-tag (loop
                             for tag in (notmuch-search-get-tags)
                             if (string-prefix-p "asleep" tag)
                             collect (concat "-" tag)))

      (notmuch-search-tag (list "-inbox"
                                "+asleep"
                                (concat "+asleep-until-"
                                        (format-time-string
                                         "%Y-%m-%d"
                                         (time-add (current-time)
                                                   (days-to-time 4))))))))
  
  (set-mode-name notmuch-search "nm-search")
  (set-mode-name notmuch-show "nm-show")
  (set-mode-name notmuch-message-mode "mail")

  ;;(bind-key "C" #'notmuch-reply-to-calendar notmuch-show-mode-map)
  (bind-key "u" #'h/notmuch/show-next-unread notmuch-show-mode-map)
  (bind-key "U" #'h/notmuch/show-only-unread notmuch-show-mode-map)

  (bind-key "." (h/notmuch-toggler "flagged") notmuch-search-mode-map)
  (bind-key "d" (h/notmuch-toggler "deleted") notmuch-search-mode-map)
  (bind-key "u" (h/notmuch-toggler "unread") notmuch-search-mode-map)
  (bind-key "," #'h/notmuch/sleep notmuch-search-mode-map)
  (bind-key "g" 'notmuch-refresh-this-buffer notmuch-search-mode-map)

  (bind-key
   "U"
   (lambda () (interactive) (notmuch-search-filter "tag:unread"))
   notmuch-search-mode-map)

  (bind-key
   "S"
   (lambda () (interactive) (notmuch-search-filter "tag:flagged"))
   notmuch-search-mode-map)

  ;; other message stuff

  (setf user-mail-address "tom.hinton@cse.org.uk"

        message-auto-save-directory "~/temp/messages/"
        message-fill-column nil
        message-header-setup-hook '(notmuch-fcc-header-setup)
        message-kill-buffer-on-exit t
        message-send-mail-function 'message-send-mail-with-sendmail
        message-sendmail-envelope-from 'header
        message-signature nil

        mm-inline-text-html-with-images t
        mm-inlined-types '("image/.*"
                           "text/.*"
                           "message/delivery-status"
                           "message/rfc822"
                           "message/partial"
                           "message/external-body"
                           "application/emacs-lisp"
                           "application/x-emacs-lisp"
                           "application/pgp-signature"
                           "application/x-pkcs7-signature"
                           "application/pkcs7-signature"
                           "application/x-pkcs7-mime"
                           "application/pkcs7-mime"
                           "application/pgp")
        mm-sign-option 'guided
        mm-text-html-renderer 'w3m
        mml2015-encrypt-to-self t

        ;; notmuch configuration
        notmuch-archive-tags (quote ("-inbox" "-unread"))
        notmuch-crypto-process-mime t
        notmuch-fcc-dirs (quote
                          (("tom\\.hinton@cse\\.org\\.uk" . "cse/Sent Items")
                           ("larkery\\.com" . "fm/Sent Items")))
        notmuch-hello-sections '(notmuch-hello-insert-search
                                 notmuch-hello-insert-alltags
                                 notmuch-hello-insert-inbox
                                 notmuch-hello-insert-saved-searches)

        notmuch-mua-cite-function 'message-cite-original-without-signature

        notmuch-saved-searches '((:name "all mail" :query "*" :key "a")
                                 (:name "all inbox" :query "tag:inbox" :key "i")
                                 (:name "work inbox" :query "tag:inbox AND path:cse/**" :key "w")
                                 (:name "unread" :query "tag:unread" :key "u")
                                 (:name "flagged" :query "tag:flagged" :key "f")
                                 (:name "sent" :query "tag:sent" :key "t")
                                 (:name "personal inbox" :query "tag:inbox and path:fm/**" :key "p")
                                 (:name "jira" :query "from:jira@cseresearch.atlassian.net" :key "j" :count-query "J"))

        notmuch-search-line-faces '(("unread" :weight bold)
                                    ("flagged" :foreground "deep sky blue"))

        notmuch-search-oldest-first nil

        notmuch-show-hook '(notmuch-show-turn-on-visual-line-mode goto-address-mode h/hack-file-links)

        notmuch-show-indent-messages-width 1

        notmuch-tag-formats '(("unread"
                               (propertize tag
                                           (quote face)
                                           (quote
                                            (:foreground "red"))))
                              ("flagged"
                               (notmuch-tag-format-image-data tag
                                                              (notmuch-tag-star-icon))
                               (propertize tag
                                           (quote face)
                                           (quote
                                            (:foreground "orange")))))

        notmuch-wash-original-regexp "^\\(--+ ?[oO]riginal [mM]essage ?--+\\)\\|\\(____+\\)$"
        notmuch-wash-signature-lines-max 30
        notmuch-wash-signature-regexp (rx
                                       bol

                                       (or
                                        (seq (* nonl) "not the intended recipient" (* nonl))
                                        (seq "The original of this email was scanned for viruses" (* nonl))
                                        (seq "__" (* "_"))
                                        (seq "****" (* "*"))
                                        (seq "--" (** 0 5 "-") (* " ")))

                                       eol)

        ;; citation stuff
        message-cite-style 'message-cite-style-gmail
        message-cite-function (quote message-cite-original-without-signature)
        message-citation-line-function (quote message-insert-formatted-citation-line)
        message-cite-reply-position (quote above)
        message-yank-prefix "> "
        message-cite-prefix-regexp "[[:space:]]*>[ >]*"
        message-yank-cited-prefix ">"
        message-yank-empty-prefix ""
        message-citation-line-format "
-----------------------
On %a, %b %d %Y, %N wrote:
"))

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

;;; restclient

(req-package restclient)

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
                 )))))
  )
;;; diminish

(req-package diminish
  :config
  (diminish 'isearch-mode " →")
  (diminish 'adaptive-wrap-prefix-mode "")
  (diminish 'visual-line-mode " ⏎")
  (diminish 'abbrev-mode "")
  (diminish 'mml-mode "")
  )

;;; ace-window
(req-package ace-window
  :bind ("C-x o" . ace-window))

;;; elfeed

(req-package elfeed
  :commands elfeed
  :bind ("C-c f" . elfeed))

;;; eno

(req-package eno
  :bind (("M-g w" . eno-word-goto))
  :config
  (eno-set-all-letter-str " sdfjkla;weioqpruvncmghxz,./")
  (eno-set-same-finger-list '("qaz" "wsx" "edc" "rfvg" "ujmhn" "ik," "ol." "p;/"))
  )

;;; rainbow mode

(req-package rainbow-mode)

;;; polymode
;;;; r-markdown

(req-package markdown-mode)

(req-package polymode
  :commands poly-markdown+r-mode
  :mode ("\\.[Rr]md\\'" . poly-markdown+r-mode))

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
(req-package punpun-theme
  :init
  (load-theme 'punpun-light t)
  (load-theme 'adjustments t))

;;; i3 stuffs
(when t
  (el-get-bundle vava/i3-emacs)

  (require 'i3)
  (require 'i3-integration)
  (i3-advise-visible-frame-list-on))


;;; keyfreq

(req-package keyfreq
  :config
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))

;;; winner
(req-package winner
  :defer nil
  :bind ("<f5>" . winner-undo)
  :config
  (winner-mode 1))

;;; multi-line
(req-package multi-line)

;;; end
