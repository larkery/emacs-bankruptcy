;; -*- lexical-binding: t -*-
(initsplit-this-file bos (| "magit-" "git-timemachine-"))

(req-package magit
  :commands magit-status
  :bind (("C-c g" . magit-status))
  :init
  (setq magit-auto-revert-mode nil)
  :config
  (setq magit-auto-revert-mode t)
  (setq magit-last-seen-setup-instructions "1.4.0")
  (setq magit-completing-read-function 'ivy-completing-read)

  (defun magit-remote-switch-method (o &rest args)
    (let ((default-directory
            (or (when (file-remote-p default-directory)
                  (let ((parts (tramp-dissect-file-name default-directory)))
                    (when (string= "scp" (tramp-file-name-method parts))
                      (tramp-make-tramp-file-name
                       "ssh"
                       (tramp-file-name-user parts)
                       (tramp-file-name-host parts)
                       (tramp-file-name-localname parts)
                       (tramp-file-name-hop parts)))))
                default-directory)))
      (apply o args)))

  (advice-add 'magit-read-repository :around 'magit-remote-switch-method)
  (advice-add 'magit-status :around 'magit-remote-switch-method)
  )

(req-package git-timemachine
  :require magit
  :bind ("C-c G" . git-timemachine)
  :commands git-timemachine)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-diff-arguments (quote ("--stat" "--no-ext-diff" "--ignore-all-space")))
 '(magit-diff-use-overlays nil))
