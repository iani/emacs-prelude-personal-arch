;;; org_mode_bullets --- 2019-06-29 08:08:22 AM
;;; Commentary:
;; pretty bullets for org mode sections

;;; Code:
(prelude-require-package 'org-bullets)

;;; use bullets currently displayable by emacson macos 10.13 and arch linux 18:
(setq org-bullets-bullet-list
      '("⦿" "✸" "►" "▷" "✧" "✦" "●" "○" "⚙" "✿" "◇" "◆" "★" "◻" "◼"  "◎" "◉" "⧁" "□" "■" "⟾" "⟶" "⤇" "⥤"
        ))

;; add this macro for inserting item bullets ( 5 Feb 2021 22:21)
(fset 'org-insert-item-dash
      (kmacro-lambda-form [?\C-a ?- ?\C-n ?\C-a] 0 "%d"))
(provide 'org_mode_bullets)
;;; 025_org_mode_bullets.el ends here
