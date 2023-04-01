;;; gitmoji.el --- Insert gitmojis in Emacs          -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Janus S. Valberg-Madsen

;; Author: Janus S. Valberg-Madsen
;; Keywords: multimedia, convenience
;; URL: https://github.com/janusvm/emacs-gitmoji
;; Version: 0.1.0

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

;; This package provides a function for inserting emoji as specified on
;; <https://gitmoji.dev>. Very heavily inspired by and based on the emojify
;; package <https://github.com/iqbalansari/emacs-emojify>

;;; Code:

(require 'json)
(require 'emojify)

(defvar gitmoji-emojis nil
  "Emoji data, to be populated from the file `gitmoji-json-file'.")

(defvar gitmoji-json-file
  (expand-file-name "data/gitmojis.json" (file-name-directory (locate-library "gitmoji")))
  "JSON file to read gitmoji emoji data from.")

(defun gitmoji-set-emoji-data (&optional force)
  "Create `gitmoji-emojis' if needed.

Reads emoji data if it hasn't been already or if FORCE is given."
  (when (or force (not gitmoji-emojis))
    (let* ((json-object-type 'hash-table)
           (json-array-type 'list)
           (json-key-type 'string)
           (gitmojis-json (json-read-file gitmoji-json-file))
           (gitmojis (gethash "gitmojis" gitmojis-json)))
      (setq gitmoji-emojis
            (mapcar (lambda (gitmoji)
                      (format "%s (%s) %s"
                              (gethash "emoji" gitmoji)
                              (gethash "name" gitmoji)
                              (gethash "description" gitmoji)))
                    gitmojis)))))

(defun gitmoji-completing-read (prompt &optional initial-input)
  "Prompt for selecting an emoji and return the selected emoji."
  (gitmoji-set-emoji-data)
  (let ((emojify-minibuffer-reading-emojis-p t)
        (minibuffer-setup-hook (cons #'emojify--completing-read-minibuffer-setup-hook minibuffer-setup-hook)))
    (substring (funcall completing-read-function
                        prompt
                        gitmoji-emojis
                        nil
                        nil
                        initial-input
                        nil
                        nil
                        nil)
               0 1)))

;;;###autoload
(defun gitmoji-insert-emoji (&optional beg end)
  "Interactively prompt for Gitmojis and insert them in the current buffer.
If the region is active, the selected text will be used as the initial input for the completing read and replaced by the selected Gitmoji."
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list nil nil)))
  (if (and beg end)
      (let* ((initial-input (buffer-substring-no-properties beg end))
             (selected-gitmoji (gitmoji-completing-read "Insert Gitmoji: " initial-input)))
        (kill-region beg end)
        (insert selected-gitmoji))
    (insert (gitmoji-completing-read "Insert Gitmoji: "))))

(provide 'gitmoji)
;;; gitmoji.el ends here
