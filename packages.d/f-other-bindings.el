;; -*- lexical-binding: t -*-
(unbind-key "C-x -")

(defun split-or-unsplit-window ()
  (interactive)
  (if (cdr (window-list))
      (delete-other-windows)
    (progn (split-window-sensibly)
           (other-window 1))))

(defun kill-this-buffer-and-delete-window ()
  (interactive)

  (kill-this-buffer)
  (delete-window))

(bind-keys
 ("C-x C-b" . ibuffer)
 ("C-x k" . kill-this-buffer)
 ("C-x M-k" . kill-this-buffer-and-delete-window)
 ("C-x C-a" . edit-as-root)
 ("C-x d" . dired-ffap)
 ("C-x - -" . shrink-window-if-larger-than-buffer)
 ("C-x - =" . balance-windows)
 ("C-x - +" . maximize-window)
 ("C-<f5>" . maximize-window)
 ("<f5>" . split-or-unsplit-window)
 )

(bind-keys
 ("C-c t t" . align-whitespace)
 ("C-c t a" . align-regexp)
 ("C-c t A" . align)
 ("C-c t SPC" . align-paragraph)
 ("C-c '" . remotely-edit-string))

(req-package transpose-frame
  :commands transpose-frame
  :bind ("M-C-o" . transpose-frame))

(bind-keys
 ("C-z" . undo)
 ([remap just-one-space] . cycle-just-one-space)
 ([remap fill-paragraph] . fill-or-unfill)
 ([remap narrow-to-region] . narrow-dwim)
 ("M-/" . hippie-expand)
 ("M-o" . other-window)
 ("M-O" . swap-last-windows)
 ("C-S-l" . hl-line-mode)
 ("C-S-N" . linum-mode))
