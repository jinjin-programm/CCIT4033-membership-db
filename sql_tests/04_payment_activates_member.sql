PRAGMA foreign_keys = ON;

INSERT INTO Member (FullName, SID, Email, JoinDate, MembershipStatus)
VALUES ('Payment User', 'S104', 'user104@test.com', '2026-01-01', 'Inactive');

INSERT INTO Payment (MemberID, PaymentAmount, PaymentDate, PaymentMethod)
VALUES (1, 100, '2026-01-10', 'Cash');

SELECT MemberID, MembershipStatus
FROM Member
WHERE MemberID = 1;
