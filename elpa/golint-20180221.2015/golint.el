;;; golint.el --- lint for the Go source code

;; Copyright 2013 The Go Authors. All rights reserved.

;; License: BSD-3-clause
;; URL: https://github.com/golang/lint
;; Package-Version: 20180221.2015
;; Package-Commit: 0562613f16a6ec439a4a68e817e69e0f7c405c87

;;; Commentary:

;; To install golint, add the following lines to your .emacs file:
;;   (add-to-list 'load-path "PATH CONTAINING golint.el" t)
;;   (require 'golint)
;;
;; After this, type M-x golint on Go source code.
;;
;; Usage:
;;   C-x `
;;     Jump directly to the line in your code which caused the first message.
;;
;;   For more usage, see Compilation-Mode:
;;     http://www.gnu.org/software/emacs/manual/html_node/emacs/Compilation-Mode.html

;;; Code:

(require 'compile)

(defun go-lint-buffer-name (mode)
  "*Golint*")

(defun golint-process-setup ()
  "Setup compilation variables and buffer for `golint'."
  (run-hooks 'golint-setup-hook))

(define-compilation-mode golint-mode "golint"
  "Golint is a linter for Go source code."
  (set (make-local-variable 'compilation-scroll-output) nil)
  (set (make-local-variable 'compilation-disable-input) t)
  (set (make-local-variable 'compilation-process-setup-function)
       'golint-process-setup))

;;;###autoload
(defun golint ()
  "Run golint on the current file and populate the fix list.
Pressing \"C-x `\" jumps directly to the line in your code which
caused the first message."
  (interactive)
  (compilation-start
   (mapconcat #'shell-quote-argument
              (list "golint" (expand-file-name buffer-file-name)) " ")
   'golint-mode))

(provide 'golint)

;;; golint.el ends here
