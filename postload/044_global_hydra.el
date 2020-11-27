;;; Note: this hydra provides some minimally shorter
;;; kbd sequences for projectile.
;;; Maybe later there will be more stuff.
(defhydra hydra-global (:color blue :columns 4)
  "Global Hydra (mainly projectile stuff)"
  ("p" helm-projectile-switch-project "switch project" :exit t)
  ("f" helm-projectile-find-file "find project file" :exit t)
  ("d" helm-projectile-dired-dir "find project dir" :exit t)
  ("D" projectile-dired "dired project root" :exit t)
  ("a" helm-projectile-ag "search in project" :exit t)
  ("r" projectile-replace "replace in project" :exit t)
  ("v" magit "magit" :exit t)
  ("p" projectile-switch-project "switch project" :exit t))

(global-set-key (kbd "C-M-S-g") 'hydra-global/body)
