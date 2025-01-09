# Overview

A high level summary that every engineer at the company should understand and use to decide if it’s useful for them to read the rest of the doc. It should be 3 paragraphs max.

# Context

A description of the problem at hand, why this project is necessary, what people need to know to assess this project, and how it fits into the technical strategy, product strategy, or the team’s quarterly goals.

# Scope

A description of the scope of this doc.

# Goal

The Goals section should:

– describe the user-driven impact of your project — where your user might be another engineering team or even another technical system
– specify how to measure success using metrics — bonus points if you can link to a dashboard that tracks those metrics

# Non-Goal

Non-Goals are equally important to describe which problems you won’t be fixing so everyone is on the same page.

# Solution / Technical Architecture

Try to walk through a user story to concretize this. Feel free to include many sub-sections and diagrams.
Provide a big picture first, then fill in lots of details. Aim for a world where you can write this, then take a vacation on some deserted island, and another engineer on the team can just read it and implement the solution as you described.

## System Context Diagrams

In many docs a system-context-diagram can be very useful. Such a diagram shows the system as part of the larger technical landscape and allows readers to contextualize the new design given its environment that they are already familiar with.

## APIs

Systems that store data should likely discuss how and in what rough form this happens. Similar to the advice on APIs, and for the same reasons, copy-pasting complete schema definitions should be avoided. Instead focus on the parts that are relevant to the design and its trade-offs.

## Data Storage

Systems that store data should likely discuss how and in what rough form this happens. Similar to the advice on APIs, and for the same reasons, copy-pasting complete schema definitions should be avoided. Instead focus on the parts that are relevant to the design and its trade-offs.

# Alternative Solution

What else did you consider when coming up with the solution above? What are the pros and cons of the alternatives? Have you considered buying a 3rd-party solution — or using an open source one — that solves this problem as opposed to building your own?

# Milestones

A list of measurable checkpoints, so your PM and your manager’s manager can skim it and know roughly when different parts of the project will be done. I encourage you to break the project down into major user-facing milestones if the project is more than 1 month long.

Use calendar dates so you take into account unrelated delays, vacations, meetings, and so on. It should look something like this:

Start Date: June 7, 2018

Milestone 1 — New system MVP running in dark-mode: June 28, 2018

Milestone 2 – Retire old system: July 4th, 2018

End Date: Add feature X, Y, Z to new system: July 14th, 2018

Add an [Update] subsection here if the ETA of some of these milestone changes, so the stakeholders can easily see the most up-to-date estimates.

# Concerns

# Logs

# Security

# Observability

# References
