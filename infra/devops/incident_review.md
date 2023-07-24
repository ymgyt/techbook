# Incident Review


## Template

Gitlabのincident reviewの具体例  
https://gitlab.com/gitlab-com/gl-infra/production/-/issues/15999

```
## Customer Impact

1. Who was impacted by this incident? (i.e. external customers, internal customers)
2. What was the customer experience during the incident? (i.e. preventing them from doing X, incorrect display of Y, ...)
3. How many customers were affected?
4. If a precise customer impact number is unknown, what is the estimated impact (number and ratio of failed requests, amount of traffic drop, ...)?

## What were the root causes?

## Incident Response Analysis

1. How was the incident detected?
2. How could detection time be improved?
3. How was the root cause diagnosed?
4. How could time to diagnosis be improved?
5. How did we reach the point where we knew how to mitigate the impact?
6. How could time to mitigation be improved?

## Post Incident Analysis

1. Did we have other events in the past with the same root cause?
2. Do we have existing backlog items that would've prevented or greatly reduced the impact of this incident?
3. Was this incident triggered by a change (deployment of code or change to infrastructure)? If yes, link the issue.

## What went well?

## Guidelines
```