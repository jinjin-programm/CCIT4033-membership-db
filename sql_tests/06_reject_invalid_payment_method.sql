PRAGMA foreign_keys = ON;

INSERT INTO Member (FullName, SID, Email, JoinDate, MembershipStatus)
VALUES ('Method User', 'S106', 'user106@test.com', '2026-01-01', 'Inactive');

INSERT INTO Payment (MemberID, PaymentAmount, PaymentDate, PaymentMethod)
VALUES (1, 100, '2026-01-10', 'Bitcoin');
