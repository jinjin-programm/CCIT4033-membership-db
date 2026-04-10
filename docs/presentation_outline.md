# Presentation Outline

## Slide 1: Title
- Membership Database System
- Course: Introduction to Database Systems / 資料庫系統概論
- Group members

## Slide 2: Project Background
- Why the system was built
- What problem it solves
- Main users: admin and member

## Slide 3: System Overview
- Member management
- Payment management
- Event management
- Event registration
- Reporting

## Slide 4: Database Structure
- `Member`
- `Payment`
- `SportsEvent`
- `EventRegistration`
- `Admin`

## Slide 5: Relationship Overview
- One-to-many between member and payment
- One-to-many between member and event registration
- One-to-many between sports event and event registration

## Slide 6: Constraints
- `NOT NULL`
- `CHECK`
- `UNIQUE`
- `FOREIGN KEY`

## Slide 7: Why Triggers Are Used
- Automatic status update after payment
- Block inactive member registration
- Block past event registration
- Block future payment date

## Slide 8: Views and Reports
- `vw_MemberList`
- `vw_MembershipStatus`
- `vw_PaymentReport`
- `vw_EventList`
- `vw_EventRegistrationReport`

## Slide 9: Workflow Demo
- Insert member
- Insert payment
- Register event
- View report

## Slide 10: Testing
- Python test script exists for automation
- Pure SQL test scripts also added
- Tests cover validation, triggers, cascades, and views

## Slide 11: Strengths
- Data integrity
- Automatic business rules
- Clean report generation
- Suitable for database course learning

## Slide 12: Conclusion
- Tables store data
- Constraints protect data
- Triggers automate behavior
- Views simplify reporting
