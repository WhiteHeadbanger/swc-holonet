; =========================
; CLIENT DROID SCRIPT
; =========================

(load "holonet-sites")
(load "holonet-state")
(load "holonet-router")
(load "holonet-auth")
(load "holonet-render")

; =========================================================
; NAVIGATION CALLBACKS
; =========================================================

(defun go-browser-home
  (render-route-result
    (route-with-history "home")))

(defun logout
  (let ((root (get-site-root current-page)))
    (save-var!
      authenticated-sites
      (list-remove root authenticated-sites))
    (render-route-result
      (route-raw root))))

(defun go-back
  (cond
    [(eq? back-stack empty)
      (render-route-result
        (route-raw current-page))]
    [#t
      (let ((prev (car back-stack))
            (rest (cdr back-stack)))
        (save-var! back-stack rest)
        (save-var!
          forward-stack
          (cons current-page forward-stack))
        (render-route-result
          (route-raw prev)))]))

(defun go-forward
  (cond
    [(eq? forward-stack empty)
      (render-route-result
        (route-raw current-page))]
    [#t
      (let ((next (car forward-stack))
            (rest (cdr forward-stack)))
        (save-var! forward-stack rest)
        (save-var!
          back-stack
          (cons current-page back-stack))
        (render-route-result
          (route-raw next)))]))

(defun (go-to slug)
  (render-route-result
    (route-with-history slug)))

; =========================================================
; INPUT CALLBACKS
; =========================================================

(defun (enter-url addr)
  (render-route-result
    (route addr)))

(defun (login-password-input value)
  (cond
    ; success
    [(login-password-check value)
      (render-route-result
        (route-raw
          (site-route
            current-page
            "dashboard")))]
    ; failure
    [#t
      (render-route-result
        (route-raw
          (site-route
            current-page
            "login")))]))

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
  (cond
    [(eq? result "404")
      (render-404 holo-ctx)]
    [#t
      (render-page result holo-ctx)]))

; =========================================================
; ENTRY POINT
; =========================================================

(defun start
  (render-route-result
    (route-raw current-page)))