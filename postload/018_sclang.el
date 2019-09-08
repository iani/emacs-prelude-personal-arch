;;; sclang --- 2019-06-29 08:08:22 AM
(require 'sclang)
;; Global keyboard shortcut for starting sclang
(global-set-key (kbd "C-c M-s") 'sclang-start)
;; Start sclang and open workspace window
(global-set-key (kbd "C-c C-M-s") 'sclang-start-with-workspace)

(defun sclang-start-with-workspace ()
  "Start sclang and open workspace window."
  (interactive)
  (sclang-start)
  (sclang-switch-to-workspace))

;; overrides alt-meta switch command
(global-set-key (kbd "C-c W") 'sclang-switch-to-workspace)
(provide 'sclang)
;;; 018_sclang.el ends here
