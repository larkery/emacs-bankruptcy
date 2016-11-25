(initsplit-this-file bos (| "multi-term-" "term-"))

(req-package multi-term
  :bind (("C-c C-m" . multi-term-here))

  :commands multi-term multi-term-dedicated-toggle multi-term-here

  :config

  (defun term-suspend ()
    (interactive)
    (term-send-raw-string "\C-z"))

  (bind-key "C-z" 'term-suspend term-raw-map)

  (defun multi-term-tramp (path)
    (if (file-remote-p path)
        (let* ((parts (tramp-dissect-file-name path))
               (user (tramp-file-name-user parts))
               (method (tramp-file-name-method parts))
               (host (tramp-file-name-host parts))
               (path (tramp-file-name-localname parts))

               (multi-term-program "ssh")
               (multi-term-program-switches (if user (format "%s@%s" user host)
                                              host)))
          (with-current-buffer (multi-term)
            (term-send-raw-string (format "cd %s\n" (shell-quote-argument path)))
            (current-buffer)))
      (let ((default-directory path))
        (multi-term))))

  (defun multi-term-here ()
    (interactive)

    (let* ((target-directory (expand-file-name default-directory))
           (existing-term (cl-loop for buf being the buffers
                                   if (with-current-buffer buf
                                        (and (eq major-mode 'term-mode)
                                             (string= (expand-file-name default-directory) target-directory)))
                                   return buf)))
      (if existing-term
          (pop-to-buffer existing-term)
        (if (= 1 (length (window-list)))
            (progn (split-window-sensibly)
                   (multi-term-tramp target-directory))
          (progn (other-window 1)
                 (multi-term-tramp target-directory)))))
    (goto-char (- (point-max) 1)))

  (defun term-handle-ansi-terminal-messages-fix (&rest blah)
    (when (string-match-p (rx bos "/:/") default-directory)
      (setq default-directory (substring default-directory 2)))
    (rename-buffer
          (format "%s<%s>" multi-term-buffer-name default-directory) t))

  (advice-add 'term-handle-ansi-terminal-messages :after
              'term-handle-ansi-terminal-messages-fix)

  (defun multi-term-quick-frame ()
    (set-frame-parameter nil 'quick t)
    (multi-term))

  (defun multi-term-close-window ()
    (when (eq major-mode 'term-mode)
      (let ((the-buffer (current-buffer)))
        (while (let ((buf-win (get-buffer-window the-buffer t)))
                 (cond
                    ((not buf-win) nil)
                    ((frame-parameter (window-frame buf-win) 'quick)
                     (delete-window-or-frame buf-win)
                     t)
                    ((> (length (window-list (window-frame buf-win))) 1)
                     (delete-window buf-win)
                     t)))))))

  (add-hook 'kill-buffer-hook #'multi-term-close-window t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(multi-term-switch-after-close nil)
 '(term-unbind-key-list ("C-x" "C-c" "C-h" "C-y" "<ESC>")))
