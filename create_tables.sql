-- ============================================================
-- Membership System — CREATE TABLE Statements
-- Database: SQLite
-- ============================================================

PRAGMA foreign_keys = ON;

-- ============================================================
-- 1. Admin Table
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

-- ============================================================
-- 2. Member Table
-- ============================================================
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

-- ============================================================
-- 3. Payment Table
-- ============================================================
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

-- ============================================================
-- 4. SportsEvent Table
-- ============================================================
CREATE TABLE SportsEvent (
    EventID       INTEGER PRIMARY KEY AUTOINCREMENT,
    EventName     VARCHAR(100) NOT NULL,
    EventDate     DATE         NOT NULL,
    EventLocation VARCHAR(100) NOT NULL,
    CHECK (LENGTH(EventName) > 0),
    CHECK (LENGTH(EventLocation) > 0)
);

-- ============================================================
-- 5. EventRegistration Table
-- ============================================================
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
