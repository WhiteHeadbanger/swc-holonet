; =========================
; MODULE: holonet-auth
; =========================

(load "holonet-sites")
(load "holonet-state")
(load "holonet-utils")

(defun (site-authenticated? slug)
  (let ((root (get-site-root slug)))
    (in? root authenticated-sites)))

(defun (authenticate-site slug)
  (let ((root (get-site-root slug)))
    (cond
      [(in? root authenticated-sites)
        empty]
      [#t
        (save-var!
          authenticated-sites
          (append-element
            authenticated-sites
            root))])))

(defun (login-password-check value)
  (cond
    ; successful login
    [(eq? value "1234")
      (authenticate-site current-page)
      #t]
    ; failed login
    [#t
      #f]))

(defun (page-protected-data? page)
  (nth-of page 4))

(defun (page-protected? slug)
  (let ((page (get-page-by-url slug)))
    (cond
      [(eq? page empty)
        #f]
      [#t
        (page-protected-data? page)])))

(module-export
 site-authenticated?
 authenticate-site
 login-password-check
 page-protected-data?
 page-protected?)