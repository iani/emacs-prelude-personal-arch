(defun reload-init-file ()
  "Reload init.el from emacs.d/personal/."
  (interactive)
  (load-file "~/.emacs.d/personal/init.el"))

;; (file-exists-p "~/.emacs.d/personal/init.el")

;; (global-set-key (kbd "C-M-S-i") 'reload-init-file)
