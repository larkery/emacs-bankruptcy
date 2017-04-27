(req-package god-mode
  :commands god-local-mode god-mode-isearch-activate
  :bind ("<escape>" . god-local-mode)
  :init
  (define-key isearch-mode-map (kbd "<escape>") 'god-mode-isearch-activate)
  :config
  (require 'god-mode-isearch)
  (define-key god-mode-isearch-map (kbd "<escape>") 'god-mode-isearch-disable)
  (define-key god-local-mode-map (kbd ".") 'repeat)

  (add-to-list 'god-exempt-major-modes 'notmuch-search-mode)
  (add-to-list 'god-exempt-major-modes 'notmuch-show-mode)

  (defvar god-cursor-face-remapping nil)
  (make-variable-buffer-local 'god-cursor-face-remapping)

  (defun god-cursor ()
    (if god-local-mode
        (progn
          ;; (push (face-remap-add-relative 'hl-line :background "darkcyan")
          ;;       god-cursor-face-remapping)

          (push (face-remap-add-relative 'mode-line :background "OrangeRed4" :foreground "white")
                god-cursor-face-remapping)
          (setq cursor-type 'bar)
          ;; (hl-line-mode 1)
          )

      (progn (dolist (mapping god-cursor-face-remapping)
               (face-remap-remove-relative mapping))
             (setq god-cursor-face-remapping nil)
             ;; (hl-line-mode -1)

             (setq cursor-type t))))


  (add-hook 'god-mode-enabled-hook #'god-cursor)
  (add-hook 'god-mode-disabled-hook #'god-cursor))
