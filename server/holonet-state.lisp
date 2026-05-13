; =========================
; MODULE: holonet-state
; =========================

(defvar current-page
  (evar 'current-page "home"))

(defvar back-stack
  (evar 'back-stack '()))

(defvar forward-stack
  (evar 'forward-stack '()))

(defvar authenticated-sites
  (svar 'authenticated-sites empty))

(module-export
  current-page
  back-stack
  forward-stack
  authenticated-sites)