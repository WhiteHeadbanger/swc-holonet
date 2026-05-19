# swc-holonet

A Holonet system for the MMORPG Star Wars Combine.

## Setup

1. Open [Script Modules](https://www.swcombine.com/members/scripts/).
2. Create one script module for each script inside the `server` directory of this repository.
3. Make sure each module uses the exact same filename as the original script.
4. Copy the script from the `client` directory into a droid or NPC script in-game.

---

## Usage

1. Speak to the droid or NPC running the client script.
2. Use the input field to navigate between holosites.

### Holoaddresses

Holosites use holoaddresses in the following format:

```text
:holoaddress:
```

Examples:

```text
:home:
:neon:
:orange:
```

You can navigate using:

- Relative holoaddresses:
  
  ```text
  :dashboard:
  ```

- Absolute holoaddresses:
  
  ```text
  :home:dashboard:
  ```

### Navigation Buttons

- `Home` → Goes to `:home:`
- `Back` → Moves backward in navigation history
- `Forward` → Moves forward in navigation history

---

## Authentication System

The Holonet includes a session-based authentication system for protected holosites.

Each holosite manages authentication independently. Logging into one holosite does not authenticate you on another.

### Example Login Flow

1. Navigate to:

   ```text
   :home:login:
   ```

2. Enter the password:

   ```text
   1234
   ```

3. After logging in, you will be redirected to:

   ```text
   :home:dashboard:
   ```

### Logging Into Another Holosite

Authentication must be repeated for every holosite.

Example:

1. Navigate to:

   ```text
   :neon:
   ```

2. Then open:

   ```text
   :login:
   ```

3. Enter the holosite password.

4. After authentication, you will be redirected to:

   ```text
   :neon:dashboard:
   ```

### Accessing Dashboards

You can return to a holosite dashboard either by:

```text
:home:
```

followed by:

```text
:dashboard:
```

or directly with:

```text
:home:dashboard:
```

### Logout Behavior

- Each holosite maintains its own login state.
- Logging out from a holosite only logs you out from that specific site.
- Logout is available from any part of an authenticated holosite.
- After logout, you are redirected to the holosite root page.
- Attempting to access a protected dashboard without authentication redirects you to the corresponding login page.
- Sessions are cleared when you stop talking to the droid or NPC.

---

## Notes

- The system is still in development.
- Multiplayer behavior has not been fully tested yet.
- Passwords are currently hardcoded.
- A future slicing/hacking system for holosites is planned but has not been implemented yet.