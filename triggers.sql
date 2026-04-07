-- ============================================================
-- Membership System — Triggers
-- ============================================================

PRAGMA foreign_keys = ON;

-- ============================================================
-- 1. Auto-update MembershipStatus to 'Active' on new payment
--    When a member makes a payment, their status becomes Active.
-- ============================================================
CREATE TRIGGER IF NOT EXISTS trg_activate_member_on_payment
AFTER INSERT ON Payment
BEGIN
    UPDATE Member
    SET MembershipStatus = 'Active'
    WHERE MemberID = NEW.MemberID
      AND MembershipStatus IN ('Inactive', 'Expired');
END;

-- ============================================================
-- 2. Prevent event registration for non-active members
--    Only members with 'Active' status can register for events.
-- ============================================================
CREATE TRIGGER IF NOT EXISTS trg_check_active_before_registration
BEFORE INSERT ON EventRegistration
BEGIN
    SELECT CASE
        WHEN (SELECT MembershipStatus FROM Member WHERE MemberID = NEW.MemberID) != 'Active'
        THEN RAISE(ABORT, 'Error: Only active members can register for events.')
    END;
END;

-- ============================================================
-- 3. Prevent registration for past events
-- ============================================================
CREATE TRIGGER IF NOT EXISTS trg_check_event_date_before_registration
BEFORE INSERT ON EventRegistration
BEGIN
    SELECT CASE
        WHEN (SELECT EventDate FROM SportsEvent WHERE EventID = NEW.EventID) < NEW.RegistrationDate
        THEN RAISE(ABORT, 'Error: Cannot register for an event that has already passed.')
    END;
END;

-- ============================================================
-- 4. Prevent payment with future date
-- ============================================================
CREATE TRIGGER IF NOT EXISTS trg_check_payment_date
BEFORE INSERT ON Payment
BEGIN
    SELECT CASE
        WHEN NEW.PaymentDate > DATE('now')
        THEN RAISE(ABORT, 'Error: Payment date cannot be in the future.')
    END;
END;

-- ============================================================
-- 7. Prevent duplicate event name
-- ============================================================
CREATE TRIGGER IF NOT EXISTS trg_unique_event_name
BEFORE INSERT ON SportsEvent
BEGIN
    SELECT CASE
        WHEN (SELECT COUNT(*) FROM SportsEvent WHERE EventName = NEW.EventName AND EventDate = NEW.EventDate) > 0
        THEN RAISE(ABORT, 'Error: An event with this name and date already exists.')
    END;
END;
