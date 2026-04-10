PRAGMA foreign_keys = ON;

INSERT INTO Member (FullName, SID, Email, JoinDate, MembershipStatus)
VALUES ('View User', 'S110', 'user110@test.com', '2026-01-01', 'Active');

INSERT INTO Payment (MemberID, PaymentAmount, PaymentDate, PaymentMethod)
VALUES (1, 150, '2026-01-15', 'Cash');

INSERT INTO SportsEvent (EventName, EventDate, EventLocation)
VALUES ('View Event', '2026-12-20', 'Stadium');

INSERT INTO EventRegistration (MemberID, EventID, RegistrationDate)
VALUES (1, 1, '2026-01-20');

SELECT * FROM vw_MemberList;
SELECT * FROM vw_MembershipStatus;
SELECT * FROM vw_PaymentReport;
SELECT * FROM vw_EventList;
SELECT * FROM vw_EventRegistrationReport;
