(initsplit-this-file bos "uniquify-")

;; When uniquifying a bunch of files if some of them are remote
;; then add the hostname in as the first path component.
;; (with-eval-after-load 'uniquify
;;   (defvar uniquify-with-hosts-first nil)

;;   (defun set-uniquify-with-hosts-first (o conf-list old-name depth)
;;     (let ((uniquify-with-hosts-first
;;            (< 1 (length
;;                  (delete-duplicates
;;                   (loop for c in conf-list
;;                         collect (file-remote-p (uniquify-item-dirname c))
;;                         ))))))
;;       (apply o (list conf-list old-name depth))))

;;   (advice-add 'uniquify-rationalize-conflicting-sublist :around #'set-uniquify-with-hosts-first)
;;   (advice-remove 'uniquify-rationalize-conflicting-sublist  #'set-uniquify-with-hosts-first)
;;   (defun uniquify-get-proposed-name (base dirname &optional depth)
;;     (unless depth (setq depth uniquify-min-dir-content))
;;     (cl-assert (equal (directory-file-name dirname) dirname)) ;No trailing slash.

;;     ;; Distinguish directories by adding extra separator.
;;     (if (and uniquify-trailing-separator-p
;;              (file-directory-p (expand-file-name base dirname))
;;              (not (string-equal base "")))
;;         (cond ((eq uniquify-buffer-name-style 'forward)
;;                (setq base (file-name-as-directory base)))
;;               ;; (setq base (concat base "/")))
;;               ((eq uniquify-buffer-name-style 'reverse)
;;                (setq base (concat (or uniquify-separator "\\") base)))))

;;     (let ((extra-string nil)
;;           (n depth))
;;       (while (and (> n 0) dirname)
;;         (let ((file (file-name-nondirectory dirname)))
;;           (when (setq dirname (file-name-directory dirname))
;;             (setq dirname (directory-file-name dirname)))
;;           (setq n (1- n))
;;           (push (cond
;;                  ((zerop (length file))
;;                   (prog1 (or (file-remote-p dirname) "") (setq dirname nil)))
;;                  ;; this kind-of works but we get host/file and local-dir/file instead.
;;                  ;; we could say "is any of them remote"
;;                  ;; and then add system name first in that case
;;                  ((and (= n 0) uniquify-with-hosts-first)
;;                   (car (split-string (or (and dirname
;;                                               (file-remote-p dirname)
;;                                               (tramp-file-name-host (tramp-dissect-file-name dirname)))
;;                                          (system-name)) "\\.")))
;;                  (t file))
;;                 extra-string)))
;;       (when (zerop n)
;;         (if (and dirname extra-string
;;                  (equal dirname (file-name-directory dirname)))
;;             ;; We're just before the root.  Let's add the leading / already.
;;             ;; With "/a/b"+"/c/d/b" this leads to "/a/b" and "d/b" but with
;;             ;; "/a/b"+"/c/a/b" this leads to "/a/b" and "a/b".
;;             (push "" extra-string))
;;         (setq uniquify-possibly-resolvable t))

;;       (cond
;;        ((null extra-string) base)
;;        ((string-equal base "") ;Happens for dired buffers on the root directory.
;;         (mapconcat 'identity extra-string "/"))
;;        ((eq uniquify-buffer-name-style 'reverse)
;;         (mapconcat 'identity
;;                    (cons base (nreverse extra-string))
;;                    (or uniquify-separator "\\")))
;;        ((eq uniquify-buffer-name-style 'forward)
;;         (mapconcat 'identity (nconc extra-string (list base))
;;                    "/"))
;;        ((eq uniquify-buffer-name-style 'post-forward)
;;         (concat base (or uniquify-separator "|")
;;                 (mapconcat 'identity extra-string "/")))
;;        ((eq uniquify-buffer-name-style 'post-forward-angle-brackets)
;;         (concat base "<" (mapconcat 'identity extra-string "/")
;;                 ">"))
;;        (t (error "Bad value for uniquify-buffer-name-style: %s"
;;                  uniquify-buffer-name-style))))))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(uniquify-min-dir-content 0))
