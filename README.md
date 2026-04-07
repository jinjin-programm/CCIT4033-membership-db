# Membership Database System

A SQLite-based membership management system for handling member records, membership fee payments, and sports event registrations. Built for the **CCIT4033 Introduction to Database Systems** group project.

## Project Overview

This system supports two user roles:

- **Admin** — Register members, update records, record payments, manage event registrations
- **Member** — Apply for membership, register for sports events, check membership status

## System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Membership System                     │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌──────────────┐   ┌──────────────┐   ┌─────────────┐ │
│  │  Admin UI    │   │  Member UI   │   │   Reports   │ │
│  │  (run.bat)   │   │  (run.bat)   │   │   (Views)   │ │
│  └──────┬───────┘   └──────┬───────┘   └──────┬──────┘ │
│         │                  │                   │        │
│  ┌──────┴──────────────────┴───────────────────┴──────┐ │
│  │              SQLite Database Engine                 │ │
│  ├────────────────────────────────────────────────────┤ │
│  │  Tables  │  Triggers  │  Views  │  Constraints    │ │
│  └────────────────────────────────────────────────────┘ │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## File Structure

```
Database group project/
├── init_database.sql      # Master script — builds the entire database
├── create_tables.sql      # Table definitions (DDL)
├── triggers.sql           # Business logic triggers
├── views_and_reports.sql  # Report views
├── sample_queries.sql     # Sample SELECT queries
├── build_and_test.py      # Automated build + test script (21 tests)
├── run.bat                # Windows interactive menu launcher
├── membership.db          # SQLite database file (generated)
├── Database Functions.md  # System requirements document
├── Project Specification.md
└── README.md              # This file
```

## Database Schema

### Tables

| Table | Description |
|---|---|
| `Admin` | Administrator accounts and roles |
| `Member` | Member records with status tracking |
| `Payment` | Membership fee payment transactions |
| `SportsEvent` | Sports events, activities, competitions |
| `EventRegistration` | Member-to-event registration links |

### ER Diagram

```
MEMBER ||--o{ PAYMENT : makes
MEMBER ||--o{ EVENT_REGISTRATION : registers
SPORTS_EVENT ||--o{ EVENT_REGISTRATION : receives
ADMIN ||--o{ MEMBER : manages
```

### Key Relationships

- One member → many payments
- One member → many event registrations
- One sports event → many registrations
- CASCADE DELETE on foreign keys

## Input Validation

The database enforces data integrity at the database level:

| Constraint | Rule |
|---|---|
| `CHECK (Email LIKE '%_@__%.__%')` | Valid email format |
| `CHECK (MembershipStatus IN (...))` | Status must be Active/Inactive/Expired/Suspended |
| `CHECK (PaymentAmount > 0)` | Payment must be positive |
| `CHECK (PaymentMethod IN (...))` | Valid payment method only |
| `UNIQUE (SID)` | Each member has a unique student/staff ID |
| `UNIQUE (MemberID, EventID)` | No duplicate event registrations |

## Triggers

| Trigger | Purpose |
|---|---|
| `trg_activate_member_on_payment` | Auto-set status to 'Active' when payment is recorded |
| `trg_check_active_before_registration` | Block event registration for inactive members |
| `trg_check_event_date_before_registration` | Block registration for past events |
| `trg_check_payment_date` | Block future-dated payments |
| `trg_unique_event_name` | Prevent duplicate events (same name + date) |

## Reports (Views)

| View | Description |
|---|---|
| `vw_MemberList` | Complete member list |
| `vw_MembershipStatus` | Member status with total payment summary |
| `vw_PaymentReport` | Payment transactions with member details |
| `vw_EventList` | Sports events with registration count |
| `vw_EventRegistrationReport` | Full registration details with member and event info |

## Quick Start

### Prerequisites

- **Python 3.x** (comes with built-in `sqlite3` module)
- **sqlite3** CLI (optional, for manual queries)

### Option 1: Automated Build & Test

```bash
python build_and_test.py
```

This creates `membership.db` and runs 21 automated tests.

### Option 2: Using sqlite3 CLI

```bash
# Initialize the database
sqlite3 membership.db < init_database.sql

# Run sample queries
sqlite3 -header -column membership.db < sample_queries.sql

# Open interactive shell
sqlite3 membership.db
```

### Option 3: Windows Interactive Menu

```cmd
run.bat
```

Provides a menu-driven interface for initializing, querying, and viewing reports.

## Normalization

The database design satisfies **Third Normal Form (3NF)**:

- **1NF** — All fields are atomic, no repeating groups
- **2NF** — All non-key attributes depend on the whole primary key
- **3NF** — No transitive dependencies; member, event, and payment data are separated

## Business Rules

1. Each member must have a unique Member ID and SID
2. Each payment is linked to exactly one member
3. A member can make many payments over time
4. A member can register for many sports events
5. Only active members can register for events
6. Membership status auto-updates to "Active" upon payment
7. Only authorized admins can manage records

## Testing

Run the test suite:

```bash
python build_and_test.py
```

Tests cover:
- Input validation (8 tests)
- Trigger behavior (7 tests)
- Foreign key cascade (1 test)
- View functionality (5 tests)

## Project Info

- **Course:** CCIT4033 — Introduction to Database Systems
- **Database Engine:** SQLite
- **Language:** SQL + Python (for testing/automation)
- **Normalization:** 3NF
