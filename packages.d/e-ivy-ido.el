(initsplit-this-file bos (| "ido-" "smex-"))

;; (req-package ivy
;;   :diminish (ivy-mode "")
;;   :config
;;   (setq ivy-format-function 'ivy-format-function-line
;;         ivy-use-virtual-buffers t)
;;   (ivy-mode)
;;   (require 'ivy-buffer-extend))


;; (req-package counsel
;;   :demand
;;   :bind (("<menu>" . counsel-imenu))
;;   :diminish (counsel-mode "")
;;   :config
;;   (setq counsel-find-file-ignore-regexp "\\`\\.")
;;   (counsel-mode)
;;   (defadvice counsel-yank-pop (around sometimes-yank-pop (arg))
;;     (interactive "p")
;;     (if (not (memq last-command '(yank)))
;;         ad-do-it
;;       (call-interactively 'yank-pop)))
;;   (ad-activate 'counsel-yank-pop))

;; (el-get-bundle larkery/ido-match-modes.el)

(el-get-bundle larkery/ido-describe-prefix-bindings.el)
(el-get-bundle larkery/ido-grid.el)

(req-package ido
  :config
  (setq
   ido-auto-merge-delay-time 0.7
   ido-cr+-max-items 50000
   ido-create-new-buffer (quote always)
   ido-default-buffer-method (quote selected-window)
   ido-default-file-method (quote selected-window)
   ido-ignore-buffers (quote ("\\` " "*Help*" "*magit-process" "\\` *tramp"))
   ido-ignore-files
     (quote
      ("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./" "\\`\\./" "^\\.[^\\.]+"))
     ido-max-work-directory-list 100
     ido-separator nil
     ido-show-dot-for-dired t
     ido-use-virtual-buffers (quote auto)
     ido-work-directory-list-ignore-regexps (quote ("^/net/"))
     ido-save-directory-list-file (concat (my-state-dir "") "ido.last")
     )
  (ido-mode)

  (defvar my-ido-common-completion "")

  (defun my-ido-find-common-substring (items text)
    "Replace ido-find-common-substring with the optimised version computed in my-ido-set-matches-1"
    my-ido-common-completion)


  (advice-add 'ido-find-common-substring
              :override
              'my-ido-find-common-substring)

  (defun my-ido-regex (input)
    (condition-case
        error
        (cond
         ((string= "" input) nil)
         ((string= "^" input) (cons "" 0))
         ((string= "$" input) (cons "" 0))
         (t (let ((rx-list nil)
                  (count 0)
                  (first t)
                  (end-s nil))

              (when (= ?^ (aref input 0))
                (push 'bos rx-list)
                (setq input (substring input 1)))

              (when (= ?  (aref input 0))
                (unless (eq 'bos (car rx-list))
                  (push 'bos rx-list))
                (push " " rx-list)
                (incf count)
                (setq input (substring input 1)))

              (when (and (not (zerop (length input)))
                         (= ?$ (aref input (- (length input) 1))))
                (setq end-s t)
                (setq input (substring input 0 (- (length input) 1))))

              (let ((parts (split-string input " " t " ")))
                (dolist (p parts)
                  (unless first
                    (push '(1+ nonl) rx-list))
                  (setq first nil)
                  (push (list 'group p) rx-list)
                  (incf count (length p))))

              (when end-s
                (push 'eos rx-list))

              (cons (rx-to-string
                     (nconc (list 'seq) (nreverse rx-list)))
                    count)
              )))
      (error nil)
      ))

  (defvar my-last-ido-regexp "")
  (defun my-ido-set-matches-1 (items &optional do-full)
    ;; I have no idea what do-full is for.

    ;; unlike ido-set-matches-1, this also sets my-ido-common-completion
    ;; which is the longest string that can be inserted at point

    (setq my-ido-common-completion nil)
    (let* (name
           nlen
           mi me

           common-completion-length

           (ido-text0 (if (zerop (length ido-text))
                          0 (aref ido-text 0)))

           (matches nil)
           (exact-matches nil)
           (prefix-matches nil)

           (rc (my-ido-regex ido-text))
           (re (or (car rc) (regexp-quote ido-text)))
           (count (or (cdr rc) (length ido-text)))
           (non-prefix-dot (or (not ido-enable-dot-prefix)
                               (not ido-process-ignore-lists)
                               ido-enable-prefix
                               (= (length ido-text) 0))))

      (dolist (item items)
        (setq name (ido-name item)
              mi nil
              me nil)
        (setq nlen (length name))
        (when (and (or non-prefix-dot
                       (= ido-text0 (aref name 0) ?.)
                       (and (= ?. ido-text0)
                            (/= (aref name 0) ?.)))
                   (setq mi (string-match re name)))
          (setq me (match-end 0))

          (cond
           ((= count nlen)
            (setq exact-matches (cons item exact-matches)
                  my-ido-common-completion ""
                  common-completion-length 0)) ;; clear the completion since this is full-length
           ((zerop mi)
            (setq prefix-matches (cons item prefix-matches)))
           (t (setq matches (cons item matches))))

          (if my-ido-common-completion
              ;; if the ccl is already zero, we don't bother
              (unless (zerop common-completion-length)
                ;; if the current match goes to the end
                ;; we know that there can be no more completion
                (if (= me nlen)
                    (setq my-ido-common-completion ""
                          common-completion-length 0)
                  ;; otherwise, scan the rest of item
                  ;; until either we get to the end
                  ;; or a mismatch
                  (setq common-completion-length
                          (loop for i from 0 to (min (- common-completion-length 1)
                                                     (- nlen me 1))

                                until (/= (aref my-ido-common-completion i)
                                          (aref name (+ i me)))

                                finally return i))
                  ))
            ;; this is the case where it's the first item
            ;; so the completion is all the rest.
            (progn (setq my-ido-common-completion (substring name me))
                   (setq common-completion-length (length my-ido-common-completion)))
            )))

      ;; set the completion string
      ;; for some reason that has the input string
      ;; added to the start.
      (setq my-ido-common-completion
            (if my-ido-common-completion
                (concat ido-text (substring my-ido-common-completion 0 common-completion-length))
              ""))

      (setq matches (nconc exact-matches prefix-matches matches))
      (setq my-last-ido-regexp re)
      (delete-consecutive-dups matches t)))


  (advice-add 'ido-set-matches-1 :override #'my-ido-set-matches-1)

  (add-hook 'ido-setup-hook
            (lambda () (define-key ido-completion-map " " #'self-insert-command))))

(req-package ido-exit-target)

(req-package ido-grid
  :config
  (setq ido-grid-indent 0)
  (ido-grid-enable)

  (defun my-ido-grid-re-hack (o &rest args)
    (let ((ido-enable-regexp t)
          (ido-text my-last-ido-regexp))
      (apply o args)))

  (advice-add 'ido-grid--grid-ensure-visible :around #'my-ido-grid-re-hack))

(req-package ido-ubiquitous
  :config
  (ido-ubiquitous-mode)
  (ido-everywhere 1))

(req-package ido-at-point
  :config
  (ido-at-point-mode 1))

(req-package ido-describe-prefix-bindings
  :demand
  :bind ("M-X" . ido-describe-mode-bindings)
  :config
  (require 's)
  (ido-describe-prefix-bindings-mode 1))

(req-package smex
  :commands smex
  :require (ido ido-ubiquitous)
  :bind (("M-x" . smex))
  :config
  (setq smex-save-file (concat (my-state-dir "") "smex")
        smex-flex-matching nil)

  (defun h/advise-smex-bindings ()
    (define-key ido-completion-map (kbd "<tab>") 'ido-complete))

  (advice-add 'smex-prepare-ido-bindings :after #'h/advise-smex-bindings))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ido-grid-rows 6)
 '(ido-grid-special-commands
   (quote
    ((describe-prefix-bindings 8 1 nil 0)
     (cr-recentf 10 1 nil 0))))
 '(ido-grid-start-small t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ido-first-match ((t (:inverse-video t :weight bold))))
 '(ido-grid-match-1 ((t (:inherit match :slant italic))))
 '(ido-grid-match-2 ((t (:inherit ido-grid-match-1))))
 '(ido-grid-match-3 ((t (:inherit ido-grid-match-1))))
 '(ido-only-match ((t (:inherit ido-first-match))))
 '(ido-subdir ((t (:foreground "deep sky blue" :weight bold)))))
