(initsplit-this-file bos "god-")

(req-package god-mode
  :commands god-local-mode god-mode-isearch-activate
  :bind ("<escape>" . god-local-mode)
  :init
  (define-key isearch-mode-map (kbd "<escape>") 'god-mode-isearch-activate)
  :config
  (require 'god-mode-isearch)
  (define-key god-mode-isearch-map (kbd "<escape>") 'god-mode-isearch-disable)

  (define-key god-local-mode-map (kbd ".") 'repeat)
;;  (define-key god-local-mode-map (kbd "i") 'god-local-mode)
  (add-to-list 'god-exempt-major-modes 'notmuch-search-mode)
  (add-to-list 'god-exempt-major-modes 'notmuch-show-mode)

  (defvar god-cursor-face-remapping nil)
  (make-variable-buffer-local 'god-cursor-face-remapping)

  (defun god-cursor ()
    (if god-local-mode
        (progn
          (push (face-remap-add-relative
                 'mode-line
                 :background "orangered4" :box "red" :foreground "white")
                god-cursor-face-remapping)
          (setq cursor-type 'bar))

      (progn (dolist (mapping god-cursor-face-remapping)
               (face-remap-remove-relative mapping))
             (setq god-cursor-face-remapping nil)
             (setq cursor-type t))))

  (add-hook 'god-mode-enabled-hook #'god-cursor)
  (add-hook 'god-mode-disabled-hook #'god-cursor))

(req-package key-seq
  :config
  (key-seq-define-global "jd" 'dired-ffap)
  (key-seq-define-global "jw" 'other-window)
  (key-seq-define-global "jf" 'find-file)
  (key-seq-define-global "jb" 'ivy-switch-buffer)
  (key-seq-define-global "js" 'save-buffer)
  (key-seq-define-global "jx" 'split-window-below)
  (key-seq-define-global "jz" 'delete-other-windows)
  (key-seq-define-global "jc" 'split-window-right)
  (key-seq-define-global "jv" 'delete-window)
  (key-seq-define-global "jg" 'magit-status)
  (key-seq-define-global "jj" 'god-local-mode)

  (key-seq-define-global ",."  'copy-to-register)
  (key-seq-define-global ".," 'insert-register)

  (with-eval-after-load 'god-mode
    (key-seq-define god-local-mode-map  "gg"
                    (lambda () (interactive) (setq unread-command-events (listify-key-sequence "G")))))
  (key-chord-mode 1))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(god-mod-alist (quote ((nil . "C-") ("g" . "M-") ("G" . "C-M-")))))
