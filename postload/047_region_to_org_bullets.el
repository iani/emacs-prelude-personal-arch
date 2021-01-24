;; 24 Jan 2021 12:08
(global-set-key (kbd "C-S-c c") 'region-to-org-bullets)

(defun region-to-org-bullets ()
  "Insert - at the beginning of each line in region."
  (interactive)
  (narrow-to-region (caar (region-bounds)) (cdar (region-bounds)))
  (replace-regexp "\n" "\n- ")
  (widen))
