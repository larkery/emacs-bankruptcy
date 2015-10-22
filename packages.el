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
  (sml/apply-theme 'respectful))

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
  :require (notmuch)
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

  (add-hook 'org-agenda-finalize-hook 'org-agenda-to-appt)
  (run-at-time "24:01" 3600 'org-agenda-to-appt)

  (bind-key "C-M-i" #'completion-at-point org-mode-map)

  (require 'org-contacts)
  (require 'org-notmuch)

  ;; hack things which use org-clock-into-drawer wrongly
  (defun h/drawer-hack (o &rest a)
    (let ((org-clock-into-drawer nil))
      (apply o a)))

  (defun h/space-on-clock-string (o &rest args) (concat " " (apply o args)))
  (advice-add 'org-clock-get-clock-string :around #'h/space-on-clock-string)
  (advice-add 'org-clock-jump-to-current-clock :around #'h/drawer-hack))

(req-package org-journal
  :require org
  :config (setq org-journal-dir "~/org/journal/"))

(req-package adaptive-wrap
  :commands adaptive-wrap-prefix-mode
  :init
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

  (setf blink-matching-paren nil)
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


(req-package ibuffer
  :config
  (setq ibuffer-filter-group-name-face 'outline-3))

(req-package ibuffer-vc
  :commands ibuffer-vc-set-filter-groups-by-vc-root
  :init
  (setq ibuffer-formats
        '((mark modified read-only vc-status-mini " "
                (name 18 18 :left :elide)
                " "
                (size 9 -1 :right)
                " "
                (mode 16 16 :left :elide)
                " "
                (vc-status 16 16 :left)
                " "
                filename-and-process)))


  (add-hook 'ibuffer-hook
    (lambda ()
      (ibuffer-vc-set-filter-groups-by-vc-root)
      (unless (eq ibuffer-sorting-mode 'alphabetic)
        (ibuffer-do-sort-by-alphabetic)))))

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

(add-hook 'prog-mode-hook #'eldoc-mode)
(which-function-mode 1)

(add-hook 'java-mode-hook 'subword-mode)
(add-hook 'java-mode-hook
          #'(lambda nil (c-set-style "stroustrup")))

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
  :commands rainbow-delimiters-mode
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(req-package saveplace
  :init
  (setq-default save-place t)
  (setq save-place-file (h/ed "state/saved-places")))

(req-package hippie-exp
  :init
  (bind-key* "M-?" (make-hippie-expand-function '(try-expand-line) t)))

(req-package recentf
  :init
  (setq recentf-save-file (h/ed "state/recentf")
        recentf-exclude '(".ido.last")
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

;; for some reason, this ido stuff ends up a mess unless I do it in this precise order.

(add-hook 'h/final-setup-hook
          (lambda ()
            (setq ido-create-new-buffer 'always
                  ido-use-filename-at-point 'guess
                  ido-save-directory-list-file (h/ed "state/ido.last")
                  ido-use-faces t
                  resize-mini-windows t)

            (ido-mode 1)
            (ido-everywhere 1)
            (ido-ubiquitous-mode 1)
            (ido-grid-mode 1)
            (ido-match-modes-toggle 1)

            (defun h/ido-keys ()
              (define-key ido-completion-map (kbd "M-a") 'ido-toggle-ignore)
              (define-key ido-completion-map (kbd "C-a") 'beginning-of-line))

            (add-hook 'ido-setup-hook #'h/ido-keys)

            (defun h/recentf-ido-find-file ()
              "Find a recent file using Ido."
              (interactive)
              (let* ((ido-grid-mode-max-columns 1)
                     (ido-grid-mode-max-rows 30)
                     (file (completing-read "Choose recent file: " recentf-list nil t)))
                 (when file
                   (find-file file))))

            (bind-key "C-x C-r" #'h/recentf-ido-find-file)
            ))

(req-package ido)

(el-get-bundle larkery/ido-grid-mode.el)
(el-get-bundle larkery/ido-match-modes.el)

(req-package ido-grid-mode
  :loader el-get)

(req-package ido-match-modes
  :loader el-get
  :require (ido ido-ubiquitous))

(req-package smex
  :commands smex
  :require ido
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

(req-package swiper :bind ("C-." . swiper))

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
  :require ido
  :config
  (ido-at-point-mode t))

(req-package imenu
  :init
  (setq imenu-auto-rescan t))

(req-package highlight-symbol
  :commands highlight-symbol-mode highlight-symbol-nav-mode
  :init
  (add-hook 'prog-mode-hook #'highlight-symbol-mode)
  (add-hook 'prog-mode-hook #'highlight-symbol-nav-mode))

(req-package dired-imenu
  :config
  (require 'dired-imenu))

(req-package dired+
  :commands dired
  :config
  (diredp-toggle-find-file-reuse-dir 1))

(req-package dired-subtree
  :commands dired-subtree-toggle
  :init
  (bind-key "i" #'dired-subtree-toggle dired-mode-map))

(req-package dired-k)

(add-hook 'dired-load-hook (lambda () (require 'dired-x)))

(req-package browse-kill-ring+
  :init
  (require 'browse-kill-ring+))

(req-package ws-butler
  :diminish ""
  :commands ws-butler-global-mode
  :init
  (ws-butler-global-mode))

(winner-mode 1)

(req-package smartrep
  :config
  (smartrep-define-key
      global-map
      "C-x"
    '(("o" . other-window)
      ("O" . ace-window)
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
  :init
  (add-hook 'js2-mode-hook 'ac-js2-mode))

;; (req-package pretty-symbols
;;   :diminish
;;   :config
;;   (add-hook 'prog-mode-hook #'pretty-symbols-mode))

(req-package yasnippet
  :diminish (yas-minor-mode . " ⇥")
  :config
  (yas-global-mode))

;; (req-package popwin
;;   :config
;;   (require 'popwin)
;;   (popwin-mode 0)
;;   (bind-key "C-\\" popwin:keymap)
;;   (setq
;;    popwin:popup-window-height 0.25
;;    popwin:special-display-config
;;         '((help-mode :noselect nil :stick t)
;;           ("*Occur*" :noselect nil :stick t)
;;           ("*Ido Completions*" :noselect t)
;;           ("*Completions*" :noselect t)
;;           ("*compilation*" :noselect t)
;;           (" *undo-tree*" :width 0.3 :position right)
;;           )))

(req-package anzu
  :diminish ""
  :config
  (global-anzu-mode +1))

;; (req-package origami
;;   :require smartrep
;;   :config
;;   (global-origami-mode t)

;;   (smartrep-define-key
;;       origami-mode-map
;;       "C-<tab>"

;;     '(("C-<tab>" . origami-recursively-toggle-node)
;;       ("<tab>" . origami-recursively-toggle-node)
;;       ("n" . origami-show-only-node)
;;       ("w" . origami-open-all-nodes)))
;;   )

;; completing read on describe-prefix-bindings
(defun first-line (string)
  (car (split-string string "\n")))

(defun describe-prefix-bindings (&rest args)
  (interactive)
  (let* ((buffer (current-buffer))
         (key (this-command-keys))
         (prefix (make-string (1- (length key)) 0))
         bindings
         choices
         the-command
         (longest-binding 0)
         (longest-command 0)
         (pos 0)
         re)

    (dotimes (i (length prefix))
      (aset prefix i (aref key i)))

    (setf re
          (rx-to-string `(sequence
                          bol

                          (group ,(key-description prefix)
                                 (one-or-more
                                  (optional space)
                                  (group (one-or-more (not space)))))

                          "  "
                          (maximal-match (zero-or-more space))
                          (group (one-or-more (not space)))
                          eol)))

    (save-excursion
      (with-current-buffer (get-buffer-create " *bindings*")
        (erase-buffer)
        (describe-buffer-bindings buffer prefix)
        ;; we want to iterate over the lines and think about them
        (save-match-data
          (goto-char 1)
          (search-forward "Bindings Starting")

          (while (search-forward-regexp re nil t 1)
            (ignore-errors
              (let* ((keyname (match-string 1))
                     (command-name (match-string 3))
                     (command (intern command-name)))
                (when (commandp command)
                  (setf longest-command (max longest-command (length command-name))
                        longest-binding (max longest-binding (length keyname)))
                  (push (list keyname command
                              (first-line (or (documentation command)
                                              "undocumented"))) bindings)))))

          (insert (format "\nregex: %s\n" re))
          (insert (format "\nkey:%s\n" (length prefix)))
          ;; now we have the list of bindings, we can present them with completing read
          ;; might be good to pad them to fit first

          (dolist (x bindings)
            (let ((key (nth 0 x))
                  (command (nth 1 x))
                  (description (nth 2 x)))
              (add-face-text-property 0 (length key) 'font-lock-keyword-face nil key)
              (push
               (cons
                (concat
                 (s-pad-right longest-binding " " key)
                 "  "
                 (s-pad-right longest-command " " (symbol-name command))
                 "  "
                 description)
                command)
               choices)))

          (let* ((result
                  (let ((ido-grid-mode-max-columns 1)
                        (ido-grid-mode-max-rows 25))
                   (completing-read "Prefix commands: "
                                    choices
                                    nil
                                    t)))
                 (command (cdr (assoc result choices))))
            (setf the-command command)))))

    (when the-command (call-interactively the-command))))

(defmath as (e units)
  (math-convert-units e units))

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

(req-package back-button
  :diminish " ☜"
  :require smartrep
  :config
  (back-button-mode 1)
  (bind-key "M-<f8>" #'back-button-local-backward back-button-mode-map) ;lack of smartrep :/
  (bind-key "M-<f9>" #'back-button-local-forward back-button-mode-map))


(req-package git-timemachine
  :commands git-timemachine)


;; (defvar h/looking-for-package nil)

;; (defun h/found-tag-hook ()
;;   (beginning-of-buffer)
;;   (when h/looking-for-package

;;     (let ((pkg (thing-at-point 'line t)))
;;       (switch-to-buffer h/looking-for-package)
;;       (setf h/looking-for-package nil)
;;       (save-excursion
;;         (let ((sym (thing-at-point 'symbol t)))
;;           (beginning-of-buffer)
;;           (forward-line)
;;           (forward-line)
;;           (insert "import "
;;                   (substring pkg (length "package ") (- (length pkg) 2)) "." sym ";\n")
;;           ))
;;       )
;;     ))


;; (add-hook 'ggtags-find-tag-hook #'h/found-tag-hook)
;; (h/found-tag-hook)


;; (defun h/importify ()
;;   (interactive)
;;   (let ((sym (thing-at-point 'symbol t)))
;;     (setf h/looking-for-package (current-buffer))
;;     (ggtags-find-tag sym)))

;; (bind-key "C-," #'h/importify java-mode-map)

(req-package zzz-to-char
  :bind ("M-z" . zzz-to-char))

(req-package comment-dwim-2
  :bind ("M-;" . comment-dwim-2))

;; not sure what to do about the super-secret information
(req-package znc)

(req-package iy-go-to-char
  :bind (("C-c s" . iy-go-up-to-char)
         ("C-c r" . iy-go-up-to-char-backward)))
