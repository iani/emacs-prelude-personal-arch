;;; prelude-off --- 2019-06-16 12:11:37 PM
  ;;; Commentary:

  ;; define prelude-off function to permit
  ;; functions which use it.
  ;; Prelude off is missing from latest version of prelude

  ;;; Code:

  (defun prelude-off ()
    "Allow call of this empty function for packages that require it."
    (interactive)
    ;; do nothing
    )
(provide 'prelude-off)
;;; 023_prelude-off.el ends here
