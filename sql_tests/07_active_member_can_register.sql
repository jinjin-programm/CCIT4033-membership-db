PRAGMA foreign_keys = ON;

INSERT INTO Member (FullName, SID, Email, JoinDate, MembershipStatus)
VALUES ('Active Reg User', 'S107', 'user107@test.com', '2026-01-01', 'Active');

INSERT INTO SportsEvent (EventName, EventDate, EventLocation)
VALUES ('Run Event', '2026-12-01', 'Main Ground');

INSERT INTO EventRegistration (MemberID, EventID, RegistrationDate)
VALUES (1, 1, '2026-01-20');

SELECT * FROM EventRegistration WHERE MemberID = 1 AND EventID = 1;
