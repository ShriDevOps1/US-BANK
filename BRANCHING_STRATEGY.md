# Git Branching Strategy

This document defines the branching model for this organization. All developers must follow these conventions.

---

## Branch Overview

```
main
 └── develop
      └── feature/<ticket-id>-<short-description>   (developer work)
      └── hotfix/<ticket-id>-<short-description>    (production fix)
 └── release/<version>                              (release prep)
```

---

## Branch Definitions

| Branch          | Purpose                          | Who Creates       | Merges Into         | CI Trigger         |
|-----------------|----------------------------------|-------------------|---------------------|--------------------|
| `main`          | Production-ready code            | DevOps/Release    | —                   | Push → Docker push |
| `develop`       | Integration / staging            | DevOps            | `main` via release  | Push → build+test  |
| `feature/*`     | New features, enhancements       | Developers        | `develop` (via PR)  | PR → build+test    |
| `release/*`     | Release candidate prep           | DevOps/Tech Lead  | `main` + `develop`  | Push → full scan   |
| `hotfix/*`      | Emergency production fixes       | Tech Lead/DevOps  | `main` + `develop`  | Push → fast-track  |

---

## Developer Workflow (Day-to-Day)

### 1. Starting a new feature

```bash
# Always branch off from develop
git checkout develop
git pull origin develop

# Create your feature branch
git checkout -b feature/BANK-42-add-login-endpoint

# Work, commit often
git add .
git commit -m "feat(auth): add login endpoint with JWT"

# Push your branch
git push -u origin feature/BANK-42-add-login-endpoint
```

### 2. Opening a Pull Request

- Open a PR from `feature/BANK-42-...` → `develop`
- Fill in the PR template
- CI runs automatically: Maven build + test + Docker build + Trivy scan
- Minimum **1 reviewer approval** required before merge

### 3. Merging

- Use **Squash and Merge** for features (keeps `develop` history clean)
- Delete your feature branch after merge

---

## Release Workflow

```bash
# Cut a release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/1.3.0

# Bump version in pom.xml if needed, final testing
git push -u origin release/1.3.0

# Open PR: release/1.3.0 → main
# After merge, tag main
git checkout main
git pull origin main
git tag -a v1.3.0 -m "Release 1.3.0"
git push origin v1.3.0

# Back-merge release into develop
git checkout develop
git merge main
git push origin develop
```

---

## Hotfix Workflow (Production Emergency)

```bash
# Branch off main directly
git checkout main
git pull origin main
git checkout -b hotfix/BANK-99-null-pointer-fix

# Apply fix, commit
git commit -m "fix: resolve NPE in payment processor"
git push -u origin hotfix/BANK-99-null-pointer-fix

# Open PR to BOTH main AND develop
# After both merges, tag the patch version
git checkout main && git tag -a v1.3.1 -m "Hotfix 1.3.1"
git push origin v1.3.1
```

---

## Branch Naming Convention

```
feature/<ticket-id>-<short-kebab-description>   # feature/BANK-42-login-flow
hotfix/<ticket-id>-<short-kebab-description>    # hotfix/BANK-99-null-pointer
release/<semver>                                # release/1.3.0
chore/<short-kebab-description>                 # chore/upgrade-spring-boot
```

Rules:
- Use **lowercase** and **hyphens** only (no underscores, no spaces)
- Include the **ticket ID** for traceability
- Keep descriptions **short** (3-5 words max)

---

## CI/CD Pipeline per Branch

| Branch      | Build | Unit Test | Docker Build | Trivy Scan        | Docker Push    |
|-------------|-------|-----------|--------------|-------------------|----------------|
| `feature/*` | YES   | YES       | YES          | CRITICAL+HIGH     | NO             |
| `develop`   | YES   | YES       | YES          | CRITICAL+HIGH     | NO             |
| `release/*` | YES   | YES       | YES          | CRITICAL (blocks) | NO             |
| `main`      | YES   | YES       | YES          | CRITICAL (blocks) | YES (DockerHub)|
| `hotfix/*`  | YES   | YES       | YES          | CRITICAL (blocks) | NO             |

---

## Branch Protection Rules (Set in GitHub)

Apply the following in **Settings → Branches → Branch protection rules**:

### `main`
- [x] Require pull request before merging
- [x] Require at least **2 approvals**
- [x] Require status checks to pass (CI - Main)
- [x] Require branches to be up to date before merging
- [x] Restrict who can push (DevOps/Tech Lead only)
- [x] Do not allow force pushes

### `develop`
- [x] Require pull request before merging
- [x] Require at least **1 approval**
- [x] Require status checks to pass (CI - Feature PR Validation)
- [x] Do not allow force pushes

---

## Commit Message Convention

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short summary>

Types:
  feat     - new feature
  fix      - bug fix
  chore    - maintenance
  docs     - documentation
  refactor - code refactor (no behaviour change)
  test     - adding/fixing tests
  ci       - CI/CD changes

Examples:
  feat(auth): add JWT token validation
  fix(payment): resolve null pointer in charge processor
  chore(deps): upgrade Spring Boot to 3.3.11
  ci: add trivy scan to hotfix workflow
```

---

## Quick Reference Card (Share with Developers)

```
I want to...                     | Branch from  | PR target  | Branch name
---------------------------------|--------------|------------|---------------------------
Build a new feature              | develop      | develop    | feature/BANK-XX-desc
Fix a production bug urgently    | main         | main+dev   | hotfix/BANK-XX-desc
Prepare a release                | develop      | main       | release/1.x.0
Update docs/tooling              | develop      | develop    | chore/short-desc
```
