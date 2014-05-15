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

(ert-deftest chef-delete-word-test ()
  (let ((result
         (with-temp-buffer
           (insert "Multi word line")
           (goto-char (point-at-bol))
           (chef-delete-word)
           (buffer-string))))
    (should (string= " word line" result))))

(ert-deftest chef-read-linetest ()
  (let ((result
         (with-temp-buffer
           (insert "Multi line text\nin temp buffer")
           (beginning-of-buffer)
           (chef-read-line))))
    (should (string= "Multi line text" result))))


(ert-deftest chef-attribute-line-p-test ()
  (should (chef-attribute-line-p "default['chef']['attributes']"))
  (should (not (chef-attribute-line-p "node['chef']['attributes']"))))

(ert-deftest chef-attribute-edit-line-test ()
  ())
