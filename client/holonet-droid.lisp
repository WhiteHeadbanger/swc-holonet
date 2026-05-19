; =========================
; CLIENT DROID SCRIPT
; =========================

(load "holonet-sites")
(load "holonet-state")
(load "holonet-router")
(load "holonet-auth")
(load "holonet-render")
(load "holonet-utils")

; =========================================================
; NAVIGATION CALLBACKS
; =========================================================

(defun go-browser-home
  (render-route-result
    (route home-page)))

(defun logout
  (let ((root (get-site-root current-page)))
    (save-var!
      authenticated-sites
      (list-remove root authenticated-sites))

    (render-route-result
      (resolve-page root))))

(defun go-back
  (cond
    [(eq? back-stack empty)
      (render-route-result
        (resolve-page current-page))]
    [#t
      (let ((prev (car back-stack))
            (rest (cdr back-stack)))

        (save-var! back-stack rest)

        (save-var!
          forward-stack
          (cons current-page forward-stack))

        (save-var!
          current-page
          prev)

        (render-route-result
          (resolve-page prev)))]))

(defun go-forward
  (cond
    [(eq? forward-stack empty)
      (render-route-result
        (resolve-page current-page))]
    [#t
      (let ((next (car forward-stack))
            (rest (cdr forward-stack)))

        (save-var! forward-stack rest)

        (save-var!
          back-stack
          (cons current-page back-stack))

        (save-var!
          current-page
          next)

        (render-route-result
          (resolve-page next)))]))

(defun (go-to slug)
  (render-route-result
    (route slug)))

; =========================================================
; INPUT CALLBACKS
; =========================================================

(defun (enter-url addr)
  (render-route-result
    (route addr)))

(defun (login-password-input value)
  (cond
    ; success
    [(login-password-check value) ;holonet-auth

      (let ((target
        (concat ; create a new string because otherwise target becomes a new alias for login-target, and as such it will be just a reference instead of a new immutable value.
          ""
          (cond
            [(eq? login-target empty)
              (site-route
                (get-site-root current-page)
                dashboard-page)]

            [#t
              login-target]))))

        (save-var!
          login-target
          empty)
           
				;(dbg-pp "TARGET: " target)
           
        (render-route-result
          (resolve-page target)))]

    ; failure
    [#t
      (render-route-result
        (resolve-page
          (site-route
            (get-site-root current-page)
            login-page)))]))

; =========================================================
; HOLO CONTEXT
; =========================================================

(defvar holo-ctx
  (list
    render-page ; 0
    render-404 ; 1
    go-back ; 2
    go-browser-home ; 3
    go-forward ; 4
    go-to ; 5
    enter-url ; 6
    login-password-input ; 7
    logout)) ; 8

(defun (render-route-result result)
  (render-page ;holonet-render
    (route-result-page result) ;holonet-router
    holo-ctx))

; =========================================================
; ENTRY POINT
; =========================================================

(defun start
  (render-route-result ;holonet-droid
    (resolve-page current-page))) ;holonet-router