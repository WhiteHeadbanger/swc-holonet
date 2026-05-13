; =========================
; MODULE: holonet-utils
; =========================

(defun (get-site-root slug)
  (let ((parts (explode "/" slug)))
    (car parts)))

(module-export
 get-site-root)