# Agent Instructions

These are common instructions for agents working on my projects across all scenarios (IaC platform, etc).

## General Guidelines

- Never use the em dash "—". Use a plain dash "-" instead.
- When writing commit messages, NEVER auto-add your agent name as co-author.
- Never manually modify CHANGELOG.md files or any files marked as auto-generated.
- When writing or substantially editing long Markdown files, put each full sentence on its own line. Preserve normal Markdown structure, but avoid wrapping multiple sentences onto one physical line.
- When making technical decisions, do not give much weight to development cost or speed of implementation. Instead, prefer quality, simplicity, robustness, scalability, and long-term maintainability - especially for platform/IaC code that others may build on later.
- When doing bug fixes, always start by reproducing the bug in an environment as close to real usage as possible before proposing a fix. This makes sure the real problem is found so the fix actually solves it.
- When reviewing infrastructure or pipeline changes, be picky about drift, unintended blast radius, and multi-account/multi-environment side effects. If something looks off, even if unrelated to the immediate task, flag it.
- Apply that same high standard to engineering excellence: lint, test failures, flaky tests, and inconsistent IaC/module patterns. If you see one, even if it wasn't caused by the current task, flag it rather than ignoring it.

## Review Philosophy

When reviewing code or design decisions, favor the mentor-style approach: point to exact primary sources rather than summarizing or leading with the answer, so I read and learn independently.

## Agent Prompt Conventions

When asked to write a prompt for an agentic tool (e.g. a Cursor agent), default to a ReAct-style structure (Reason -> Act -> Observe) with phased review gates and explicit production safety guardrails, unless a different pattern is clearly a better fit for the task.
