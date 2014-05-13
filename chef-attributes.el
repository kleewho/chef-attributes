;;; chef-attributes.el -- Display all attributes of cookbook -*- lexical-binding: t -*-

;; Copyright © 2014 Łukasz Klich <lukasz@apeskull.biz>

;; Author: Łukasz Klich <lukasz@apeskull.biz>
;; URL: https://github.com/kleewho/
;; Keywords: project, convenience, chef
;; Version: 20140421.1
;; X-Original-Version: 0.1.0
;; Package-Requires: ((dash "2.5.0"))

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;; This library provides easy chef attributes management and navigation.
;;; Code:

(require 'dash)

(defvar chef-cookbook-search-dirs '("~/.berkshelf/cookbooks/"))

(defun chef-attributes-files (cookbook)
  "List all attributes file in COOKBOOK."
  (directory-files (concat cookbook "/attributes") t "rb"))

(defvar chef-priorities '("default" "force_default" "normal" "override" "force_override"))

(defvar chef-priorities-regexp (regexp-opt chef-priorities))

(defun chef-increment-priority-number (number)
  "Increments priority represented by NUMBER."
  (if (= number (- (length chef-priorities) 1)) number
    (+ number 1)))

(defun chef-decrement-priority-number (number)
  "Increments priority represented by NUMBER."
  (if (= number 0) number
    (- number 1)))

(defun chef-change-priority-level (priority fun)
  "Change priority PRIORITY level by FUN."
  (elt chef-priorities (funcall fun (-find-index (-partial 'string= priority) chef-priorities))))

(defun chef-increment-priority (priority)
  "Increments priority PRIORITY by one level."
  (chef-change-priority-level priority 'chef-increment-priority-number))

(defun chef-decrement-priority (priority)
  "Decrements priority PRIORITY by one level."
  (chef-change-priority-level priority 'chef-decrement-priority-number))

(defun chef-list-attributes (file)
  "List all attributes in attributes FILE."
  (with-temp-buffer
    (insert-file-contents file)
    (--> (buffer-string)
      (split-string it "[\n]")
      (remove "" it))))

(defun chef-cookbook-p (dir)
  "Check if DIR is a cookbook or not."
  (file-exists-p (concat dir "/metadata.rb")))

(defun chef-list-installed-cookbooks (dirs)
  "Traverse all DIRS searching for cookbooks."
  (->> dirs
    (--map (directory-files it t "[a-z]"))
    (-flatten)
    (-filter 'chef-cookbook-p)))

(defun chef-complete-cookbook ()
  "Complete cookbook name in minibuffer from prepared list installed cookbooks."
  (completing-read "Which cookbook: "
                   (chef-list-installed-cookbooks
                    chef-cookbook-search-dirs)))

(defun chef-get-attributes (cookbook)
  "Display all attributes in COOKBOOK to user."
  (interactive (list (chef-complete-cookbook)))
  (message "%s" cookbook)
  (message "attribute files %s" (chef-attributes-files cookbook)))


(defun chef-find-attribute-file (cookbook)
  "Open attribute file in chosen COOKBOOK."
  (interactive (list (chef-complete-cookbook)))
  (let ((file (ido-completing-read "Open file in cookbook: "
                                   (chef-attributes-files cookbook))))
    (find-file (expand-file-name file cookbook))))

(provide 'chef-attributes)

;;; chef-attributes.el ends here
