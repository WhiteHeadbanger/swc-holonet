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
  ;(dbg-pp "site-route slug: " slug "endpoint: " endpoint)
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

(defun (commit-navigation resolved-slug)
  (cond
    ; same page
    [(eq? resolved-slug current-page)
      empty]

    ; normal navigation
    [#t
      (save-var!
        back-stack
        (cons current-page back-stack))

      (save-var!
        forward-stack
        '())

      (save-var!
        current-page
        resolved-slug)]))

(defun (route url)
  (let ((clean (sanitize-url url)))
    (let ((resolved
            (resolve-page
              (resolve-route clean))))

      (commit-navigation
        (route-result-slug resolved))

      resolved)))

(defun (route-result-success? result)
  (nth-of result 0))

(defun (route-result-slug result)
  (nth-of result 1))

(defun (route-result-page result)
  (nth-of result 2))

(defun (make-route-result success slug page)
  (list success slug page))

(defun (resolve-page slug)
  ;(dbg-pp "resolve-page slug: " slug)
  (let ((page (get-page-by-url slug)))
    (cond
      ; page missing
      [(eq? page empty)
        (make-route-result
          #f
          "404"
          (get-page-by-url "404"))]

      ; protected route
      [(and
        (page-protected-data? page)
        (not (site-authenticated? slug)))
				
        (save-var!
          login-target
          slug)
       

        (resolve-page
          (site-route
            (get-site-root slug)
            "login"))]

      ; success
      [#t
        (make-route-result
          #t
          slug
          page)])))

(module-export
 site-route
 resolve-route
 resolve-page
 route-result-page
 route
 )