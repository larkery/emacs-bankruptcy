(initsplit-this-file bos (| "clojure-" "cider-" "paren-face-" "smartparens-"))

(defvar lisp-modes-hook ())
(defun run-lisp-modes-hook () (run-hooks 'lisp-modes-hook))

(add-hook 'lisp-mode-hook 'run-lisp-modes-hook)
(add-hook 'emacs-lisp-mode-hook 'run-lisp-modes-hook)
(add-hook 'lisp-interaction-mode-hook 'run-lisp-modes-hook)

(req-package cider
  :require smartparens
  :mode (("\\(?:build\\|profile\\)\\.boot\\'" . clojure-mode)
         ("\\.cljs\\'" . clojurescript-mode)
         ("\\.cljx\\'" . clojurex-mode)
         ("\\.cljc\\'" . clojurec-mode)
         ("\\.\\(clj\\|dtm\\|edn\\)\\'" . clojure-mode))

  :config
  (add-hook 'cider-repl-mode-hook 'smartparens-mode)
  (add-hook 'cider-repl-mode-hook 'run-lisp-modes-hook)
  (add-hook 'clojure-mode-hook 'run-lisp-modes-hook))

(require 'paren)
(show-paren-mode 1)
(setq show-paren-delay 0
      show-paren-style t
      show-paren-priority 100000)

(req-package paren-face :commands paren-face-mode)
(add-hook 'lisp-modes-hook 'paren-face-mode)

(req-package smartparens
  :require flash-region
  :diminish " p"
  :commands smartparens-mode show-smartparens-mode
  :init
  (add-hook 'my-prog-mode-hook 'smartparens-mode)
  :config
  (require 'smartparens-config)

  (setq sp-highlight-pair-overlay nil
        sp-highlight-wrap-tag-overlay t
        sp-highlight-wrap-overlay t)

  ;; smartparens keymap needs some work

  (defun my-rotate-wrappers ()
    "rotate the wrappers of the current sexp through sensible choices"
    (interactive "")
    (let ((delim (plist-get (sp-get-enclosing-sexp)
                            :op
                            )))
      (pcase delim
        ("(" (sp-rewrap-sexp '("[" . "]")))
        ("[" (sp-rewrap-sexp '("{" . "}")))
        ("{" (sp-rewrap-sexp '("(" . ")")))
        ("_" my-wrap-with-\())))

  (defun my-wrap-paren ()
    (interactive)
    (sp-wrap-with-pair "(")
    )

  (defun my-comment-sexp ()
    (interactive)
    (save-excursion
      (let ((here (point)))
        (sp-forward-sexp)
        (unless (looking-at ".")
          (insert "\n"))
        (comment-or-uncomment-region here (point)))))

  (bind-keys
   :map smartparens-mode-map

   ("C-M-b" . sp-backward-sexp)
   ("C-M-f" . sp-forward-sexp)
   ("C-M-u" . sp-backward-up-sexp)
   ("C-M-d" . sp-down-sexp)

   ("C-M-k" . sp-kill-sexp)
   ("C-x C-t" . sp-transpose-hybrid-sexp)

   ("C-(" . my-wrap-paren)
   ("M-(" . my-rotate-wrappers)
   ("C-)" . move-past-close-and-reindent)
   ("C-^" . sp-splice-sexp-killing-around)

   ("C-{" . sp-slurp-hybrid-sexp)
   ("C-}" . sp-forward-barf-sexp)

   ("C-M-;" . my-comment-sexp)
   )

  (defun pulse-preceding-expression ()
    (interactive)
    (save-excursion
      (sp-backward-sexp)
      (let ((bounds (bounds-of-thing-at-point 'sexp)))
            (flash-region (car bounds) (cdr bounds)))
      (unless (pos-visible-in-window-p)
        (let ((line (thing-at-point 'line)))
          (message "%s" (substring line 0 (- (length line) 1)))))))

  (advice-add 'move-past-close-and-reindent
              :after
              'pulse-preceding-expression))
