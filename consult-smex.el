;;; consult-smex.el --- M-x interface using Consult and Smex  -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Peter Vasil
;; Copyright (C) 2021  USAMI Kenta

;; Author: Peter Vasil <mail@petervasil.net>
;; Maintainer: USAMI Kenta <tadsan@zonu.me>
;; Version: 0.3.1
;; Homepage: https://github.com/zonuexe/consult-smex
;; Keywords: convenience, usability
;; Package-Requires: ((emacs "25.1") (smex "3.0") (consult "0.5"))
;; License: GPL-3.0-or-later

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This packaage provides M-x alternative function that using Smex and Consult.
;;
;; Put follow code to your init.el file for activation:
;;
;;     (global-set-key [remap execute-extended-command] #'consult-smex)
;;

;;; Code:
(require 'consult)
(require 'smex)

(defun consult-smex--init-smex ()
  "Initialization Smex."
  (unless smex-initialized-p
    (smex-initialize))
  (and smex-auto-update
       (smex-detect-new-commands)
       (smex-update)))

(defun consult-smex--execute-command (command)
  "Execute COMMAND."
  (unless (commandp command)
    (user-error  "`%s' is not a valid command name" command))
  (setq this-command command)
  ;; Normally `real-this-command' should never be changed, but here we really
  ;; want to pretend that M-x <cmd> RET is nothing more than a "key binding" for <cmd>.
  (setq real-this-command command)
  (let ((prefix-arg current-prefix-arg))
    (unwind-protect
        (command-execute command 'record)
      (smex-rank command))))

(defun consult-smex ()
  "Read a command name, then read the arguments and call the command using Smex."
  (interactive)
  (consult-smex--init-smex)
  (let ((command (consult--read smex-ido-cache :prompt "M-x ")))
    (consult-smex--execute-command command)))

(provide 'consult-smex)
;;; consult-smex.el ends here
