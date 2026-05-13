; =========================
; MODULE: holonet-context
; =========================

(defun (ctx-render-page ctx)
  (nth-of ctx 0))

(defun (ctx-render-404 ctx)
  (nth-of ctx 1))

(defun (ctx-go-back ctx)
  (nth-of ctx 2))

(defun (ctx-go-home ctx)
  (nth-of ctx 3))

(defun (ctx-go-forward ctx)
  (nth-of ctx 4))

(defun (ctx-go-to ctx)
  (nth-of ctx 5))

(defun (ctx-enter-url ctx)
  (nth-of ctx 6))

(defun (ctx-login-input ctx)
  (nth-of ctx 7))

(defun (ctx-logout ctx)
  (nth-of ctx 8))

(module-export
  ctx-render-page
  ctx-render-404
  ctx-go-back
  ctx-go-home
  ctx-go-forward
  ctx-go-to
  ctx-enter-url
  ctx-login-input
  ctx-logout)