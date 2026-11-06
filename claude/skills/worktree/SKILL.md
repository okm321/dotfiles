---
name: worktree
description: Launch one or more tasks in new git worktrees using workmux.
disable-model-invocation: true
allowed-tools: Bash, Write
---

Launch one or more tasks in new git worktrees using workmux.

Tasks: $ARGUMENTS

## You are a dispatcher, not an implementer

See the `/workmux` skill's Dispatcher Principles for the hard rule (no
exploring/reading/searching the codebase) and prompt file rules. Follow
them here.

For each task:

1. Generate a short, descriptive worktree name (2-4 words, kebab-case)
2. Write a detailed implementation prompt to a temp file
3. Run `workmux add <worktree-name> -b -P <temp-file>` to create the worktree

## Skill delegation

If the user passes a skill reference (e.g., `/auto`, `/plan-review`), write
the prompt so the agent invokes that skill instead of manual implementation
steps. Pass any flags through (e.g. `/auto --gemini`).

Example prompt:
```
[Task description here]

Use the skill: /skill-name [flags if any] [task description]
```

Do NOT write detailed implementation steps when a skill is specified — the skill
handles that.

## Flags

**`--merge`**: When passed, add instruction to use `/merge` skill at the end to
commit, rebase, and merge the branch.

```
...
Then use the /merge skill to commit, rebase, and merge the branch.
```

Only instruct worktree agent to `/merge` if explicitly requested by user in
task.

**`--fork`**: When passed, add `--fork` to the `workmux add` command. This copies
the current conversation into the new worktree so the agent resumes with full
context of what was discussed. Useful when the current conversation has built up
context that the new worktree agent needs.

When `--fork` is used, prepend this to the prompt file so the forked agent does
not recursively dispatch more worktrees:

```
You are now running INSIDE a git worktree created by the /worktree skill. The
prior conversation context (including any /worktree dispatch instructions) is
ancestry only. Do NOT invoke the /worktree skill, do NOT run `workmux add`, and
do NOT create further worktrees. Your job is to implement the task below
directly in this worktree.
```

## Cross-project dispatch

If the task mentions another repository, absolute project path, or work that
clearly spans multiple repositories, adapt the dispatch to the target project
instead of assuming the current repository. Use the project path provided by
the user, or already present in the conversation — do not explore that
repository. Follow the `/workmux` skill's cross-project worktree creation
steps to find or create the target tmux session and run `workmux add` inside
it.

If a task touches both the current repository and another repository, create one
prompt and worktree per repository. Each prompt should explain the cross-repo
context and reference the other repository by absolute path when useful, but the
agent assigned to a repository should make changes only in its own worktree
unless the user explicitly asks for a different arrangement.

If the user's request does not provide enough information to identify the target
project path or session name, ask for clarification instead of searching.

## Workflow

Write ALL temp files first, THEN run all workmux commands.

**IMPORTANT:** For same-repository tasks, run `workmux add` from the CURRENT
directory. Do NOT `cd` to the main repo or any other directory. The new worktree
branches from whatever branch is checked out in the current directory. For
cross-project tasks, run `workmux add` inside the target project's tmux session
as described above.

Step 1 - Write all prompt files (in parallel):

```bash
tmpfile=$(mktemp).md
cat > "$tmpfile" << 'EOF'
Implement feature X...
EOF
echo "$tmpfile"  # Note the path for step 2
```

Step 2 - After ALL files are written, run workmux commands (in parallel):

```bash
workmux add feature-x -b -P /tmp/tmp.abc123.md
workmux add feature-y -b -P /tmp/tmp.def456.md
```

After creating the worktrees, inform the user which branches were created.

**Remember:** Your task is COMPLETE once worktrees are created. Do NOT implement
anything yourself.
