(req-package dim
  :config
  (dim-major-names
   '((emacs-lisp-mode    "EL")
     (lisp-mode          "CL")
     (Info-mode          "I")
     (help-mode          "H")
     ))

  (dim-minor-names
   '((isearch-mode       " 🔎")
     (whitespace-mode    " _"  whitespace)
     (paredit-mode       " ()" paredit)
     (eldoc-mode         ""    eldoc)))
  )
