-- ============================================================
-- Membership System — Sample Queries & Reports
-- Based on Database Functions.md specifications
-- ============================================================

PRAGMA foreign_keys = ON;

-- ============================================================
-- Query 1: View All Members
-- ============================================================
SELECT MemberID, FullName, SID, PhoneNo, Email, MembershipStatus
FROM Member;

-- ============================================================
-- Query 2: View Payment Records of All Members
-- ============================================================
SELECT PaymentID, MemberID, PaymentAmount, PaymentDate, PaymentMethod
FROM Payment;

-- ============================================================
-- Query 3: View Sports Events
-- ============================================================
SELECT EventID, EventName, EventDate, EventLocation
FROM SportsEvent;

-- ============================================================
-- Query 4: View Event Registration Details
-- ============================================================
SELECT er.RegistrationID, m.FullName, se.EventName, er.RegistrationDate
FROM EventRegistration er
JOIN Member m ON er.MemberID = m.MemberID
JOIN SportsEvent se ON er.EventID = se.EventID;

-- ============================================================
-- Query 5: View Members with Active Membership Status
-- ============================================================
SELECT MemberID, FullName, MembershipStatus
FROM Member
WHERE MembershipStatus = 'Active';

-- ============================================================
-- Query 6: View Total Payments per Member
-- ============================================================
SELECT
    m.MemberID,
    m.FullName,
    COUNT(p.PaymentID) AS PaymentCount,
    COALESCE(SUM(p.PaymentAmount), 0) AS TotalAmount
FROM Member m
LEFT JOIN Payment p ON m.MemberID = p.MemberID
GROUP BY m.MemberID, m.FullName
ORDER BY TotalAmount DESC;

-- ============================================================
-- Query 7: View Events with Registration Count
-- ============================================================
SELECT
    se.EventID,
    se.EventName,
    se.EventDate,
    se.EventLocation,
    COUNT(er.RegistrationID) AS RegistrationCount
FROM SportsEvent se
LEFT JOIN EventRegistration er ON se.EventID = er.EventID
GROUP BY se.EventID, se.EventName, se.EventDate, se.EventLocation
ORDER BY se.EventDate;

-- ============================================================
-- Query 8: View Member's Event Registrations
-- ============================================================
SELECT
    m.MemberID,
    m.FullName,
    se.EventName,
    se.EventDate,
    er.RegistrationDate
FROM Member m
JOIN EventRegistration er ON m.MemberID = er.MemberID
JOIN SportsEvent se ON er.EventID = se.EventID
ORDER BY m.MemberID, se.EventDate;

-- ============================================================
-- Query 9: View Members Who Have Never Made a Payment
-- ============================================================
SELECT MemberID, FullName, Email, MembershipStatus
FROM Member
WHERE MemberID NOT IN (SELECT DISTINCT MemberID FROM Payment);

-- ============================================================
-- Query 10: View Upcoming Events (future events from today)
-- ============================================================
SELECT EventID, EventName, EventDate, EventLocation
FROM SportsEvent
WHERE EventDate > DATE('now')
ORDER BY EventDate;
