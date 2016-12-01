(initsplit-this-file bos (| "multi-term-" "term-"))

(req-package multi-term
  :bind (("C-c C-m" . multi-term-here))

  :commands multi-term multi-term-dedicated-toggle multi-term-here multi-term-quick-frame

  :config

  (add-hook 'term-mode-hook
            (lambda ()
              (dolist (map '(term-mode-map term-raw-map))
                (bind-keys :map (eval map)
                           ("C-c C-l" . (lambda ()
                                          (interactive)
                                          (window--adjust-process-windows)
                                          ;; (call-interactively 'term-send-raw)

                                      ))
                           ("C-z" . term-send-raw)
                           ("M-DEL" . term-send-raw-meta)
                           ("M-<Backspace>" . term-send-raw-meta)))))

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

  (defun host-to-ip (host)
    (s-trim
     (shell-command-to-string (format "host -qQ %s | tail -n 1 | cut -f 3"
                                      (shell-quote-argument host)))))


  (defun same-file (f1 f2)
    "nil unless f1 and f2 are names for the same file"

    (or (string= f1 f2)
        (and (file-remote-p f1)
             (file-remote-p f2)
             ;; the only thing we'll fix here is hostname
             (let ((p1 (tramp-dissect-file-name f1))
                   (p2 (tramp-dissect-file-name f2)))
               ;; the stuff here is compare all the parts, except hostname which
               ;; we compare differently.
               ;; only for ssh and scp, because argh
               (and (member (tramp-file-name-method p1) '("ssh" "scp"))
                    (loop for fn in
                          '(tramp-file-name-hop
                            tramp-file-name-user
                            tramp-file-name-port
                            tramp-file-name-method
                            tramp-file-name-localname)
                          always (equal (funcall fn p1)
                                        (funcall fn p2)))

                    (or (string= (tramp-file-name-host p1)
                                 (tramp-file-name-host p2))
                        (string= (host-to-ip (tramp-file-name-host p1))
                                 (host-to-ip (tramp-file-name-host p2)))))
               ))))


  (defun multi-term-here ()
    (interactive)
    ;; TODO canonicalise hostname
    (let* ((target-directory (expand-file-name default-directory))
           (existing-term (cl-loop for buf being the buffers
                                   if (with-current-buffer buf
                                        (and (eq major-mode 'term-mode)
                                             (same-file (expand-file-name default-directory)
                                                        target-directory)))
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
    (let* ((dir-name
            (file-name-nondirectory
             (directory-file-name default-directory)))

           (preferred-name
            (if (file-remote-p default-directory)
                (let ((parts (tramp-dissect-file-name default-directory)))
                  (format "%s@%s [%s]"
                          (or (tramp-file-name-user parts)
                              term-ansi-at-user)
                          (or (tramp-file-name-host parts)
                              term-ansi-at-host)
                          dir-name))
              (format "[%s]" dir-name))))

      (rename-buffer
       (concat multi-term-buffer-name " " preferred-name)
       t)))


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
 '(multi-term-scroll-show-maximum-output t)
 '(multi-term-scroll-to-bottom-on-output t)
 '(multi-term-switch-after-close nil)
 '(term-scroll-show-maximum-output t)
 '(term-unbind-key-list (quote ("C-x" "C-c" "C-h" "C-y" "<ESC>"))))
