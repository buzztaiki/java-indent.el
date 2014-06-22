;;; java-indent.el --- Fix up java indentation

;; Copyright (C) 2014  Taiki Sugawara

;; Author: Taiki Sugawara <buzz.taiki@gmail.com>
;; Keywords: languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

(require 'dash)

(defun java-indent:langelem-eq (a b)
  (--all? (eq (funcall it a) (funcall it b))
          '(c-langelem-sym c-langelem-pos c-langelem-col)))
  
(defun java-indent:lineup-block-close (langelem)
  (save-excursion
    (if (java-indent:langelem-eq (car (c-guess-basic-syntax)) langelem)
        (vector (c-langelem-col langelem))
    (back-to-indentation)
    (forward-char)
    (c-backward-sexp)
    (back-to-indentation)
    (vector (current-column)))))

(defun java-indent:lineup-arglist (langelem)
  (save-excursion
    (goto-char (c-langelem-pos langelem))
    (back-to-indentation)
    (vector (+ (current-column) c-basic-offset))))

(defun java-indent:lineup-arglist-close (langelem)
  (save-excursion
    (goto-char (c-langelem-pos langelem))
    (back-to-indentation)
    (vector (current-column))))
  

(c-add-style
 "java-indent"
 '("java"
   (c-offsets-alist
    (arglist-intro . java-indent:lineup-arglist)
    (arglist-cont-nonempty . java-indent:lineup-arglist)
    (arglist-close . java-indent:lineup-arglist-close)
    
    (block-close . java-indent:lineup-block-close)
    (class-close . java-indent:lineup-block-close)
    (inexpr-class . 0)
    (annotation-top-cont . 0)
    (annotation-var-cont . 0)
    )
   ))


;; Local Variables:
;; lexical-binding: t
;; End:

(provide 'java-indent)
;;; java-indent.el ends here
