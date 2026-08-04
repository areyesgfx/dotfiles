# Technical Opinions

These are my standing technical opinions and defaults.
Agents working for me should apply these without asking, and flag when a task genuinely conflicts with one.

## Language and Tooling

### Go

Write stdlib-first, boring Go.
Minimal dependencies, plain errors wrapped with %w, small interfaces defined at the point of use, and sparing use of generics.
Boring code is easier to review, debug, and maintain long-term.

### Terraform

Terragrunt is my default for organizing Terraform on new projects.
It keeps config DRY and handles remote state and environment orchestration without hand-rolled glue.

### Testing

Testing is unit-first.
Fast unit tests form the base, with integration tests reserved for critical paths.
A quick, reliable test suite gets run more often and catches regressions earlier than slow integration-heavy suites.

## Infrastructure and Architecture

### Module Boundaries

Split infra into a separate module when it will be implemented across all environments.
The goal is avoiding duplicate code across the repo, not creating modules for their own sake.

### Abstraction

Think ahead about how IaC will scale, and lay foundations early for code that will be reused elsewhere.
Building the right boundaries up front avoids painful refactors later.
But do not overdo it - no helper functions or abstractions for one-off use cases.

## Process

### AI-Generated Code

Agents draft, I review.
Agents can write full implementations, but everything gates through my own review before it ships.

### Commits and PRs

Commit messages should be concise.
PR descriptions should be concise and provide context only if needed, just enough for other engineers to understand what they are looking at.

### Deployment Gates

PR review is the gate for infrastructure changes.
On merge to main, the pipeline conducts the apply.
Human judgment happens at review time, not as a separate approval click after merge.
