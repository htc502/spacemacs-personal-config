;;; pipeline.el --- This is a lisp script for R project management

;;; Commentary:
;;

;;; Code:

;;; in order to avoid name collision, I add my name as prefix...
(defun ghan-add-r-script ()
  (interactive)
  (let ((script-name (read-file-name "Enter script name([a-z].[0-9].xxx.r):")))
    ;;TODO: threshold the number of characters of xxx to 20, that makes the pipeline figure easy to read
    (when (file-exists-p script-name)
      (error "script file: %s already exists." script-name)
      )
    (write-region "#' @input \n#' @output \n" nil script-name)
    ;;open a buffer for this new filenumber of lines and characters in the region. and switch to this buffer
    (find-file script-name)
    )
  )

;;(ghan-add-r-script )

(defun ghan-generate-r-pipeline-flowchart ();;project-root-dir)
  (interactive)
  "Invoke to show the overall pipeline, this is cool.
Argument PROJECT-ROOT-DIR work directory for your project."
  (let (;;(project-root-dir (read-directory-name "Enter script name([a-z].[0-9].xxx.r):"))
        ;;(default-directory project-root-dir)
        (command-make-image (concat "R --no-save <" (prin1-to-string configuration-layer-private-layer-directory) "r-pipeline-manager/show_pipeline.r"))
        (flowchart-file-name "pipeline-diagram.png"))
    (message command-make-image)
    (shell-command command-make-image)
    (when (file-exists-p flowchart-file-name)
      (find-file flowchart-file-name)
      )
    )
  )
;;(ghan-generate-r-pipeline-flowchart )

;;some small auxiliary fxns
(defun ghan-swapOperand(start end)
  "swap the operators in the two side of ="
  (interactive "r")
  (let ((selContent (buffer-substring-no-properties start end)))
    ;;    (message selContent)
    (delete-region start end)
    (goto-char start)
    (insert (string-join (reverse  (split-string selContent "="))  "=")))
  )
;;insert date and time
(defun ghan-insert-current-date ()
  (interactive)
       (insert (shell-command-to-string "echo -n $(date +%Y-%m-%d)")))
(provide 'pipeline)
;;; pipeline.el ends here

