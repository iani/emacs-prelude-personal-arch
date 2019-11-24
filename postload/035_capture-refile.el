(setq org-default-notes-file
      (concat (file-truename "~/Documents/000Workfiles/PROJECTS_CURRENT/")
              "PROJECT_REVIEW_AND_CAPTURE.org"))

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline org-default-notes-file "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree org-default-notes-file)
         "* %?\nEntered on %U\n  %i\n  %a")))

(setq org-refile-targets
  '(("~/Documents/000Workfiles/PROJECTS_CURRENT/PROJECT_SUMMARIES.org"
     :maxlevel . 3)))

(global-set-key (kbd "C-S-c C-S-c") 'org-capture)
(global-set-key (kbd "C-S-c C-S-r") 'org-capture-goto-last-stored)

(defun org-refile-jump-to-target ()
  "Call org-refile with argument to jump to target."
  (interactive)
  (funcall-interactively 'org-refile '(4)))

(defun org-refile-clear-cache ()
  "Clear org refile cache."
  (interactive)
  (org-refile-cache-clear)
  ;; (funcall-interactively 'org-refile '(64)
  )

(defhydra hydra-org-refile (
                          ;; sclang-mode-map "C-L"
                            :color blue :columns 3)
  "Org refile hydra"
  ("c" org-refile-clear-cache "clear cache")
  ("r" org-refile-keep "refile (keep)")
  ("R" org-refile "refile (do not keep)")
  ("j" org-refile-jump-to-target "jump to refile target")
  ("l" org-refile-goto-last-stored "goto last stored")
  ;; ("q" quit "quit" :exit t)
  )

(global-set-key (kbd "C-M-S-r") 'hydra-org-refile/body)
