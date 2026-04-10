# Oral Report Script

## Opening

Hello everyone. Today I will introduce our membership database system.

I am a beginner in database too, so I will explain it in a very simple way:
this project is a system that stores member data, payment data, sports event data, and event registrations.

## What the system does

The system has two main users: admin and member.

- Admins manage records, payments, and reports.
- Members can be registered, make payments, and join sports events.

## Database structure

Our database has five tables:

- `Member`
- `Payment`
- `SportsEvent`
- `EventRegistration`
- `Admin`

You can think of tables as boxes that store different types of information.

## How the workflow works

First, the database is created using SQL.

Then data is inserted into the tables.

After that, the database checks whether the data is valid.

If the data is valid, it is saved.
If the data is not valid, the database rejects it.

## Why we use constraints

We use constraints to stop basic mistakes.

For example:

- email must look like a real email
- payment amount must be positive
- SID must be unique
- one member cannot register for the same event twice

## Why we use triggers

We use triggers because some rules need automatic action.

For example:

- when a payment is added, the member becomes `Active`
- inactive members cannot register for events
- past events cannot be registered
- future payment dates are blocked

This is the main reason triggers are important in our project.

## Why we use views

We use views to make reports easier.

Instead of writing long SQL again and again, the database gives us ready-made report views.

Examples include:

- member list report
- membership status report
- payment report
- event list report
- event registration report

## Simple summary of the logic

If I explain the whole project in one sentence:

**Tables store the data, constraints protect the data, triggers automate the rules, and views show the reports.**

## Closing

In conclusion, this project shows how a database can do more than storage.

It can also validate data, enforce business rules, and generate reports automatically.

Thank you.
