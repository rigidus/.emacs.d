;;; vyper-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "vyper-mode" "vyper-mode.el" (0 0 0 0))
;;; Generated autoloads from vyper-mode.el

(autoload 'vyper-mode "vyper-mode" "\
Major mode for Vyper

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.vy\\'" . vyper-mode))

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "vyper-mode" '("vyper-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; vyper-mode-autoloads.el ends here
