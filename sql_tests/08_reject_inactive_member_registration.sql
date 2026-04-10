PRAGMA foreign_keys = ON;

INSERT INTO Member (FullName, SID, Email, JoinDate, MembershipStatus)
VALUES ('Inactive Reg User', 'S108', 'user108@test.com', '2026-01-01', 'Inactive');

INSERT INTO SportsEvent (EventName, EventDate, EventLocation)
VALUES ('Swim Event', '2026-12-10', 'Pool');

INSERT INTO EventRegistration (MemberID, EventID, RegistrationDate)
VALUES (1, 1, '2026-01-20');
