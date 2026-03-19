## Description
<!-- Briefly describe what this PR does and why -->

## Type of Change
- [ ] `feature/` — New feature or enhancement
- [ ] `hotfix/` — Bug fix for production issue
- [ ] `release/` — Release preparation
- [ ] `chore/` — Maintenance (deps, refactor, docs)

## Branch Naming (confirm before submitting)
| Type    | Format                          | Example                        |
|---------|---------------------------------|--------------------------------|
| Feature | `feature/<ticket-id>-short-desc`| `feature/BANK-42-login-flow`   |
| Hotfix  | `hotfix/<ticket-id>-short-desc` | `hotfix/BANK-99-null-pointer`  |
| Release | `release/<version>`             | `release/1.3.0`                |

## Checklist
- [ ] Branch name follows the naming convention above
- [ ] Code builds locally (`mvn clean install`)
- [ ] All tests pass
- [ ] No secrets or credentials committed
- [ ] Docker image builds successfully (`docker build .`)
- [ ] Self-reviewed code changes

## Related Ticket / Issue
<!-- Link to Jira, GitHub Issue, etc. -->
Closes #

## Test Evidence
<!-- Screenshot, logs, or test output confirming the change works -->
