(ert-deftest chef-increment-priority-number-test ()
  (should (equal 1 (chef-increment-priority-number 0)))
  (should (equal 4 (chef-increment-priority-number 4))))

(ert-deftest chef-decrement-priority-number-test ()
  (should (equal 0 (chef-decrement-priority-number 0)))
  (should (equal 3 (chef-decrement-priority-number 4))))

(ert-deftest chef-increment-priority-test ()
  (should (equal "force_default" (chef-increment-priority "default")))
  (should (equal "force_override" (chef-increment-priority "force_override"))))

(ert-deftest chef-decrement-priority-test ()
  (should (equal "default" (chef-decrement-priority "default")))
  (should (equal "override" (chef-decrement-priority "force_override"))))

(ert-deftest chef-read-line-test ()
  (let ((result
         (with-temp-buffer
           (insert "Multi line text\nin temp buffer")
           (goto-char (point-min))
           (chef-read-line))))
    (should (string= "Multi line text" result))))

(ert-deftest chef-attribute-line-p-test ()
  (with-temp-buffer
    (insert "default['chef']['attributes']")
    (should (chef-attribute-line-p)))
  (with-temp-buffer
    (insert "node['chef']['attributes']")
  (should (not (chef-attribute-line-p)))))

(ert-deftest chef-attribute-edit-line-test ()
  (with-temp-buffer
    (insert "default['chef']")
    (chef-attribute-edit-line 'chef-increment-priority)
    (should (string= "force_default['chef']" (buffer-string)))))

(ert-deftest chef-attribute-edit-line-when-double-word-test ()
  (with-temp-buffer
    (insert "force_default['chef']")
    (chef-attribute-edit-line 'chef-increment-priority)
    (should (string= "normal['chef']" (buffer-string)))))

(ert-deftest chef-attribute-edit-line-ant-attr-test ()
  (with-temp-buffer
    (insert "force_default['ant']['version']        = '1.8.2'")
    (subword-mode)
    (chef-attribute-edit-line 'chef-increment-priority)
    (should (string= "normal['ant']['version']        = '1.8.2'" (buffer-string)))))

(ert-deftest chef-insert-priority-test ()
  (with-temp-buffer
    (chef-insert-priority "default")
    (should (string= "default" (buffer-string))))
  (with-temp-buffer
    (insert "['chef']")
    (chef-insert-priority "default")
    (should (string= "default['chef']" (buffer-string)))))

(ert-deftest chef-delete-priority-test ()
  (with-temp-buffer
    (insert "default['chef']")
    (chef-delete-priority)
    (should (string= "['chef']" (buffer-string)))))
