# Flowchart

## Example

```mermaid
flowchart TB
  A[parse] --> B{compare}
  B -->|no diff| C[End]
  B -->|diff| D[gen svg]
  D --> E[commit and push]
```
