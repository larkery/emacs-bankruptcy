(with-eval-after-load 'eshell
  (defvar eshell-dired-buffer nil)
  (defvar eshell-dired-following nil)
  (make-variable-buffer-local 'eshell-dired-buffer)

  (defun eshell/de ()
    (interactive)
    (let ((here (current-buffer))
          (here-window (get-buffer-window))
          (dir default-directory)
          (window (and eshell-dired-buffer
                       (get-buffer-window eshell-dired-buffer))))

      (let ((dired-buffer (if window
                              (save-excursion
                                (select-window window t)
                                (kill-buffer)
                                (dired dir))
                            (save-excursion
                              (select-window (split-window) t)
                              (dired dir)))))
        (with-current-buffer dired-buffer (setq eshell-dired-buffer here))
        (with-current-buffer here (setq eshell-dired-buffer dired-buffer))
        (select-window here-window))))

  (defun eshell-dired-follow (&rest stuff)
    (when eshell-dired-buffer
      (cond
       ((eq major-mode 'dired-mode)
        ;; Doesn't work because dired makes a new buffer when you switch
        ;; things, or at least wipes its buffer locals. We must instead
        ;; have a minor mode which serves the same purpose.
        (let ((new-directory default-directory)
              (eshell-dired-following t))
          (with-current-buffer eshell-dired-buffer
            (eshell/cd new-directory))))
       ((and (not eshell-dired-following)
             (eq major-mode 'eshell-mode)) (eshell/de)))
      ))

  (add-hook 'eshell-directory-change-hook #'eshell-dired-follow)

  (defun fish-path (path max-len)
    "Return a potentially trimmed-down version of the directory PATH, replacing
parent directories with their initial characters to try to get the character
length of PATH (sans directory slashes) down to MAX-LEN."
    (let* ((components (split-string (abbreviate-file-name path) "/"))
           (len (+ (1- (length components))
                   (reduce '+ components :key 'length)))
           (str ""))
      (while (and (> len max-len)
                  (cdr components))
        (setq str (concat str
                          (cond ((= 0 (length (car components))) "/")
                                ((= 1 (length (car components)))
                                 (concat (car components) "/"))
                                (t
                                 (if (string= "."
                                              (string (elt (car components) 0)))
                                     (concat (substring (car components) 0 2)
                                             "/")
                                   (string (elt (car components) 0) ?/)))))
              len (- len (1- (length (car components))))
              components (cdr components)))
      (concat str (reduce (lambda (a b) (concat a "/" b)) components))))

  (defun my-eshell-prompt-function ()

    (concat
     (let ((p (eshell/pwd)))
       (if (file-remote-p p)
           (let* ((parts (tramp-dissect-file-name p))
                  (path (tramp-file-name-localname parts))
                  (host (tramp-file-name-host parts)))
             (concat host ":" (fish-path (if (string= path "") "/" path) 40)))
         (fish-path p 40)))

     (if (= (user-uid) 0) " # " " $ ")))


  (add-hook 'eshell-mode-hook
            (lambda ()
              (define-key eshell-mode-map (kbd "<tab>")
                (lambda () (interactive) (pcomplete-std-complete)))))
  )
