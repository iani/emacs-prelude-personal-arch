;;; sclang --- 2019-06-16 12:11:37 PM
  (require 'sclang)
  ;; Global keyboard shortcut for starting sclang
  (global-set-key (kbd "C-c M-s") 'sclang-start)
  ;; overrides alt-meta switch command
  (global-set-key (kbd "C-c W") 'sclang-switch-to-workspace)
(provide 'sclang)
;;; 018_sclang.el ends here
