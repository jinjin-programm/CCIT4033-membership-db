"""
Membership System - Build and Test Script
==========================================
This script initializes the database and runs all tests.
Usage: python build_and_test.py
"""

import sqlite3
import os
import sys

DB_NAME = "membership.db"

def read_sql_file(filename):
    with open(filename, 'r', encoding='utf-8') as f:
        return f.read()

def build_database():
    print("=" * 60)
    print("  BUILDING DATABASE")
    print("=" * 60)

    if os.path.exists(DB_NAME):
        try:
            os.remove(DB_NAME)
            print(f"[OK] Removed existing {DB_NAME}")
        except PermissionError:
            print(f"[WARN] {DB_NAME} is locked, overwriting instead")
            conn = sqlite3.connect(DB_NAME)
            conn.executescript("DROP TABLE IF EXISTS EventRegistration; DROP TABLE IF EXISTS Payment; DROP TABLE IF EXISTS SportsEvent; DROP TABLE IF EXISTS Member; DROP TABLE IF EXISTS Admin; DROP VIEW IF EXISTS vw_MemberList; DROP VIEW IF EXISTS vw_MembershipStatus; DROP VIEW IF EXISTS vw_PaymentReport; DROP VIEW IF EXISTS vw_EventList; DROP VIEW IF EXISTS vw_EventRegistrationReport; DROP TRIGGER IF EXISTS trg_activate_member_on_payment; DROP TRIGGER IF EXISTS trg_check_active_before_registration; DROP TRIGGER IF EXISTS trg_check_event_date_before_registration; DROP TRIGGER IF EXISTS trg_check_payment_date; DROP TRIGGER IF EXISTS trg_unique_event_name;")
            conn.close()
    else:
        conn = sqlite3.connect(DB_NAME)

    if 'conn' not in dir():
        conn = sqlite3.connect(DB_NAME)

    files = ['create_tables.sql', 'triggers.sql', 'views_and_reports.sql']
    for f in files:
        if not os.path.exists(f):
            print(f"[ERROR] {f} not found!")
            sys.exit(1)
        conn.executescript(read_sql_file(f))
        print(f"[OK] Executed {f}")

    conn.execute('PRAGMA foreign_keys = ON')
    conn.close()
    print(f"\n[OK] Database '{DB_NAME}' created successfully.\n")

def run_tests():
    print("=" * 60)
    print("  RUNNING TESTS")
    print("=" * 60)

    conn = sqlite3.connect(DB_NAME)
    conn.execute('PRAGMA foreign_keys = ON')

    passed = 0
    failed = 0
    total = 0

    def test(name, fn):
        nonlocal passed, failed, total
        total += 1
        try:
            fn()
            print(f"  [PASS] {name}")
            passed += 1
        except Exception as e:
            print(f"  [FAIL] {name}: {e}")
            failed += 1

    def expect_error(name, fn):
        nonlocal passed, failed, total
        total += 1
        try:
            fn()
            print(f"  [FAIL] {name} (expected error, got none)")
            failed += 1
        except Exception:
            print(f"  [PASS] {name}")
            passed += 1

    # --- Input Validation ---
    print("\n--- Input Validation ---")

    expect_error("Reject invalid email format",
        lambda: conn.execute("INSERT INTO Member (FullName, SID, Email, JoinDate, MembershipStatus) VALUES ('T', 'S001', 'bademail', '2026-01-01', 'Inactive')"))

    expect_error("Reject invalid membership status",
        lambda: conn.execute("INSERT INTO Member (FullName, SID, Email, JoinDate, MembershipStatus) VALUES ('T', 'S001', 'a@b.com', '2026-01-01', 'Unknown')"))

    expect_error("Reject empty full name",
        lambda: conn.execute("INSERT INTO Member (FullName, SID, Email, JoinDate, MembershipStatus) VALUES ('', 'S001', 'a@b.com', '2026-01-01', 'Inactive')"))

    expect_error("Reject duplicate SID",
        lambda: (conn.execute("INSERT INTO Member (FullName, SID, Email, JoinDate, MembershipStatus) VALUES ('A', 'S100', 'a@b.com', '2026-01-01', 'Inactive')"),
                 conn.execute("INSERT INTO Member (FullName, SID, Email, JoinDate, MembershipStatus) VALUES ('B', 'S100', 'c@d.com', '2026-01-01', 'Inactive')"))[-1])

    # Insert valid member
    conn.execute("INSERT INTO Member (FullName, SID, Email, JoinDate, MembershipStatus) VALUES ('Test User', 'S001', 'test@test.com', '2026-01-01', 'Inactive')")

    expect_error("Reject negative payment amount",
        lambda: conn.execute("INSERT INTO Payment (MemberID, PaymentAmount, PaymentDate, PaymentMethod) VALUES (1, -50, '2026-01-01', 'Cash')"))

    expect_error("Reject zero payment amount",
        lambda: conn.execute("INSERT INTO Payment (MemberID, PaymentAmount, PaymentDate, PaymentMethod) VALUES (1, 0, '2026-01-01', 'Cash')"))

    expect_error("Reject invalid payment method",
        lambda: conn.execute("INSERT INTO Payment (MemberID, PaymentAmount, PaymentDate, PaymentMethod) VALUES (1, 100, '2026-01-01', 'Bitcoin')"))

    expect_error("Reject invalid admin role",
        lambda: conn.execute("INSERT INTO Admin (AdminName, Email, Role) VALUES ('Admin', 'admin@test.com', 'Hacker')"))

    # --- Triggers ---
    print("\n--- Triggers ---")

    # Auto-activate on payment
    conn.execute("INSERT INTO Payment (MemberID, PaymentAmount, PaymentDate, PaymentMethod) VALUES (1, 200, '2026-01-15', 'Cash')")
    status = conn.execute("SELECT MembershipStatus FROM Member WHERE MemberID = 1").fetchone()[0]
    total += 1
    if status == 'Active':
        print("  [PASS] Auto-activate member on payment")
        passed += 1
    else:
        print(f"  [FAIL] Auto-activate member on payment (got '{status}')")
        failed += 1

    # Block inactive member registration
    conn.execute("INSERT INTO Member (FullName, SID, Email, JoinDate, MembershipStatus) VALUES ('Inactive User', 'S002', 'inactive@test.com', '2026-01-01', 'Inactive')")
    conn.execute("INSERT INTO SportsEvent (EventName, EventDate, EventLocation) VALUES ('Marathon', '2026-12-01', 'Gym')")

    expect_error("Block inactive member from event registration",
        lambda: conn.execute("INSERT INTO EventRegistration (MemberID, EventID, RegistrationDate) VALUES (2, 1, '2026-01-20')"))

    # Allow active member registration
    total += 1
    try:
        conn.execute("INSERT INTO EventRegistration (MemberID, EventID, RegistrationDate) VALUES (1, 1, '2026-01-20')")
        print("  [PASS] Allow active member event registration")
        passed += 1
    except Exception as e:
        print(f"  [FAIL] Allow active member event registration: {e}")
        failed += 1

    expect_error("Block duplicate member email",
        lambda: conn.execute("INSERT INTO Member (FullName, SID, Email, JoinDate, MembershipStatus) VALUES ('Dup', 'S003', 'test@test.com', '2026-01-01', 'Inactive')"))

    expect_error("Block duplicate event registration (same member+event)",
        lambda: conn.execute("INSERT INTO EventRegistration (MemberID, EventID, RegistrationDate) VALUES (1, 1, '2026-01-21')"))

    conn.execute("INSERT INTO Admin (AdminName, Email, Role) VALUES ('Admin One', 'admin@test.com', 'General Admin')")

    expect_error("Block duplicate admin email",
        lambda: conn.execute("INSERT INTO Admin (AdminName, Email, Role) VALUES ('Admin Two', 'admin@test.com', 'General Admin')"))

    expect_error("Block duplicate event name on same date",
        lambda: conn.execute("INSERT INTO SportsEvent (EventName, EventDate, EventLocation) VALUES ('Marathon', '2026-12-01', 'Pool')"))

    # --- Foreign Key Cascade ---
    print("\n--- Foreign Key Cascade ---")

    conn.execute("INSERT INTO Member (FullName, SID, Email, JoinDate, MembershipStatus) VALUES ('Cascade Test', 'S003', 'cascade@test.com', '2026-01-01', 'Inactive')")
    conn.execute("INSERT INTO Payment (MemberID, PaymentAmount, PaymentDate, PaymentMethod) VALUES (3, 100, '2026-02-01', 'Cash')")
    payment_count_before = conn.execute("SELECT COUNT(*) FROM Payment WHERE MemberID = 3").fetchone()[0]
    conn.execute("DELETE FROM Member WHERE MemberID = 3")
    payment_count_after = conn.execute("SELECT COUNT(*) FROM Payment WHERE MemberID = 3").fetchone()[0]
    total += 1
    if payment_count_before == 1 and payment_count_after == 0:
        print("  [PASS] CASCADE DELETE on Payment when Member deleted")
        passed += 1
    else:
        print(f"  [FAIL] CASCADE DELETE (before={payment_count_before}, after={payment_count_after})")
        failed += 1

    # --- Views ---
    print("\n--- Views ---")

    views = {
        'vw_MemberList': 'Member list report',
        'vw_MembershipStatus': 'Membership status with payment summary',
        'vw_PaymentReport': 'Payment transactions with member details',
        'vw_EventList': 'Sports events with registration count',
        'vw_EventRegistrationReport': 'Event registrations with member and event details',
    }

    for view, desc in views.items():
        total += 1
        try:
            rows = conn.execute(f"SELECT * FROM {view}").fetchall()
            print(f"  [PASS] {view} ({desc}) - {len(rows)} rows")
            passed += 1
        except Exception as e:
            print(f"  [FAIL] {view}: {e}")
            failed += 1

    conn.close()

    # --- Summary ---
    print("\n" + "=" * 60)
    print(f"  RESULTS: {passed}/{total} passed, {failed} failed")
    print("=" * 60)

    if failed > 0:
        print("\n[WARNING] Some tests failed. Review errors above.")
        return False
    else:
        print("\n[OK] All tests passed!")
        return True

def run_sample_queries():
    print("\n" + "=" * 60)
    print("  RUNNING SAMPLE QUERIES")
    print("=" * 60)

    conn = sqlite3.connect(DB_NAME)
    conn.execute('PRAGMA foreign_keys = ON')

    queries = {
        "Query 1: All Members": "SELECT MemberID, FullName, SID, PhoneNo, Email, MembershipStatus FROM Member",
        "Query 2: Payment Records": "SELECT PaymentID, MemberID, PaymentAmount, PaymentDate, PaymentMethod FROM Payment",
        "Query 3: Sports Events": "SELECT EventID, EventName, EventDate, EventLocation FROM SportsEvent",
        "Query 4: Event Registrations": "SELECT er.RegistrationID, m.FullName, se.EventName, er.RegistrationDate FROM EventRegistration er JOIN Member m ON er.MemberID = m.MemberID JOIN SportsEvent se ON er.EventID = se.EventID",
        "Query 5: Active Members": "SELECT MemberID, FullName, MembershipStatus FROM Member WHERE MembershipStatus = 'Active'",
    }

    for title, sql in queries.items():
        print(f"\n--- {title} ---")
        try:
            cursor = conn.execute(sql)
            columns = [desc[0] for desc in cursor.description]
            rows = cursor.fetchall()
            print(f"  Columns: {', '.join(columns)}")
            print(f"  Rows: {len(rows)}")
            for row in rows:
                print(f"    {row}")
        except Exception as e:
            print(f"  [ERROR] {e}")

    conn.close()

if __name__ == "__main__":
    build_database()
    success = run_tests()
    run_sample_queries()

    if not success:
        sys.exit(1)
