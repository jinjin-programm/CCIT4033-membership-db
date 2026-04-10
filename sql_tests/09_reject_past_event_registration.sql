PRAGMA foreign_keys = ON;

INSERT INTO Member (FullName, SID, Email, JoinDate, MembershipStatus)
VALUES ('Past Event User', 'S109', 'user109@test.com', '2026-01-01', 'Active');

INSERT INTO SportsEvent (EventName, EventDate, EventLocation)
VALUES ('Old Event', '2026-01-01', 'Hall');

INSERT INTO EventRegistration (MemberID, EventID, RegistrationDate)
VALUES (1, 1, '2026-02-01');
