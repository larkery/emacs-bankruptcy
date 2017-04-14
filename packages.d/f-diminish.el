(req-package diminish
  :config
  (diminish 'isearch-mode " 🔎"))

;; hack major mode names

(defvar mode-name-amendments
  '( (replace "ESS [R]" "R")
     (replace "bookmark"    "→")
     (replace "buffer"      "β")
     (replace "diff"        "Δ")
     (replace "dired"       "δ")
     (replace "emacs"       "ε")
     (replace "fundamental" "Ⓕ")
     (replace "inferior"    "i")
     (replace "interaction" "i")
     (replace "interactive" "i")
     (replace "lisp"        "λ")
     (replace "menu"        "▤")
     (replace "mode"        "")
     (replace "package"     "↓")
     (replace "python"      "π")
     (replace "shell"       "sh")
     (replace "text"        "ξ")
     (replace "wdired"      "↯δ")
     (replace "notmuch" "✉")
     ))


(defun change-mode-name ()
  (when (stringp mode-name)
    (let ((new-mode-name mode-name))
      (dolist (amendment mode-name-amendments)
        (cl-case (car amendment)
          (replace
           (setq new-mode-name
                 (replace-regexp-in-string (cadr amendment) (caddr amendment)
                                           new-mode-name t)))))
      (setq mode-name new-mode-name))))

(add-hook 'after-change-major-mode-hook #'change-mode-name)
