PRAGMA foreign_keys = ON;

INSERT INTO Member (FullName, SID, Email, JoinDate, MembershipStatus)
VALUES ('Future Pay User', 'S105', 'user105@test.com', '2026-01-01', 'Inactive');

INSERT INTO Payment (MemberID, PaymentAmount, PaymentDate, PaymentMethod)
VALUES (1, 100, date('now', '+1 day'), 'Cash');
