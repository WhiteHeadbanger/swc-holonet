; =========================
; MODULE: holonet-router
; =========================

(load "holonet-sites")
(load "holonet-state")
(load "holonet-auth")
(load "holonet-utils")

(defun (sanitize-url raw)
  (let ((s (strtolower (trim raw))))
    (cond
      [(and
          (str_starts_with s ":")
          (str_ends_with s ":"))
        (join
          "/"
          (explode ":" (substr s 1 (- (strlen s) 2))))]
      [#t
        "404"])))

(defun (site-route slug endpoint)
  (concat
    (get-site-root slug)
    "/"
    endpoint))

(defun (resolve-route slug)
  ; already absolute
  (cond
    [(str_contains slug "/")
      slug]
    ; known global holosite root
    [(not (eq? (get-page-by-url slug) empty))
      slug]
    ; otherwise treat as relative
    [#t
      (concat current-page "/" slug)]))

(defun (route-raw slug)
  (let ((page (get-page-by-url slug)))
    (cond
      ; page missing
      [(eq? page empty)
        "404"]
      ; protected route
      [(and
          (page-protected-data? page)
          (not (site-authenticated? slug)))
        (route-raw
          (site-route slug "login"))]
      ; success
      [#t
        (save-var! current-page slug)
        page])))

(defun (route-with-history slug)
  (cond
    [(eq? slug current-page)
      (route-raw slug)]
    [#t
      (save-var!
        back-stack
        (cons current-page back-stack))
      (save-var!
        forward-stack
        '())
      (route-raw slug)]))

(defun (route url)
  (let ((clean (sanitize-url url)))
    (route-with-history
      (resolve-route clean))))


(module-export
 sanitize-url
 get-site-root
 site-route
 resolve-route
 route-raw
 route-with-history
 route
 )