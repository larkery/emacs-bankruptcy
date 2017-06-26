(req-package diminish
  :config
  (diminish 'isearch-mode " 🔎")
  (diminish 'orgstruct-mode " §")
  (diminish 'orgtbl-mode " 🞕")
  (diminish 'visual-line-mode " ⮱")
  (diminish 'abbrev-mode " …")

  )


;; hack major mode names

(defvar mode-name-amendments
  '( (replace "ESS [R]" "R")
     (replace "bookmark"    "bm")
     (replace "buffer"      "buf")
     (replace "dired"       "dir")
     (replace "emacs"       "e")
     (replace "fundamental" "F")
     (replace "inferior"    "i")
     (replace "interaction" "i")
     (replace "interactive" "i")
     (replace "lisp"        "λ")
     (replace "mode"        "")
     (replace "shell"       "sh")
     (replace "text"        "txt")
     (replace "wdired"      "wdir")
     (replace "notmuch" "nm")
     (replace "Message" "msg")
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
