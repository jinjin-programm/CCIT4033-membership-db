PRAGMA foreign_keys = ON;

INSERT INTO Member (FullName, SID, Email, JoinDate, MembershipStatus)
VALUES ('Test User 1', 'S101', 'user1@test.com', '2026-01-01', 'Inactive');

SELECT * FROM Member WHERE SID = 'S101';
