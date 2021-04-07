;;; flymake-solidity.el --- A flymake handler for solidity using solc
;;
;; Author: Pascal van Kooten <kootenpv@gmail.com>
;; Homepage: https://github.com/kootenvp/flymake-solidity
;; Package-Requires: ((flymake-easy "0.10"))
;; Package-Version: 20170805.644
;; Package-Commit: 48bfe9525f764d8a68cc0270905dbf45bfd00bb8

;; License: AGPL3 or later

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU Affero General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Affero General Public License for more details.

;; You should have received a copy of the GNU Affero General Public
;; License along with this program.  If not, see
;; <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; This package requires the "solc" (solidity compiler) program, which can be installed
;; following OS specific instructions from the ethereum website.
;;
;; Add to your .emacs file configuration:
;;
;;   (require 'flymake-solidity)
;;   (add-hook 'find-file-hook 'flymake-solidity-maybe-load)
;;
;; If the "solc" path is different from "/usr/local/bin/solc", then add the line below (after changing your path):
;;
;;   (setq flymake-solidity-executable "/usr/local/bin/solc")
;;
;;
;; Uses flymake-easy, from https://github.com/purcell/flymake-easy
;;; Author: Steve Purcell <steve@sanityinc.com>
;;; Homepage: https://github.com/purcell/flymake-solidity

;;; Code:

(require 'flymake-easy)

(defvar flymake-solidity-executable "/usr/local/bin/solc")

(defconst flymake-solidity-err-line-patterns
  '(("^\\(.+.sol\\):\\([0-9]+\\):\\([0-9]+\\): \\(.+\\)$" 1 2 3 4)))

(defun flymake-solidity-command (filename)
  "Construct a command that flymake can use to check solidity source."
  (list flymake-solidity-executable filename))

(defun flymake-solidity-load ()
  "Configure flymake mode to check the current buffer's javascript syntax."
  (interactive)
  (flymake-easy-load 'flymake-solidity-command
                     flymake-solidity-err-line-patterns
                     'inplace
                     "sol"))  ;; needs to be inplace because of imports

;;;###autoload
(defun flymake-solidity-maybe-load ()
  "Call `flymake-solidity-load' if this file appears to be solidity."
  (interactive)
  (if (and buffer-file-name
           (string= "sol" (file-name-extension buffer-file-name)))
      (flymake-solidity-load)))

(provide 'flymake-solidity)
;;; flymake-solidity.el ends here
