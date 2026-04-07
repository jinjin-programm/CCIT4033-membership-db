# Coding Diary — CCIT4033 Membership Database System

## 2026-04-07

### Bug 1: `DATE('now')` in CHECK constraints fails in SQLite
**Error:** `sqlite3.OperationalError: non-deterministic use of date() in a CHECK constraint`
**Cause:** SQLite does not allow non-deterministic functions (like `DATE('now')`) inside `CHECK` constraints.
**Fix:** Removed `CHECK (JoinDate <= DATE('now'))`, `CHECK (PaymentDate <= DATE('now'))`, and `CHECK (RegistrationDate <= DATE('now'))` from table definitions. Date validation is handled by triggers (`trg_check_payment_date`, `trg_check_event_date_before_registration`) instead.
**Files changed:** `create_tables.sql`

### Bug 2: `executescript()` silently resets `PRAGMA foreign_keys`
**Error:** Foreign key constraints were not enforced during testing — CASCADE DELETE appeared to fail.
**Cause:** `sqlite3.executescript()` issues an implicit `COMMIT` before running, which resets `PRAGMA foreign_keys` to `OFF` (SQLite default).
**Fix:** Always re-run `conn.execute('PRAGMA foreign_keys = ON')` immediately after every `executescript()` call.
**Files changed:** `build_and_test.py`

### Bug 3: `membership.db` file locked on Windows (PermissionError 32)
**Error:** `PermissionError: [WinError 32] The process cannot access the file because it is being used by another process`
**Cause:** DB Browser for SQLite (or a lingering Python process) held an open connection to `membership.db`.
**Fix:** Closed DB Browser. Also added fallback logic to `build_and_test.py` to drop and recreate tables if the file is locked instead of deleting it.
**Files changed:** `build_and_test.py`

### Major Change: Email uniqueness — triggers → UNIQUE constraints
**Before:** `trg_unique_admin_email` and `trg_unique_member_email` triggers checked for duplicate emails via subqueries.
**After:** Added `UNIQUE` constraint directly on `Admin.Email` and `Member.Email` columns.
**Reason:** `UNIQUE` constraints are standard SQL, faster (uses index), and more readable than trigger-based workarounds. Removed 2 triggers (7 → 5).
**Files changed:** `create_tables.sql`, `triggers.sql`, `init_database.sql`, `README.md`, `build_and_test.py`

### Major Change: `init_database.sql` made self-contained
**Before:** Used `.read` directives to include other SQL files (not supported by `sqlite3` CLI in all environments).
**After:** All DDL, triggers, and views are written inline in a single file.
**Reason:** Ensures `sqlite3 membership.db < init_database.sql` works reliably everywhere.
**Files changed:** `init_database.sql`
