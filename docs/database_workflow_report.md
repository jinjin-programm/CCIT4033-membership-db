# Membership Database Workflow Analysis

## 1. Project Background

This project is a SQLite-based membership database system for the course **Introduction to Database Systems / 資料庫系統概論**.

The system stores and manages:
- member records
- payment records
- sports event records
- event registrations
- admin records

The main idea is simple: the database does not only save data, it also enforces rules so that bad data cannot enter the system.

## 2. Core Database Structure

### Tables

| Table | Purpose |
|---|---|
| `Member` | Stores member identity and membership status |
| `Payment` | Stores payment transactions |
| `SportsEvent` | Stores event information |
| `EventRegistration` | Connects members to events |
| `Admin` | Stores admin information and roles |

### Relationships

- One member can make many payments.
- One member can register for many events.
- One event can have many member registrations.
- Each payment belongs to one member.
- Each event registration links one member and one event.

## 3. How the System Works

The workflow is:

1. Create the database schema.
2. Insert or update data.
3. Let constraints check basic validity.
4. Let triggers handle business rules.
5. Use views to generate reports.

### 3.1 Table Creation

The file `init_database.sql` creates all tables first.

This means the database already knows the structure before any data is added.

### 3.2 Data Input

Users or scripts can insert:
- new members
- payment records
- sports events
- event registrations

At this point, the database immediately checks whether the data is valid.

### 3.3 Constraint Checking

Basic validation is handled by SQL constraints:

| Constraint Type | What it does |
|---|---|
| `NOT NULL` | Prevents empty required fields |
| `CHECK` | Validates rules like email format or payment amount |
| `UNIQUE` | Prevents duplicate values |
| `FOREIGN KEY` | Ensures related records exist |

Examples from this project:
- `Email` must look like a real email address.
- `PaymentAmount` must be greater than 0.
- `SID` must be unique.
- One member cannot register for the same event twice.

### 3.4 Trigger Processing

Triggers are used when a rule needs automatic action or cross-table checking.

| Trigger | Function |
|---|---|
| `trg_activate_member_on_payment` | Change member status to `Active` after payment |
| `trg_check_active_before_registration` | Block non-active members from registering |
| `trg_check_event_date_before_registration` | Block registration for past events |
| `trg_check_payment_date` | Block future payment dates |
| `trg_unique_event_name` | Block duplicate event name + date |

Triggers are important because basic constraints alone cannot do everything.

### 3.5 View-Based Reporting

Views are saved queries used for reports:

| View | Purpose |
|---|---|
| `vw_MemberList` | Shows all member details |
| `vw_MembershipStatus` | Shows member status and total payment summary |
| `vw_PaymentReport` | Shows payment records with member details |
| `vw_EventList` | Shows events with registration counts |
| `vw_EventRegistrationReport` | Shows full registration details |

## 4. Why Triggers Are Used Instead of Only Constraints

This is the key idea of the project.

### Constraints are good for simple rules

They can check things like:
- empty value prevention
- valid email pattern
- positive payment amount
- uniqueness

### Triggers are needed for dynamic rules

They can:
- update another table automatically
- check values from other tables
- stop an action before it happens

### Example

When a payment is inserted:
1. the payment date is checked
2. the payment amount is checked
3. the member status is automatically updated to `Active`

This is why triggers are the right tool here.

## 5. Sample Workflow Examples

### Example A: Member pays fee

```text
Insert payment
   -> check payment date
   -> save payment
   -> trigger updates member status to Active
```

### Example B: Member registers for event

```text
Insert event registration
   -> check member status
   -> check event date
   -> save registration if valid
```

### Example C: View report

```text
Open a view
   -> database joins tables automatically
   -> report is shown to user
```

## 6. Project Design Strengths

- Data rules are enforced at the database level.
- The system is independent of programming language.
- Reports are easy to generate with views.
- The design is suitable for a database systems course because it demonstrates real SQL features.

## 7. Limitations and Future Improvements

- The admin side is currently more like stored data than a full login system.
- Status values are still stored as text, so stronger reference tables could be added.
- More report views could be created for summary analytics.
- An audit log could be added to track changes.

## 8. Conclusion

This project uses SQLite tables, constraints, triggers, and views to create a complete membership management workflow.

The most important idea is that the database is not passive storage only. It actively protects data quality and automates important business rules.

For a beginner, the easiest way to remember it is:
- tables store data
- constraints block obvious bad data
- triggers automate rules
- views present results clearly
