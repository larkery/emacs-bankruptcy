(initsplit-this-file bos (| "multi-term-" "term-"))

(req-package multi-term
  :bind (("C-c C-m" . multi-term-here)
         ("C-x t" . ibuffer-multi-term))

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

  (defun ibuffer-multi-term ()
    (interactive)
    ;; select a multi-term terminal with ido
    ;; this could open ibuffer instead
    (ibuffer t "*terminals*"
             (list (cons 'used-mode 'term-mode)))

    )

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
    ;; TODO alternatively reuse an existing terminal buffer which is undisplayed.
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

;; minor patches to reduce string copying in decode
(with-eval-after-load 'term
  (defun term-emulate-terminal (proc str)
    (with-current-buffer (process-buffer proc)
      (let* ((i 0) char funny
             count       ; number of decoded chars in substring
             count-bytes ; number of bytes
             decoded-substring
             save-point save-marker old-point temp win
             (buffer-undo-list t)
             (selected (selected-window))
             last-win
             handled-ansi-message
             (str-length (length str)))
        (save-selected-window

          (let ((newstr (term-handle-ansi-terminal-messages str)))
            (unless (eq str newstr)
              (setq handled-ansi-message t
                    str newstr
                    str-length (length newstr))))

          (when (marker-buffer term-pending-delete-marker)
            ;; Delete text following term-pending-delete-marker.
            (delete-region term-pending-delete-marker (process-mark proc))
            (set-marker term-pending-delete-marker nil))

          (when (/= (point) (process-mark proc))
            (setq save-point (point-marker)))

          (setf term-vertical-motion
                (if (eq (window-buffer) (current-buffer))
                    'vertical-motion
                  'term-buffer-vertical-motion))
          (setq save-marker (copy-marker (process-mark proc)))
          (goto-char (process-mark proc))

          (save-restriction
            ;; If the buffer is in line mode, and there is a partial
            ;; input line, save the line (by narrowing to leave it
            ;; outside the restriction ) until we're done with output.
            (when (and (> (point-max) (process-mark proc))
                       (term-in-line-mode))
              (narrow-to-region (point-min) (process-mark proc)))

            (when term-log-buffer
              (princ str term-log-buffer))
            (cond ((eq term-terminal-state 4) ;; Have saved pending output.
                   (setq str (concat term-terminal-parameter str))
                   (setq term-terminal-parameter nil)
                   (setq str-length (length str))
                   (setq term-terminal-state 0)))

            (while (< i str-length)
              (setq char (aref str i))
              (cond ((< term-terminal-state 2)
                     ;; Look for prefix of regular chars
                     (setq funny
                           (string-match "[\r\n\000\007\033\t\b\032\016\017]"
                                         str i))
                     (when (not funny) (setq funny str-length))
                     (cond ((> funny i)
                            ;; Decode the string before counting
                            ;; characters, to avoid garbling of certain
                            ;; multibyte characters (bug#1006).
                            (setq decoded-substring
                                  (decode-coding-string
                                   (substring str i funny)
                                   locale-coding-system t))
                            (cond ((eq term-terminal-state 1)
                                   ;; We are in state 1, we need to wrap
                                   ;; around.  Go to the beginning of
                                   ;; the next line and switch to state
                                   ;; 0.
                                   (term-down 1 t)
                                   (term-move-columns (- (term-current-column)))
                                   (setq term-terminal-state 0)))
                            (setq count (length decoded-substring))
                            (setq temp (- (+ (term-horizontal-column) count)
                                          term-width))
                            (cond ((or term-suppress-hard-newline (<= temp 0)))
                                  ;; All count chars fit in line.
                                  ((> count temp) ;; Some chars fit.
                                   ;; This iteration, handle only what fits.
                                   (setq count (- count temp))
                                   (setq count-bytes
                                         (length
                                          (encode-coding-string
                                           (substring decoded-substring 0 count)
                                           'binary t)))
                                   (setq temp 0)
                                   (setq funny (+ count-bytes i)))
                                  ((or (not (or term-pager-count
                                                term-scroll-with-delete))
                                       (>  (term-handle-scroll 1) 0))
                                   (term-adjust-current-row-cache 1)
                                   (setq count (min count term-width))
                                   (setq count-bytes
                                         (length
                                          (encode-coding-string
                                           (substring decoded-substring 0 count)
                                           'binary t)))
                                   (setq funny (+ count-bytes i))
                                   (setq term-start-line-column
                                         term-current-column))
                                  (t ;; Doing PAGER processing.
                                   (setq count 0 funny i)
                                   (setq term-current-column nil)
                                   (setq term-start-line-column nil)))
                            (setq old-point (point))

                            ;; Insert a string, check how many columns
                            ;; we moved, then delete that many columns
                            ;; following point if not eob nor insert-mode.
                            (let ((old-column (current-column))
                                  columns pos)
                              (insert (decode-coding-string (substring str i funny) locale-coding-system t))
                              (setq term-current-column (current-column)
                                    columns (- term-current-column old-column))
                              (when (not (or (eobp) term-insert-mode))
                                (setq pos (point))
                                (term-move-columns columns)
                                (delete-region pos (point)))
                              ;; In insert mode if the current line
                              ;; has become too long it needs to be
                              ;; chopped off.
                              (when term-insert-mode
                                (setq pos (point))
                                (end-of-line)
                                (when (> (current-column) term-width)
                                  (delete-region (- (point) (- (current-column) term-width))
                                                 (point)))
                                (goto-char pos)))
                            (setq term-current-column nil)

                            (put-text-property old-point (point)
                                               'font-lock-face term-current-face)
                            ;; If the last char was written in last column,
                            ;; back up one column, but remember we did so.
                            ;; Thus we emulate xterm/vt100-style line-wrapping.
                            (cond ((eq temp 0)
                                   (term-move-columns -1)
                                   (setq term-terminal-state 1)))
                            (setq i (1- funny)))
                           ((and (setq term-terminal-state 0)
                                 (eq char ?\^I)) ; TAB (terminfo: ht)
                            (setq count (term-current-column))
                            ;; The line cannot exceed term-width. TAB at
                            ;; the end of a line should not cause wrapping.
                            (setq count (min term-width
                                             (+ count 8 (- (mod count 8)))))
                            (if (> term-width count)
                                (progn
                                  (term-move-columns
                                   (- count (term-current-column)))
                                  (setq term-current-column count))
                              (when (> term-width (term-current-column))
                                (term-move-columns
                                 (1- (- term-width (term-current-column)))))
                              (when (= term-width (term-current-column))
                                (term-move-columns -1))))
                           ((eq char ?\r)  ;; (terminfo: cr)
                            (term-vertical-motion 0)
                            (setq term-current-column term-start-line-column))
                           ((eq char ?\n)  ;; (terminfo: cud1, ind)
                            (unless (and term-kill-echo-list
                                         (term-check-kill-echo-list))
                              (term-down 1 t)))
                           ((eq char ?\b)  ;; (terminfo: cub1)
                            (term-move-columns -1))
                           ((eq char ?\033) ; Escape
                            (setq term-terminal-state 2))
                           ((eq char 0))	       ; NUL: Do nothing
                           ((eq char ?\016))     ; Shift Out - ignored
                           ((eq char ?\017))     ; Shift In - ignored
                           ((eq char ?\^G) ;; (terminfo: bel)
                            (beep t))
                           ((and (eq char ?\032)
                                 (not handled-ansi-message))
                            (let ((end (string-match "\r?$" str i)))
                              (if end
                                  (funcall term-command-hook
                                           (decode-coding-string
                                            (prog1 (substring str (1+ i) end)
                                              (setq i (match-end 0)))
                                            locale-coding-system t))
                                (setq term-terminal-parameter (substring str i))
                                (setq term-terminal-state 4)
                                (setq i str-length))))
                           (t   ; insert char FIXME: Should never happen
                            (term-move-columns 1)
                            (backward-delete-char 1)
                            (insert char))))
                    ((eq term-terminal-state 2)	  ; Seen Esc
                     (cond ((eq char ?\133)	  ;; ?\133 = ?[

                            ;; Some modifications to cope with multiple
                            ;; settings like ^[[01;32;43m -mm
                            ;; Note that now the init value of
                            ;; term-terminal-previous-parameter has been
                            ;; changed to -1

                            (setq term-terminal-parameter 0)
                            (setq term-terminal-previous-parameter -1)
                            (setq term-terminal-previous-parameter-2 -1)
                            (setq term-terminal-previous-parameter-3 -1)
                            (setq term-terminal-previous-parameter-4 -1)
                            (setq term-terminal-more-parameters 0)
                            (setq term-terminal-state 3))
                           ((eq char ?D) ;; scroll forward
                            (term-handle-deferred-scroll)
                            (term-down 1 t)
                            (setq term-terminal-state 0))
                           ;; ((eq char ?E) ;; (terminfo: nw), not used for
                           ;; 	       ;; now, but this is a working
                           ;; 	       ;; implementation
                           ;;  (term-down 1)
                           ;;  (term-goto term-current-row 0)
                           ;;  (setq term-terminal-state 0))
                           ((eq char ?M) ;; scroll reversed (terminfo: ri)
                            (if (or (< (term-current-row) term-scroll-start)
                                    (>= (1- (term-current-row))
                                        term-scroll-start))
                                ;; Scrolling up will not move outside
                                ;; the scroll region.
                                (term-down -1)
                              ;; Scrolling the scroll region is needed.
                              (term-down -1 t))
                            (setq term-terminal-state 0))
                           ((eq char ?7) ;; Save cursor (terminfo: sc)
                            (term-handle-deferred-scroll)
                            (setq term-saved-cursor
                                  (list (term-current-row)
                                        (term-horizontal-column)
                                        term-ansi-current-bg-color
                                        term-ansi-current-bold
                                        term-ansi-current-color
                                        term-ansi-current-invisible
                                        term-ansi-current-reverse
                                        term-ansi-current-underline
                                        term-current-face)
                                  )
                            (setq term-terminal-state 0))
                           ((eq char ?8) ;; Restore cursor (terminfo: rc)
                            (when term-saved-cursor
                              (term-goto (nth 0 term-saved-cursor)
                                         (nth 1 term-saved-cursor))
                              (setq term-ansi-current-bg-color
                                    (nth 2 term-saved-cursor)
                                    term-ansi-current-bold
                                    (nth 3 term-saved-cursor)
                                    term-ansi-current-color
                                    (nth 4 term-saved-cursor)
                                    term-ansi-current-invisible
                                    (nth 5 term-saved-cursor)
                                    term-ansi-current-reverse
                                    (nth 6 term-saved-cursor)
                                    term-ansi-current-underline
                                    (nth 7 term-saved-cursor)
                                    term-current-face
                                    (nth 8 term-saved-cursor)))
                            (setq term-terminal-state 0))
                           ((eq char ?c) ;; \Ec - Reset (terminfo: rs1)
                            ;; This is used by the "clear" program.
                            (setq term-terminal-state 0)
                            (term-reset-terminal))
                           ;; The \E#8 reset sequence for xterm. We
                           ;; probably don't need to handle it, but this
                           ;; is the code to parse it.
                           ;; ((eq char ?#)
                           ;;  (when (eq (aref str (1+ i)) ?8)
                           ;;    (setq i (1+ i))
                           ;;    (setq term-scroll-start 0)
                           ;;    (setq term-scroll-end term-height)
                           ;;    (setq term-terminal-state 0)))
                           ((setq term-terminal-state 0))))
                    ((eq term-terminal-state 3) ; Seen Esc [
                     (cond ((and (>= char ?0) (<= char ?9))
                            (setq term-terminal-parameter
                                  (+ (* 10 term-terminal-parameter) (- char ?0))))
                           ((eq char ?\;)
                            ;; Some modifications to cope with multiple
                            ;; settings like ^[[01;32;43m -mm
                            (setq term-terminal-more-parameters 1)
                            (setq term-terminal-previous-parameter-4
                                  term-terminal-previous-parameter-3)
                            (setq term-terminal-previous-parameter-3
                                  term-terminal-previous-parameter-2)
                            (setq term-terminal-previous-parameter-2
                                  term-terminal-previous-parameter)
                            (setq term-terminal-previous-parameter
                                  term-terminal-parameter)
                            (setq term-terminal-parameter 0))
                           ((eq char ??)) ; Ignore ?
                           (t
                            (term-handle-ansi-escape proc char)
                            (setq term-terminal-more-parameters 0)
                            (setq term-terminal-previous-parameter-4 -1)
                            (setq term-terminal-previous-parameter-3 -1)
                            (setq term-terminal-previous-parameter-2 -1)
                            (setq term-terminal-previous-parameter -1)
                            (setq term-terminal-state 0)))))
              (when (term-handling-pager)
                ;; Finish stuff to get ready to handle PAGER.
                (if (> (% (current-column) term-width) 0)
                    (setq term-terminal-parameter
                          (substring str i))
                  ;; We're at column 0.  Goto end of buffer; to compensate,
                  ;; prepend a ?\r for later.  This looks more consistent.
                  (if (zerop i)
                      (setq term-terminal-parameter
                            (concat "\r" (substring str i)))
                    (setq term-terminal-parameter (substring str (1- i)))
                    (aset term-terminal-parameter 0 ?\r))
                  (goto-char (point-max)))
                (setq term-terminal-state 4)
                (make-local-variable 'term-pager-old-filter)
                (setq term-pager-old-filter (process-filter proc))
                (set-process-filter proc term-pager-filter)
                (setq i str-length))
              (setq i (1+ i))))

          (when (>= (term-current-row) term-height)
            (term-handle-deferred-scroll))

          (set-marker (process-mark proc) (point))
          (when save-point
            (goto-char save-point)
            (set-marker save-point nil))

          ;; Check for a pending filename-and-line number to display.
          ;; We do this before scrolling, because we might create a new window.
          (when (and term-pending-frame
                     (eq (window-buffer selected) (current-buffer)))
            (term-display-line (car term-pending-frame)
                               (cdr term-pending-frame))
            (setq term-pending-frame nil))

          ;; Scroll each window displaying the buffer but (by default)
          ;; only if the point matches the process-mark we started with.
          (setq win selected)
          ;; Avoid infinite loop in strange case where minibuffer window
          ;; is selected but not active.
          (while (window-minibuffer-p win)
            (setq win (next-window win nil t)))
          (setq last-win win)
          (while (progn
                   (setq win (next-window win nil t))
                   (when (eq (window-buffer win) (process-buffer proc))
                     (let ((scroll term-scroll-to-bottom-on-output))
                       (select-window win)
                       (when (or (= (point) save-marker)
                                 (eq scroll t) (eq scroll 'all)
                                 ;; Maybe user wants point to jump to the end.
                                 (and (eq selected win)
                                      (or (eq scroll 'this) (not save-point)))
                                 (and (eq scroll 'others)
                                      (not (eq selected win))))
                         (goto-char term-home-marker)
                         (recenter 0)
                         (goto-char (process-mark proc))
                         (if (not (pos-visible-in-window-p (point) win))
                             (recenter -1)))
                       ;; Optionally scroll so that the text
                       ;; ends at the bottom of the window.
                       (when (and term-scroll-show-maximum-output
                                  (>= (point) (process-mark proc)))
                         (save-excursion
                           (goto-char (point-max))
                           (recenter -1)))))
                   (not (eq win last-win))))

          ;; Stolen from comint.el and adapted -mm
          (when (> term-buffer-maximum-size 0)
            (save-excursion
              (goto-char (process-mark (get-buffer-process (current-buffer))))
              (forward-line (- term-buffer-maximum-size))
              (beginning-of-line)
              (delete-region (point-min) (point))))
          (set-marker save-marker nil)))
      ;; This might be expensive, but we need it to handle something
      ;; like `sleep 5 | less -c' in more-or-less real time.
      (when (get-buffer-window (current-buffer))
        (redisplay))))  )


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(multi-term-scroll-show-maximum-output t)
 '(multi-term-scroll-to-bottom-on-output t)
 '(multi-term-switch-after-close nil)
 '(term-default-bg-color "#fdf6e3")
 '(term-default-fg-color "#657b83")
 '(term-scroll-show-maximum-output t)
 '(term-unbind-key-list (quote ("C-x" "C-c" "C-h" "C-y" "<ESC>"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(term-color-blue ((t (:background "steel blue" :foreground "steel blue"))))
 '(term-color-red ((t (:background "red2" :foreground "red2")))))
