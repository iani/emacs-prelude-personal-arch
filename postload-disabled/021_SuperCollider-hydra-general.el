;;; SuperCollider-hydra-general --- 2019-06-29 08:08:22 AM
  ;; mode-map does not work because it is overwritten by global sclang-mode=map settings
  ;; in a different file here.
  (defhydra hydra-sclang (
                          ;; sclang-mode-map "C-S"
                                          :color red :columns 3)
      "SC utils hydra"
      ("k" sclang-kill "kill sc")
      ("b" sclang-server-boot "boot server")
      ("q" sclang-server-quit "quit server")
      ("t" sclang-osc-trace-on "osc trace on")
      ("T" sclang-osc-trace-off "osc trace off")
      ("p" sclang-server-plot-tree "server plot nodes")
      ("i" sclang-sclang-set-io-channels "set io channels")
      ("m" sclang-server-meter "meter")
      ("s" sclang-server-scope "scope")
      ("f" sclang-server-freqscope "freqscope")
      ("a" sclang-server-free-all "server free all")
      ("l" sclang-snippet-list "snippet list")
      ("L" sclang-player-snippet-list "player snippet list")
      ("e" quit "exit hydra" :exit t))

  (defun sclang-osc-trace-on ()
    "Turn OSCFunc trace on."
    (interactive)
    (sclang-eval-string "OSCFunc.trace(true)"))

  (defun sclang-osc-trace-off ()
    "Turn OSCFunc trace off."
    (interactive)
    (sclang-eval-string "OSCFunc.trace(false)"))

  (defun sclang-server-plot-tree ()
    "Show server node tree gui."
    (interactive)
    (sclang-eval-string "Server.default.plotTree"))

  (defun sclang-snippet-list ()
    "Open SnippetList gui."
    (interactive)
    (sclang-eval-string "SnippetList.gui"))

  (defun sclang-player-snippet-list ()
    "Open PlayerSnippetList gui."
    (interactive)
    (sclang-eval-string "PlayerSnippetList.gui"))
(provide 'SuperCollider-hydra-general)
;;; 021_SuperCollider-hydra-general.el ends here
