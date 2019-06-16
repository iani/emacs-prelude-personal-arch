;;; org_mode_bullets --- 2019-06-16 12:11:37 PM
  ;;; Commentary:
  ;; pretty bullets for org mode sections

  ;;; Code:
  (prelude-require-package 'org-bullets)

  ;;; use bullets currently displayable by emacson macos 10.13 and arch linux 18:
  (setq org-bullets-bullet-list
        '(
          "⦿" "●" "○" "⧁" "⟾" "⤇" "⟹" "⥤" "⟶" "◎" "◆" "◇" "■" "□" "◼" "◻" "⚙"
          ))
(provide 'org_mode_bullets)
;;; 025_org_mode_bullets.el ends here
