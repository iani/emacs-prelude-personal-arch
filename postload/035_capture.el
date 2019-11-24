(setq org-default-notes-file
      (concat (file-truename "~/Documents/000Workfiles/PROJECTS_CURRENT/")
              "PROJECT_REVIEW_AND_CAPTURE.org"))

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline org-default-notes-file "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree org-default-notes-file)
         "* %?\nEntered on %U\n  %i\n  %a")))

(global-set-key (kbd "C-S-c C-S-c") 'org-capture)
(global-set-key (kbd "C-S-c C-S-r") 'org-capture-goto-last-stored)
