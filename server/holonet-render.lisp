; =========================
; MODULE: holonet-render
; =========================

(load "holonet-sites")
(load "holonet-state")
(load "holonet-auth")
(load "holonet-router")
(load "holonet-context")

; =========================================================
; RENDER CORE
; =========================================================

(defun (render-page page ctx)
  (let ((html (nth-of page 1))
        (links (nth-of page 2))
        (inputs (nth-of page 3)))
    (say html)
    (render-links
      links
      ctx)
    (render-inputs
      inputs
      ctx)
    (render-nav
      ctx)
    (add-input
      "Enter Holoaddress (e.g. :home:)"
      (ctx-enter-url ctx))))

(defun (render-links links ctx)
  (cond
    [(eq? links empty)
      empty]
    [#t
      (let ((slug (car links)))
        (add-response
          (fmt "→ {slug}")
          (ctx-go-to ctx)
          (list slug)))
      (render-links
        (cdr links)
        ctx)]))

(defun (render-inputs inputs ctx)
  (cond
    [(eq? inputs empty)
      empty]
    [#t
      (let ((inp (car inputs)))
        (let ((action (car inp))
              (label (car (cdr inp))))
          (cond
            [(eq? action "login-password")
              (add-input
                label
                (ctx-login-input ctx))]
            [#t
              empty])))
      (render-inputs
        (cdr inputs)
        ctx)]))

(defun (render-nav ctx)
  (add-response
    "⬅ Back"
    (ctx-go-back ctx))

  (add-response
    "⌂ Home"
    (ctx-go-home ctx))

  (add-response
    "Forward ➡"
    (ctx-go-forward ctx))

  (cond
    [(site-authenticated? current-page)

      (add-response
        "Logout"
        (ctx-logout ctx))]

    [#t
      empty]))

(defun (render-404 ctx)
  (let ((page (get-page-by-url "404")))
    (cond
      [(eq? page empty)
        (say
          "Critical error: 404 page missing. Contact Alerith Grimm.")]
      [#t
        (render-page
          page
          ctx)])))

(module-export
 render-page
 render-404)