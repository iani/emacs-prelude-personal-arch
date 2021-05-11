;;; 034b_org_compile_latex_framework_redo --- 15 Mar 2021 18:14
;;; Commentary:
;; This is a redo from scratch to use a better template scheme
;; based on symbolic link from template folder to compile folder.
;; see accompanying .org file for documentation

;;; Code:

;;; ================================================================
;;; Required packages and global option settings
;; First load this package to initialize variables:
(require 'ox-latex)

;; Use xelatex as latex compiler, thus enabling use of native fonts for greek etc.
(setq org-latex-compiler "xelatex")

;;; ================================================================
;;; PATHS:
;;; org-latex-base org-latex-default-template
;;; org-latex-exports-dir org-latex-templates-dir org-latex-compile-dir
;;;

(defcustom org-latex-base (file-truename "~/latex-exports/")
  "Directory where latex template and export files are stored.
Both the source files and the resulting pdf files are stored in this directory."
  :group 'org-latex-compile)

(defcustom org-latex-template-property 'LATEX-TEMPLATE
  "Name of the org property that stores the latex template name."
  :group 'org-latex-compile)

(defcustom org-latex-default-template "default-template"
  "Default template directory name."
  :group 'org-latex-compile)

(defun org-latex-exports-dir ()
  "Directory where exported pdf files are stored."
  (concat org-latex-base "exports"))

(defun org-latex-templates-dir ()
  "Directory storing templates for exporting to latex."
  (concat org-latex-base "templates"))

(defun org-latex-compile-dir ()
  "Directory where latex is exported and compiled to pdf.
This is created by copying the selected template directory."
  (concat org-latex-base "compile_framework"))

(defun org-latex-selected-template-path (&optional subtreep)
  "Get path of selected template."
  (concat org-latex-base (org-latex-selected-template subtreep)))

(defun org-latex-selected-template (&optional subtreep)
  "Get name of selected template.
If subtreep return subtree property. Else return file property"
  (if subtreep
      (or (org-property-or-variable-value org-latex-template-property)
            (org-latex-get-file-template))
    (org-latex-get-file-template)))

(defun org-latex-get-file-template ()
  "If defined, return file property for latex template, else return default template."
  (org-get-global-buffer-property
   org-latex-template-property
   (symbol-name org-latex-default-template)))

;;; Helper functions for getting global file property
(defun org-global-props (property &optional buffer)
  "Get the plists of global org properties of current buffer."
  (with-current-buffer (or buffer (current-buffer))
    (org-element-map (org-element-parse-buffer) 'keyword
      (lambda (el)
        (when (string-match property (org-element-property :key el)) el)))))

(defun org-get-global-buffer-property (prop &optional default)
  "Get the value of property prop defined globally in current buffer.
If not defined, return the default provided as optional argument."
  (or
   (car (mapcar (lambda (prop) (org-element-property :value prop))
            (org-global-props prop)))
   default))

(defun org-compile-latex-with-custom-framework (&optional filep)
  "Export org to latex and compile that to pdf.
If filep is true   "
  (interactive "P")
  (let ((subtreep (not filep)))
    (if subtreep
        (progn
          (message "I WILL COMPILE THE SUBSECTION conc cond")
          (message "The template is: %s" (org-latex-selected-template-path subtreep)))
      (progn
        (message "I ILL COMPILE THE ENTIRE FILE !!!!!!!! cond ocnd")
        (message "The template is: %s"
                 (org-latex-selected-template-path subtreep))))))

(global-set-key (kbd "C-M-S-c") 'org-compile-latex-with-custom-framework)
;;; 034b_org_compile_latex_framework_redo ends here
