(req-package hydra
  :commands
  hydra-parens/body
  hydra-projectile-start-body
  handy-hash-hydra/body
  hydra-dired/body

  :init
  (bind-key "C-'" 'hydra-parens/body smartparens-mode-map)
  (setq projectile-switch-project-action 'hydra-projectile-start-body)
  (bind-key "f" 'hydra-dired/body dired-mode-map)

  (define-minor-mode handy-hash-mode
    "Handy hash!"
    :keymap (make-sparse-keymap)
    :global t
    :lighter " #")

  (defvar handy-hash-did-something 0)
  (defvar handy-hash-last-buffer nil)
  (define-key handy-hash-mode-map "#" #'handy-hash-hydra/body)

  (handy-hash-mode t)

  :config
  (defun handy-hash-hydra/body ()
    (interactive)
    (defhydra handy-hash-hydra (:hint
                                nil
                                :exit t
                                :idle
                                0.5
                                :pre
                                (progn (cl-incf handy-hash-did-something)
                                       (setq handy-hash-last-buffer (current-buffer)))
                                :post
                                (progn
                                  (unless (> handy-hash-did-something 1)
                                    (with-current-buffer handy-hash-last-buffer
                                      (insert "#")))
                                  (setq handy-hash-last-buffer nil)
                                  (setq handy-hash-did-something 0)))

      "
_K_ill _s_ave | _b_uf _f_file _r_ec | _d_ired _p_roj _g_it | _/ o_ccur _/ s_woop _/ m_swoop _/ a_g | _e_val _;_com _k_line | _i_nbox _P_kg"
      ("ESC" nil)
      ("#" (insert "#") :exit nil)
      ("K" (kill-buffer (buffer-name)))
      ("k" kill-line :exit nil)
      ("g" magit-status)
      ("b" ido-switch-buffer)
      ("s" save-buffer :exit nil)
      ("f" ido-find-file)
      ("r" h/recentf-find-file)
      ("p" hydra-projectile-start-body)
      ("d" (dired (file-name-directory (buffer-file-name))))
      ("/ o" occur)
      ("/ s" swoop)
      ("/ m" swoop-multi)
      ("/ a" ag)
      ("P" package-list-packages)
      ("e" eval-last-sexp)
      ("i" h/notmuch/goto-inbox)
      (";" comment-dwim-2 :exit nil)
      ("a" org-agenda)
      ("o" org-switchb))

    (call-interactively 'handy-hash-hydra/body))

  (defhydra hydra-parens ()
    "Parens"
    ;; not sure
    ("[" (sp-wrap-with-pair "["))
    ("(" (sp-wrap-with-pair "("))
    ("{" (sp-wrap-with-pair "{"))
    ("\"" (sp-wrap-with-pair "\""))
    ("|" sp-split-sexp "split")
    ("+" sp-join-sexp "join")
    ("t" sp-transpose-hybrid-sexp "trans")
    ("~" sp-convolute-sexp "conv")
    ("<backspace>" sp-backward-kill-sexp))

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
    (setf hydra-projectile-default-directory nil)
    (call-interactively #'hydra-projectile/body))

  (defun hydra-dired/body ()
    (interactive)
    (require 'dired-filter)
    (defhydra hydra-dired ()
      "filter"
      ("e" dired-filter-by-extension "extension")
      ("-" dired-filter-negate "negate")
      ("r" dired-filter-by-regexp "regex")
      ("f" dired-filter-pop "pop")
      ("|" dired-filter-or "or")
      ("d" dired-filter-by-directory "dirs")
      ("o" dired-filter-by-omit "omit")
      ("." dired-filter-by-dot-files "dots"))
    (call-interactively 'hydra-dired/body)))
