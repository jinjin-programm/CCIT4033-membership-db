-- ============================================================
-- Membership System — Views & Reports
-- ============================================================

PRAGMA foreign_keys = ON;

-- ============================================================
-- Report 1: Member List Report
-- Shows all members with full details
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

-- ============================================================
-- Report 2: Membership Status Report
-- Shows member status with total payment summary
-- ============================================================
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

-- ============================================================
-- Report 3: Payment Transaction Report
-- Shows all payment records with member details
-- ============================================================
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

-- ============================================================
-- Report 4: Sports Event Schedule Report
-- Shows all sports events
-- ============================================================
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

-- ============================================================
-- Report 5: Event Registration Summary Report
-- Shows all event registrations with member and event details
-- ============================================================
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
