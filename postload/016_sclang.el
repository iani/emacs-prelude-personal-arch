;;; sclang --- 2019-06-13 10:59:56 AM
  (require 'sclang)
  ;; Global keyboard shortcut for starting sclang
  (global-set-key (kbd "C-c M-s") 'sclang-start)
  ;; overrides alt-meta switch command
  (global-set-key (kbd "C-c W") 'sclang-switch-to-workspace)
(provide 'sclang)
;;; 016_sclang.el ends here
