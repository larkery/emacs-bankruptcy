;;; password-server.el --- supply passwords

;;; Code:

(defvar password-server-password-files
  '("~/.passwords/personal.org.gpg"
    "~/.passwords/work.org.gpg"))

(defun password-server-lock ()
  ;; save if unsaved, and kill if open
  (dolist (f password-server-password-files)
    (let ((b (find-buffer-visiting f)))
      (when b
        (with-current-buffer b
          (save-buffer)
          (kill-buffer)
          )
        ))))


(defun password-server-assoc-passwords ()
  (let (results)
    (dolist (f password-server-password-files results)
      (with-current-buffer (find-file-noselect f)
        (goto-char (point-min))
        (setq results
              (nconc results
                     (org-element-map (org-element-parse-buffer 'headline)
                         'headline

                       (lambda (x)
                         (let ((url (org-element-property :URL x))
                               (user (org-element-property :USERNAME x))
                               (pass (org-element-property :PASSWORD x)))
                           (when (or url user pass)
                             (cons
                              (concat (file-name-nondirectory (file-name-sans-extension f))
                                      (mapconcat
                                       (lambda (q) (org-element-property :title q))
                                       (reverse (org-element-lineage x nil t))
                                       "/"
                                       ))
                              `(:USERNAME ,user :PASSWORD ,pass :URL ,url)
                              )))
                         )))))
      )))

(defun password-server-do (prompt key cb)
  (lexical-let ((key key) (cb cb))
   (password-server-dmenu
    prompt
    (remove-if-not
     (lambda (x) (plist-get (cdr x) key))
     (password-server-assoc-passwords))
    (lambda (sel entry)
      (let ((value (plist-get (cdr entry) key)))
        (if value
            (funcall cb value)
          (message (format "no %s for %s" key ))))))))

(defun password-server-generate (&optional length)
  (let ((pwd (shell-command-to-string (format "pwgen %d 1" (or length 15)))))
    (substring pwd 0 (- (length pwd) 1))))

(defun password-server-edit ()
  ;; jump to the definition of a password and edit it.
  )

;; TODO maybe save history list for logins
(defvar password-server-known-logins nil)

(defun password-server-insert (name login pass url where)
  (interactive
   (list (read-string "Name: ")
         (completing-read "Login: " password-server-known-logins nil nil nil
                          'password-server-known-logins)

         (let ((pwd (password-server-generate)))
           (read-string (format "Password [%s]: " pwd) nil nil pwd))
         (read-string "URL: ")
         (completing-read "Target: " password-server-password-files nil t)))

  (if (and name where)
      (let ((entry
             (concat "* " name "\n"
                     ":PROPERTIES:\n"
                     (if login (concat ":USERNAME: " login "\n"))
                     (if pass (concat ":PASSWORD: " pass "\n"))
                     (if url (concat ":URL: " url "\n"))
                     ":END:\n")))
        (with-current-buffer (find-file-noselect where)
          (save-excursion
            (goto-char (point-max))
            (insert "\n" entry))))))

(defun password-server-browse ()
  (password-server-do "type: " :URL #'browse-url))

(defun password-server-type ()
  (password-server-do "type pass: " :PASSWORD #'password-server-xdotool-type))

(defun password-server-type-user ()
  (password-server-do "type user: " :USERNAME #'password-server-xdotool-type))

(defun password-server-type-both ()
  (password-server-dmenu
   "login: "
   (remove-if-not
    (lambda (x)
      (and (plist-get (cdr x) :USERNAME)
           (plist-get (cdr x) :PASSWORD)))

    (password-server-assoc-passwords))
   (lambda (sel entry)
     (let ((user (plist-get (cdr entry) :USERNAME))
           (pass (plist-get (cdr entry) :PASSWORD)))
       (if (and user pass)
           (password-server-xdotool-type (concat user "\t" pass))
         (message (format "no %s for %s" key)))))))

(defun password-server-xdotool-type (s)
  (let ((proc (start-process "xdotool" nil "xdotool"
                             "type"
                             "--clearmodifiers"
                             "--file"
                             "-")))
    (process-send-string proc s)
    (process-send-string proc "\n")
    (process-send-eof proc)))

(defun password-server-dmenu (name input callback)
  (lexical-let ((callback callback)
                (the-buffer (get-buffer-create " *dmenu*"))
                (input input))
    (with-current-buffer the-buffer (erase-buffer))
    (let ((proc (start-process "dmenu" the-buffer "dmenu"
                               "-p" name
                               "-i"
                               "-l" "10"
                               "-fn" "Monospace-14"
                               )))
      (set-process-sentinel
       proc
       (lambda (proc evt)
         (unless (or (process-live-p proc)
                     (not (zerop (process-exit-status proc))))

           (with-current-buffer the-buffer
             (let ((dmenu-sel (buffer-substring-no-properties
                               (point-min)
                               (- (point-max) 1))))
               (funcall callback dmenu-sel (assoc dmenu-sel input)))
             ))))

      (dolist (element input)
        (process-send-string proc (concat (car element) "\n")))
      (process-send-eof proc)
      )))

(provide 'password-server)

;;; password-server.el ends here
