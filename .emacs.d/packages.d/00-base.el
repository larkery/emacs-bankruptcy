;;; Minimal chrome - no scroll / menu / toolbar

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; no cursor blinky
(blink-cursor-mode -1)
(setq-default cursor-type 't) ;; box cursor
(setq inhibit-startup-screen t) ;; no startup screen

;;; Macros for emacs directory

(defmacro h/ed (x) `(concat user-emacs-directory ,x))
(defmacro h/sd (x) `(concat user-emacs-directory "state/" ,x))

;;; Allow loading from my site-lisp dir

(push (h/ed "site-lisp") load-path)
(push (h/ed "site-lisp") custom-theme-load-path)

;;; Load my theme

(load-theme 'plain t)

;;; Misc settings which are quite basic

;; eldoc mode for these

(setq load-prefer-newer         t
      gc-cons-threshold         50000000
      history-length            1000
      history-delete-duplicates t
      echo-keystrokes           0.2
      scroll-conservatively     10
      set-mark-command-repeat-pop t
      frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))
        (:eval
         (progn
           (x-change-window-property "CWD" (format "%s" default-directory) (window-frame) "STRING" 8 t)
           "")
         )))

;; Make various files go in the state/ dir

(defvar pcache-directory
  (let ((dir (h/sd "pcache/")))
    (make-directory dir t)
    dir))

(let ((backup-directory (h/sd "backups/")))
  (make-directory backup-directory t)

  (setq
    auto-save-list-file-prefix (concat backup-directory "auto-save-list-")
    backup-directory-alist `((".*" . ,backup-directory))
    tramp-backup-directory-alist `((".*" . ,backup-directory))
    auto-save-file-name-transforms `((".*" ,backup-directory t))))

;; Makes yes / no questions into y/n ones - dangerous
(defalias 'yes-or-no-p 'y-or-n-p)

;; linux-specific - open urls with xdg
(setq browse-url-generic-program "xdg-open")
(setq browse-url-browser-function 'browse-url-generic)
(put 'erase-buffer 'disabled nil)


;;; mode line

(defun mode-line-pad-right (rhs)
  "Return empty space using FACE and leaving RESERVE space on the right."
  (let* ((the-rhs (format-mode-line rhs))
         (reserve (length the-rhs)))
    (when (and window-system (eq 'right (get-scroll-bar-mode)))
      (setq reserve (- reserve 3)))

    (list
     (propertize " "
                 'display `((space :align-to (- (+ right right-fringe right-margin) ,reserve)))
                 )
     rhs)))

(defvar mode-line-file-map
  (make-sparse-keymap))

(defvar projectile-mode-line-menu
  (make-sparse-keymap))

(define-key projectile-mode-line-menu
  [mode-line mouse-1]
  #'projectile-dired
  )

(define-key mode-line-file-map
  [mode-line mouse-1]
  (lambda () (interactive)
    (popup-menu
     (remove-if-not #'identity
                    `(,(buffer-name)
                      ;; produce a menu of parent directories

                      ,(symbol-name major-mode)
                      ,@(mapcar
                         (lambda (x) (vector (buffer-name x)
                                             (eval `(lambda () (interactive) (switch-to-buffer ,(buffer-name x))))
                                             t))

                         (remove-if-not (lambda (x) (equal major-mode (buffer-local-value 'major-mode x)))
                                        (buffer-list)))
                      ,(when (buffer-file-name)
                         `("Files"
                           ["sudo-edit" sudo-edit t]

                           ,@(when (buffer-file-name)
                               (let ((result nil)
                                     (h (directory-file-name (file-name-directory (buffer-file-name)))))
                                 (while h
                                   (push (lexical-let ((h h)) (vector h (lambda () (interactive) (dired h)) t))
                                         result)
                                   (setq h
                                         (unless (equal "/" h)
                                           (directory-file-name (file-name-directory h)))))
                                 result)))
                         )
                      ))
     )))

(defun mode-line-clickable (text handlers)
  (propertize
   text
   'mouse-face 'mode-line-highlight
   'local-map (let ((m (make-sparse-keymap)))
                (dolist (h handlers m)
                  (define-key m (vector 'mode-line (car h)) (cadr h))))))

(setq-default
 mode-line-format
 `(,(mode-line-clickable
     "%4l"
     `((mouse-1 ,(lambda () (interactive)
                   (call-interactively #'linum-mode)
                   (call-interactively #'hl-line-mode)))
       (mouse-3 goto-line)
       (mouse-4 previous-line)
       (mouse-5 next-line)
       ))

   (:eval
    (when (or (< (point-min) (window-start))
              (> (point-max) (window-end)))
      (concat " ["
              (format ,(mode-line-clickable "%3d%%%%"
                                            '((mouse-4 scroll-down-command)
                                              (mouse-5 scroll-up-command)))
                      (/ (* 100 (- (point) (point-min)))
                         (- (point-max) (point-min))))
              "]"
              )))

   " "

   (:eval (propertize
           (if buffer-read-only "❌" "✓")
           'face
           (if (buffer-modified-p) 'font-lock-warning-face 'font-lock-type-face)
           'help-echo
           (concat (if (buffer-modified-p) "" "un")
                   "modified, "
                   (if buffer-read-only "r/o" "r/w"))
           ))
   " "


   (:eval (propertize "%b"
                      'face 'font-lock-keyword-face
                      'help-echo (buffer-file-name)
                      'local-map mode-line-file-map
                      'mouse-face 'mode-line-highlight
                      ))

   (:eval (if (and (buffer-file-name) (file-remote-p (buffer-file-name)))
              (let ((parts (tramp-dissect-file-name (buffer-file-name))))
                (concat " " (propertize (concat (tramp-file-name-user parts) "@" (tramp-file-name-host parts))
                                        'face 'mode-line-emphasis)))
            ))

   (vc-mode vc-mode)

   ""
   (:eval
    (mode-line-pad-right
     (list " "
           ;; (when (ignore-errors (projectile-project-root))
           ;;   (concat
           ;;    (propertize (projectile-project-name)
           ;;                'mouse-face 'mode-line-highlight
           ;;                'local-map projectile-mode-line-menu)

           ;;    " "))
      mode-line-modes
      global-mode-string "  ")
     ))

   )
 )