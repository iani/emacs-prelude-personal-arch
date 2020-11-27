;;; Note: this hydra provides some minimally shorter
;;; kbd sequences for projectile.
;;; Maybe later there will be more stuff.
(defhydra hydra-global (:color blue :columns 4)
  "Global Hydra (mainly projectile+sclang stuff)"
  ("p" helm-projectile-switch-project "switch project" :exit t)
  ("f" helm-projectile-find-file "find project file" :exit t)
  ("d" helm-projectile-dired-dir "find project dir" :exit t)
  ("D" projectile-dired "dired project root" :exit t)
  ("a" helm-projectile-ag "search in project" :exit t)
  ("r" projectile-replace "replace in project" :exit t)
  ("v" magit "magit" :exit t)
  ("p" projectile-switch-project "switch project" :exit t)
  ("i" reload-init-file "reload init file" :exit t)
  ("b" sclang-server-boot "boot scsynth server" :exit t)
  ("k" sclang-server-quit "quit scsynth server" :exit t)
  ("K" sclang-kill-servers "kill all scsynth servers" :exit t)
  ("c" sclang-recompile "recompile sclang library" :exit t)
  ("S" sclang-start "start sclang" :exit t)
  ("Q" sclang-stop "quit sclang" :exit t)
  ("q" quit "quit (exit hydra)" :exit t))

;;; more semantic
(global-set-key (kbd "C-M-S-g") 'hydra-global/body)
;;; more convenient on keyboard
(global-set-key (kbd "C-M->") 'hydra-global/body)
