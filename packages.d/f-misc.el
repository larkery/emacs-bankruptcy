(req-package winner
  :demand t
  :bind (("<XF86Tools>" . winner-undo)
         ("<XF86Launch5>" . winner-redo))
  :config
  (winner-mode 1))
;; (req-package which-key
;; 	     :diminish
;; 	     :config
;; 	     (which-key-setup-minibuffer)
;; 	     (which-key-mode)
;; 	     (setq max-mini-window-height 0.2))

(req-package w3m
  :config

  (setq w3m-use-title-buffer-name t
        w3m-confirm-leaving-secure-page nil
        )

  (setq w3m-default-symbol
		   '("─┼" " ├" "─┬" " ┌" "─┤" " │" "─┐" ""
		     "─┴" " └" "──" ""   "─┘" ""   ""   ""
		     "─┼" " ┠" "━┯" " ┏" "─┨" " ┃" "━┓" ""
		     "━┷" " ┗" "━━" ""   "━┛" ""   ""   ""
		     " •" " □" " ☆" " ○" " ■" " ★" " ◎"
		     " ●" " △" " ●" " ○" " □" " ●" "≪ ↑ ↓ ")))
