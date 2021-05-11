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

(defcustom org-latex-default-template "default-template"
  "Default template directory name."
  :group 'org-latex-compile)

(defcustom org-latex-template-property 'LATEX-TEMPLATE
  "Name of the org property that stores the latex template name."
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
If subtreep get from subtree property. Else from file property"
  (let (selected-template)
    (if selected-template
        selected-template
      org-latex-selected-template
      ))  )

(defcustom org-latex-template-directory "/000BASIC"
  "Subdirectory containing sources for compiling latex.
Contains the framework file with latex header, style specifications and footer,
and any auxiliary files e.g. bibtex, images etc.
The body.tex file produced by org-export-as as well as the resulting
pdf file are temporarily stored here.  The final pdf is copied to ../exports
after the end of the export process.
"
  :group 'org-latex-compile)

(defcustom org-latex-history-directory "/history"
  "Subdirectory storing framework files.
After each export, rename and copy file framework.tex (the file providing the
style and package specifications for compiling the pdf) to this directory.
The name is named after from the filename or compile name of the pdf + timestamp.

"
  :group 'org-latex-compile)

(defun org-latex-framework-path ()
  "Calculate actual path of framework file."
  (let ((template-path (concat org-latex-export-path
                               org-latex-template-directory
                               org-latex-history-directory
                               "/framework.tex")))
    (if (file-exists-p template-path)
        template-path
      (error "You must install latex-templates in your home folder to use this."))))

(defun org-latex-default-framework-path ()
  "Calculate default path of framework file."
  (let ((template-path (concat org-latex-export-path
                               org-latex-template-directory
                               org-latex-history-directory
                               "/framework.tex")))
    (if (file-exists-p template-path)
        template-path
      (error "You must install latex-templates in your home folder to use this."))))

(defun org-latex-body-path (framework-path)
  "Calculate full path of file to export latex body from org."
  (concat org-latex-export-path org-latex-template-directory "/body.tex"))

;;; 034b_org_compile_latex_framework_redo ends here
