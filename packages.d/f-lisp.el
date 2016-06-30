(req-package cider)

(require 'paren)
(show-paren-mode 1)
(setq show-paren-delay 0
      show-paren-style 'parenthesis
      show-paren-priority 100000)

(req-package smartparens
  :commands smartparens-mode show-smartparens-mode
  :init
  (add-hook 'prog-mode-hook 'smartparens-mode)
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
  )
