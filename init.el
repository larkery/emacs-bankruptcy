;;; Load each thing from packages.d


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

;; (defconst elt-require-depth 0)

;; (defadvice locate-library (around leuven-locate-library activate)
;;   "Locate Emacs library named LIBRARY and report time spent."
;;   (let ((filename (ad-get-arg 0))
;;         (time-start (float-time))
;;         (prefix (concat (make-string (* 4 elt-require-depth) ? ) "    ")))
;;     (if ad-do-it
;;         (message "%sLocating library %s... located (in %.3f s)"
;;                  prefix filename
;;                  (- (float-time) time-start))
;;       (add-to-list 'elt-missing-packages filename 'append)
;;       (message "%sLocating library %s... missing (in %.3f s)"
;;                prefix filename
;;                (- (float-time) time-start)))))


;; (defadvice require (around leuven-require activate)
;;   "Leave a trace of packages being loaded."
;;   (let* ((feature (ad-get-arg 0))
;;          (prefix-already (concat (make-string (* 4 elt-require-depth) ? ) "└── "))
;;          (prefix-open    (concat (make-string (* 4 elt-require-depth) ? ) "└─► "))
;;          (prefix-close   (concat (make-string (* 4 elt-require-depth) ? ) "  ► ")))
;;     (cond ((featurep feature)
;;            (message "%s%s <from %s>... already loaded"
;;                     prefix-already feature
;;                     (ignore-errors (file-name-base load-file-name))
;;                     )
;;            (setq ad-return-value feature)) ; set the return value in the case
;;                                         ; `ad-do-it' is not called
;;           (t
;;            (let ((time-start))
;;              (ad-disable-advice 'locate-library 'around 'leuven-locate-library)
;;              (message "%s%s <from %s>... %s"
;;                       prefix-open feature
;;                       (ignore-errors (file-name-base load-file-name))
;;                       (locate-library (symbol-name feature)))
;;              (ad-activate 'locate-library)
;;              (setq time-start (float-time))
;;              (let ((elt-require-depth (1+ elt-require-depth)))
;;                ad-do-it)
;;              (message "%s%s <from %s>... loaded in %.3f s"
;;                       prefix-close feature
;;                       (ignore-errors (file-name-base load-file-name))
;;                       (- (float-time) time-start)))))))


;; (defadvice load (around leuven-load activate)
;;   "Execute a file of Lisp code named FILE and report time spent."
;;   (let ((filename (ad-get-arg 0))
;;         (time-start (float-time))
;;         (prefix-open  (concat (make-string (* 4 elt-require-depth) ? ) "└─● "))
;;         (prefix-close (concat (make-string (* 4 elt-require-depth) ? ) "  ● ")))
;;     (ad-disable-advice 'locate-library 'around 'leuven-locate-library)
;;     (message "%s%s <from %s>...%s"
;;              prefix-open filename
;;              (ignore-errors (file-name-base load-file-name))
;;              (ignore-errors
;;                (if (not (string-match-p
;;                          (concat "^" (expand-file-name filename)
;;                                  "\\.?e?l?c?")
;;                          (locate-library filename)))
;;                    (concat " " (locate-library filename))
;;                  "")))               ; don't print full file name once again!
;;     (ad-activate 'locate-library)
;;     ad-do-it
;;     (message "%s%s <from %s>... loaded in %.3f s"
;;              prefix-close filename
;;              (ignore-errors (file-name-base load-file-name))
;;              (- (float-time) time-start))))


;; wrapper around `eval-after-load' (added in GNU Emacs 24.4)
;; (defmacro with-eval-after-load (file &rest body)
;;   "Execute BODY after FILE is loaded."
;;   (declare (indent 1) (debug t))
;;   `(eval-after-load ,file
;;      '(progn
;;         (let ((time-start))
;;           (message "{{{ Running code block specific to %s..."
;;                    ,file)
;;           (setq time-start (float-time))
;;           ,@body
;;           (message "}}} Running code block specific to %s... done in %.3f s"
;;                    ,file
;;                    (- (float-time) time-start))))))

(require 'package)

(setq package-archives
      '(("melpa-unstable" . "http://melpa.org/packages/")
        ("melpa-stable" . "http://stable.melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")
        ("gnu" .  "http://elpa.gnu.org/packages/")))

(add-to-list 'package-directory-list "~/.nix-profile/share/emacs/site-lisp/elpa")

(package-initialize)

;; (byte-recompile-directory user-emacs-directory)

(dolist (f (directory-files
	    (concat user-emacs-directory
                "packages.d/") t "\\.el$"))
  (load f))
(put 'set-goal-column 'disabled nil)
