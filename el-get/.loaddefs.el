;;; .loaddefs.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads nil "ido-describe-prefix-bindings.el/ido-describe-prefix-bindings"
;;;;;;  "ido-describe-prefix-bindings.el/ido-describe-prefix-bindings.el"
;;;;;;  (22219 6733 947313 131000))
;;; Generated autoloads from ido-describe-prefix-bindings.el/ido-describe-prefix-bindings.el

(defvar ido-describe-prefix-bindings-mode nil "\
Non-nil if Ido-Describe-Prefix-Bindings mode is enabled.
See the command `ido-describe-prefix-bindings-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `ido-describe-prefix-bindings-mode'.")

(custom-autoload 'ido-describe-prefix-bindings-mode "ido-describe-prefix-bindings.el/ido-describe-prefix-bindings" nil)

(autoload 'ido-describe-prefix-bindings-mode "ido-describe-prefix-bindings.el/ido-describe-prefix-bindings" "\
Uses ido to display and execute prefix bindings

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil "ido-grid.el/ido-grid" "ido-grid.el/ido-grid.el"
;;;;;;  (22219 6735 247313 80000))
;;; Generated autoloads from ido-grid.el/ido-grid.el

(defvar ido-grid-enabled nil "\
Display ido prospects in a grid?")

(custom-autoload 'ido-grid-enabled "ido-grid.el/ido-grid" nil)

(autoload 'ido-grid--custom-advice "ido-grid.el/ido-grid" "\


\(fn SYM NEW-VALUE)" nil nil)

(autoload 'ido-grid-enable "ido-grid.el/ido-grid" "\


\(fn)" t nil)

(autoload 'ido-grid-disable "ido-grid.el/ido-grid" "\


\(fn)" t nil)

;;;***

;;;### (autoloads nil "ido-match-modes.el/ido-match-modes" "ido-match-modes.el/ido-match-modes.el"
;;;;;;  (22219 6733 75313 165000))
;;; Generated autoloads from ido-match-modes.el/ido-match-modes.el

(autoload 'ido-match-modes-toggle "ido-match-modes.el/ido-match-modes" "\
Switch ido-match-modes on if it's off or off if it's on.
With a negative prefix argument, make sure it's off, and with a
positive one make sure it's on.

\(fn ARG)" t nil)

;;;***

;;;### (autoloads nil nil ("i3-emacs/i3-integration.el" "i3-emacs/i3.el"
;;;;;;  "ido-grid.el/ido-grid-tests.el") (22221 46668 494545 674000))

;;;***

(provide '.loaddefs)
;; Local Variables:
;; version-control: never
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; .loaddefs.el ends here
