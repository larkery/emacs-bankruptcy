(require 'ivy)

(defvar mml-ivy-history ())
(defvar mml-temp-files ())
(make-variable-buffer-local 'mml-temp-files)

(defun mml-ivy-cleanup ()
  (dolist (fi mml-temp-files)
    (message "Remove temporary zip file: %s" fi)
    (delete-file fi))
  (setq mml-temp-files nil))

(defun mml-ivy-select-file (file)
  (if (file-directory-p file)
      (if (y-or-n-p (format "Attach directory %s?" file))
          (let* ((file (directory-file-name file))
                 (temporary-file-directory (file-name-directory file))
                 (zip-file (make-temp-file (file-name-nondirectory file) nil ".zip")))
            (shell-command
             (format "zip -r - %s > %s &"
                     (shell-quote-argument file)
                     (shell-quote-argument zip-file)))
            (mml-attach-file zip-file
                             (mm-default-file-encoding zip-file)
                             "A zipped directory"
                             "attachment")
            (push zip-file mml-temp-files)
            (add-hook 'message-sent-hook #'mml-ivy-cleanup))

        (when (eq this-command 'ivy-done)
          (mml-ivy-attach-files)))

    (let* ((type (mml-minibuffer-read-type file))
           (desc (mml-minibuffer-read-description))
           (disp (mml-minibuffer-read-disposition type "attachment" file)))
      (mml-attach-file file desc disp))
    ))

(defun mml-ivy-attach-files ()
  (interactive)
  (ivy-read "Find file: " 'read-file-name-internal
            :matcher #'counsel--find-file-matcher
            :initial-input (car mml-ivy-history)
            :action #'mml-ivy-select-file
            :preselect (when counsel-find-file-at-point
                         (require 'ffap)
                         (let ((f (ffap-guesser)))
                           (when (and f (not (ffap-url-p f)))
                             (expand-file-name f))))
            :require-match t
            :history 'mml-ivy-history
            :keymap counsel-find-file-map
            :caller 'mml-ivy-attach-files))

(provide 'ivy-attach-files)
