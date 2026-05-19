; =========================
; MODULE: holonet-state
; =========================
(defvar home-page ":home:") ; we use the full holoaddress here because (route url) calls sanitize-url, and sanitize-url returns 404 if colons are not present. #TODO fix this.
(defvar login-page "login")
(defvar dashboard-page "dashboard")

(defvar login-target
  (svar 'login-target empty))

(defvar current-page
  (evar 'current-page "home"))

(defvar back-stack
  (evar 'back-stack '()))

(defvar forward-stack
  (evar 'forward-stack '()))

(defvar authenticated-sites
  (svar 'authenticated-sites empty))

(module-export
  home-page
  login-page
  dashboard-page
  login-target
  current-page
  back-stack
  forward-stack
  authenticated-sites)