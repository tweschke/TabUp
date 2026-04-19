# GitHub Release & Branch Management (FULL)
## Apple Apps (iOS & macOS)

Version: 2.4.0  
Status: Full Operational Standard  

---

## 1. Purpose

This document defines the complete GitHub workflow for all Apple app projects.

It is the single source of truth for:

- branching  
- release handling  
- Apple lifecycle handling  
- Cursor command interpretation  
- safety guardrails  
- remote branch publishing  

---

## 2. Core Principle

All App Store submissions MUST come from:

`release/<version>`

Never from:

- `main`  
- `feature/*`  
- `fix/*`  
- `hotfix/*`  

---

## 3. Branch Model

### `main`
Production branch.

Represents the version currently live on the App Store.

Rules:

- no direct commits  
- no experimental code  
- only updated after a release or hotfix is live  
- tags are created here  

---

### `release/<version>`
Active release candidate.

Examples:

- `release/1.2`  
- `release/1.3`  

Rules:

- always created from `main`  
- all release work ends here  
- only branch used for App Store submission  
- merged into `main` when approved and live  

---

### `feature/<version>/<name>`
Optional isolated feature branch.

Rules:

- created from `release/<version>`  
- must merge back into `release/<version>`  
- never submitted directly  

---

### `fix/<version>/<name>`
Optional safety sandbox branch.

Rules:

- created from `release/<version>`  
- used for risky fixes / Apple rejections  
- must merge back into `release/<version>`  

---

### `hotfix/<version>`
Urgent production fix branch.

Rules:

- created from `main`  
- merged back into `main` when live  
- also merged into active release branch if needed  

---

## 4. Branch Naming Rules

Valid formats:

- `release/X.Y`  
- `feature/X.Y/<name>`  
- `fix/X.Y/<name>`  
- `hotfix/X.Y.Z`  

---

## 5. Apple Lifecycle

States:

- In Development  
- Ready for Submission  
- Submitted  
- Rejected  
- Approved & Live  

Only **Approved & Live** triggers merge to `main`.

---

## 6. Start New Version

Command:  
“We’re starting version X.Y”

Cursor MUST:

- checkout `main`  
- pull latest  
- create `release/X.Y`  
- push to origin  
- confirm local + remote  

---

## 7. Feature Branch

Command:  
“Create feature for <name> in X.Y”

Cursor MUST:

- branch from `release/X.Y`  
- push to origin  
- confirm ready  

---

## 8. Fix Branch

Command:  
“Create fix branch for X.Y <name>”

Cursor MUST:

- branch from `release/X.Y`  
- push to origin  
- confirm ready  

---

## 9. Submission Guardrail

Command:  
“We’re ready to submit X.Y”

Cursor MUST:

- validate branch  
- enforce `release/X.Y`  
- require confirmation before merge  

---

## 10. Submission Rule

Only submit from:

`release/<version>`

---

## 11. Rejection Handling

- Low risk → fix in release branch  
- High risk → use fix branch  

---

## 12. Gone Live Flow (ENHANCED)

Command:  
“Version X.Y is live”

---

### Cursor MUST

1. merge `release/X.Y` → `main`  
2. push `main` to origin  
3. create tag `vX.Y.0`  
4. push tag to origin  
5. handle GitHub Release (logic below)  
6. delete `release/X.Y` (local + remote)  
7. confirm completion  

---

## GitHub Release Handling

### Step 1 — Check CLI Auth

```bash
gh auth status
```

---

### If AUTHENTICATED

```bash
gh release create vX.Y.0 --generate-notes
```

Confirm:

- release created  
- visible in repo  

---

### If NOT AUTHENTICATED

Cursor MUST:

- clearly state release was NOT created  
- confirm tag exists  
- confirm repo state is correct  

Provide manual instruction:

Create release here:  
https://github.com/<owner>/<repo>/releases/new

Select tag:  
`vX.Y.0`

---

### Optional UX Enhancement

If environment allows, Cursor SHOULD open:

https://github.com/<owner>/<repo>/releases/new?tag=vX.Y.0

---

## Critical Rules

- Release creation must NEVER silently fail  
- Git operations must ALWAYS complete  
- Manual fallback must ALWAYS be provided  

---

## Completion Criteria

Flow is complete when:

- `main` reflects live version  
- tag exists on origin  
- release branch deleted  
- GitHub Release is:
  - created OR  
  - clearly handed off  

---

## 13. Hotfix Flow

Command:  
“Create hotfix X.Y.Z”

Cursor MUST:

- branch from `main`  
- push  
- confirm  

After live:

- merge to `main`  
- tag  
- create release  

---

## 14. Remote Rule

A branch is NOT complete until:

- exists locally  
- pushed to origin  
- upstream set  
- visible on GitHub  

---

## 15. Rules

- no commits to `main`  
- no submission from feature/fix  
- always push branches  
- always validate branch before submit  

---

## 16. Cursor Behaviour

Cursor MUST:

- validate before submission  
- confirm actions  
- never skip steps  
- never silently fail  

Cursor MUST NOT:

- guess versions  
- release early  
- tag early  

---

## 17. Summary

This workflow ensures:

- clean releases  
- zero ambiguity  
- safe automation  
- clear manual control  

---

## 18. Final Intent

You can say:

- “Start 1.2”  
- “Create feature”  
- “Create fix”  
- “Ready to submit”  
- “Version is live”  

And everything works — cleanly, predictably, and professionally.
