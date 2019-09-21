(setq org-default-notes-file
      (concat (file-truename "~/Documents/000Workfiles/PROJECTS_CURRENT/")
              "Todo.org"))

(global-set-key (kbd "C-S-c C-S-c") 'org-capture)
