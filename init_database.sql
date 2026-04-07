-- ============================================================
-- Membership System — Master Initialization Script
-- Run this file to create the entire database from scratch.
--
-- Usage:
--   sqlite3 membership.db < init_database.sql
-- ============================================================

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- ============================================================
-- Step 1: Create all tables
-- ============================================================

CREATE TABLE Admin (
    AdminID     INTEGER PRIMARY KEY AUTOINCREMENT,
    AdminName   VARCHAR(100) NOT NULL,
    Email       VARCHAR(100) NOT NULL,
    PhoneNo     VARCHAR(20),
    Role        VARCHAR(50)  NOT NULL,
    CHECK (LENGTH(AdminName) > 0),
    CHECK (Email LIKE '%_@__%.__%'),
    CHECK (Role IN ('Project Leader', 'Report Writer', 'User Representative', 'Quality Assurance', 'Database Designer', 'SQL Programmer', 'General Admin'))
);

CREATE TABLE Member (
    MemberID         INTEGER PRIMARY KEY AUTOINCREMENT,
    FullName         VARCHAR(100) NOT NULL,
    SID              VARCHAR(30)  NOT NULL UNIQUE,
    PhoneNo          VARCHAR(20),
    Email            VARCHAR(100) NOT NULL,
    Address          VARCHAR(255),
    JoinDate         DATE         NOT NULL,
    MembershipStatus VARCHAR(30)  NOT NULL DEFAULT 'Inactive',
    CHECK (LENGTH(FullName) > 0),
    CHECK (Email LIKE '%_@__%.__%'),
    CHECK (MembershipStatus IN ('Active', 'Inactive', 'Expired', 'Suspended'))
);

CREATE TABLE Payment (
    PaymentID     INTEGER PRIMARY KEY AUTOINCREMENT,
    MemberID      INTEGER        NOT NULL,
    PaymentAmount DECIMAL(10,2)  NOT NULL,
    PaymentDate   DATE           NOT NULL,
    PaymentMethod VARCHAR(50)    NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CHECK (PaymentAmount > 0),
    CHECK (PaymentMethod IN ('Cash', 'Credit Card', 'Debit Card', 'Bank Transfer', 'PayPal', 'FPS', 'Other'))
);

CREATE TABLE SportsEvent (
    EventID       INTEGER PRIMARY KEY AUTOINCREMENT,
    EventName     VARCHAR(100) NOT NULL,
    EventDate     DATE         NOT NULL,
    EventLocation VARCHAR(100) NOT NULL,
    CHECK (LENGTH(EventName) > 0),
    CHECK (LENGTH(EventLocation) > 0)
);

CREATE TABLE EventRegistration (
    RegistrationID   INTEGER PRIMARY KEY AUTOINCREMENT,
    MemberID         INTEGER NOT NULL,
    EventID          INTEGER NOT NULL,
    RegistrationDate DATE    NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (EventID) REFERENCES SportsEvent(EventID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    UNIQUE (MemberID, EventID)
);

-- ============================================================
-- Step 2: Create triggers for validation and auto-updates
-- ============================================================

CREATE TRIGGER IF NOT EXISTS trg_activate_member_on_payment
AFTER INSERT ON Payment
BEGIN
    UPDATE Member
    SET MembershipStatus = 'Active'
    WHERE MemberID = NEW.MemberID
      AND MembershipStatus IN ('Inactive', 'Expired');
END;

CREATE TRIGGER IF NOT EXISTS trg_check_active_before_registration
BEFORE INSERT ON EventRegistration
BEGIN
    SELECT CASE
        WHEN (SELECT MembershipStatus FROM Member WHERE MemberID = NEW.MemberID) != 'Active'
        THEN RAISE(ABORT, 'Error: Only active members can register for events.')
    END;
END;

CREATE TRIGGER IF NOT EXISTS trg_check_event_date_before_registration
BEFORE INSERT ON EventRegistration
BEGIN
    SELECT CASE
        WHEN (SELECT EventDate FROM SportsEvent WHERE EventID = NEW.EventID) < NEW.RegistrationDate
        THEN RAISE(ABORT, 'Error: Cannot register for an event that has already passed.')
    END;
END;

CREATE TRIGGER IF NOT EXISTS trg_check_payment_date
BEFORE INSERT ON Payment
BEGIN
    SELECT CASE
        WHEN NEW.PaymentDate > DATE('now')
        THEN RAISE(ABORT, 'Error: Payment date cannot be in the future.')
    END;
END;

CREATE TRIGGER IF NOT EXISTS trg_unique_admin_email
BEFORE INSERT ON Admin
BEGIN
    SELECT CASE
        WHEN (SELECT COUNT(*) FROM Admin WHERE Email = NEW.Email) > 0
        THEN RAISE(ABORT, 'Error: Admin email already exists.')
    END;
END;

CREATE TRIGGER IF NOT EXISTS trg_unique_member_email
BEFORE INSERT ON Member
BEGIN
    SELECT CASE
        WHEN (SELECT COUNT(*) FROM Member WHERE Email = NEW.Email) > 0
        THEN RAISE(ABORT, 'Error: Member email already exists.')
    END;
END;

CREATE TRIGGER IF NOT EXISTS trg_unique_event_name
BEFORE INSERT ON SportsEvent
BEGIN
    SELECT CASE
        WHEN (SELECT COUNT(*) FROM SportsEvent WHERE EventName = NEW.EventName AND EventDate = NEW.EventDate) > 0
        THEN RAISE(ABORT, 'Error: An event with this name and date already exists.')
    END;
END;

-- ============================================================
-- Step 3: Create views for reports
-- ============================================================

CREATE VIEW IF NOT EXISTS vw_MemberList AS
SELECT
    m.MemberID,
    m.FullName,
    m.SID,
    m.PhoneNo,
    m.Email,
    m.Address,
    m.JoinDate,
    m.MembershipStatus
FROM Member m
ORDER BY m.MemberID;

CREATE VIEW IF NOT EXISTS vw_MembershipStatus AS
SELECT
    m.MemberID,
    m.FullName,
    m.SID,
    m.MembershipStatus,
    m.JoinDate,
    COALESCE(SUM(p.PaymentAmount), 0) AS TotalPaid,
    COUNT(p.PaymentID) AS PaymentCount
FROM Member m
LEFT JOIN Payment p ON m.MemberID = p.MemberID
GROUP BY m.MemberID, m.FullName, m.SID, m.MembershipStatus, m.JoinDate
ORDER BY m.MemberID;

CREATE VIEW IF NOT EXISTS vw_PaymentReport AS
SELECT
    p.PaymentID,
    p.MemberID,
    m.FullName,
    m.SID,
    p.PaymentAmount,
    p.PaymentDate,
    p.PaymentMethod
FROM Payment p
JOIN Member m ON p.MemberID = m.MemberID
ORDER BY p.PaymentDate DESC, p.PaymentID;

CREATE VIEW IF NOT EXISTS vw_EventList AS
SELECT
    se.EventID,
    se.EventName,
    se.EventDate,
    se.EventLocation,
    COUNT(er.RegistrationID) AS RegisteredCount
FROM SportsEvent se
LEFT JOIN EventRegistration er ON se.EventID = er.EventID
GROUP BY se.EventID, se.EventName, se.EventDate, se.EventLocation
ORDER BY se.EventDate;

CREATE VIEW IF NOT EXISTS vw_EventRegistrationReport AS
SELECT
    er.RegistrationID,
    er.MemberID,
    m.FullName AS MemberName,
    m.SID,
    er.EventID,
    se.EventName,
    se.EventDate,
    se.EventLocation,
    er.RegistrationDate
FROM EventRegistration er
JOIN Member m ON er.MemberID = m.MemberID
JOIN SportsEvent se ON er.EventID = se.EventID
ORDER BY se.EventDate, er.RegistrationID;
