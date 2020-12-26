;; 20 Dec 2020 05:40 do recentf-save before kill terminal
(defun recentf-save-list-kill-terminal ()
  "Do recentf-save-list, then kill terminal.
This ensures that when quitting emacs terminal with C-x C-c, the
list of recently visited files will be saved.
This list can be consulted in the next emacs session with C-c f (helm-recentf)."
  (interactive)
  (recentf-save-list)
  (save-buffers-kill-terminal))

(global-set-key (kbd "C-x C-c") 'recentf-save-list-kill-terminal)
