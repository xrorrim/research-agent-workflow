# Research Agent Workflow

English · [简体中文](README.zh-CN.md)

A five-role multi-agent workflow for **open-ended research tasks** — the kind with a clear goal but a murky path to it. One agent scopes the direction, one breaks it into experiments, one implements and runs them, one gates quality, one records and audits results. This repo ships the workflow as **four one-click installable packages**: two platforms (Claude Code / Codex) × two prompt versions (baseline / optimized).

The four packages are deliberately built as an **A/B experiment**: identical orchestration, differing only in the prompt itself — so you can measure what prompt engineering actually buys you in research output.

> The packages and their in-package documentation are written in Chinese. This README summarizes the design in English; the agent prompts themselves are Chinese-language.

---

## The five roles

| Role | Responsibility | Key boundary |
|------|---------------|--------------|
| **Role 1 · Researcher** | Deep research + multi-turn discussion with you; picks exactly one technical route | Keep the route **coarse** — direction, falsifiable hypotheses, success metrics, milestones. Over-specify and you lock down Role 2's search space |
| **Role 2 · Strategist** | Decomposes the route into concrete experiments; decides advance / adjust / escalate | The only role allowed to call a route dead — and only with **multi-source verification** |
| **Role 3 · Implementer** | Writes experiment code, prepares `run.sh`, delivers results | Must report failures honestly; no polishing |
| **Role 5 · Reviewer** | Reviews code and experimental design | On rejection → kill the run, wipe this cycle's results, send it back |
| **Role 4 · Logbook** | Writes cycle notes, updates the global index, runs a **compliance check** | Catches cut corners, misaligned experiments, untraceable numbers |

Role 1 is merged into the main session — the conversation you open *is* Role 1, and it's your **only** interface to the system. The main session doubles as the message bus, automatically driving the R2→R3→R5→R4→R2 loop.

```
you (author) ⇄ main session (Role 1 · Researcher + message bus)
                    │ spawns / wakes subagents
    ┌───────────────┼───────────────┬───────────────┐
    ▼               ▼               ▼               ▼
  role2           role3           role5           role4
  strategist      implementer     reviewer        logbook
                    │
                    └─ the real run is launched in the background by the main
                       session (nohup + pid file), in parallel with review;
                       review fails → kill run, wipe results, send back
```

## What happens in one cycle (M1–M7 protocol, optimized version)

| Msg | Direction | Content |
|-----|-----------|---------|
| M1 | Role 1 → R2 | Route assignment |
| M2 | R2 → R3 | Task assignment (with measurable acceptance criteria) |
| M3 | R3 → R5 | Review request (commit, `run.sh`, ETA; no new code → review skipped) |
| M4 | R5 → R3 | Review verdict; rejected → main session kills the run, wipes results, sends back (3-strike cap) |
| M5 | R3 → R4 | Result delivery (failures delivered honestly; 3-strike cap on run failures) |
| M6 | R4 → R2 | Notes archived + compliance verdict |
| M7 | R2 → Role 1 | Route escalation (the system pauses here to talk to you) |

The system interrupts you at exactly three moments: **M7 route escalation**, **confirming a route is dead**, and **project completion**. You can interject at any time — highest priority. After a session dies, open a new one and say "继续循环" (continue the loop) to resume from the message archive: **all state lives in files, none in session memory**.

---

## Choosing a package

| Package | Platform | Prompt version | Download |
|---------|----------|----------------|----------|
| Claude Code · baseline | Claude Code | Original prompt baseline | [`科研工作流-对照版.zip`](packages/科研工作流-对照版.zip) |
| Claude Code · optimized | Claude Code | Optimized | [`科研工作流-自动化版.zip`](packages/科研工作流-自动化版.zip) |
| Codex · baseline | Codex | Original prompt baseline | [`科研工作流-Codex对照版.zip`](packages/科研工作流-Codex对照版.zip) |
| Codex · optimized | Codex | Optimized | [`科研工作流-自动化版-Codex-自安装.zip`](packages/科研工作流-自动化版-Codex-自安装.zip) |

**Just want to use it**: take the optimized package for your platform.
**Want to ablate the prompt**: install both, in **two separate repos**, on the same research task.

### Baseline vs optimized

| Dimension | Baseline | Optimized |
|-----------|----------|-----------|
| Role memory | Persistent subagents (same instance continued — mirrors the original 5 long-lived sessions) | Stateless subagents + file-backed memory (`logbook/index.md`) |
| Role 2 tools | Includes web search (multi-source verification required before calling a route dead) | No network tools (deep research belongs to Role 1) |
| Message format | Unspecified, free text | Fixed M1–M7 fields |
| Acceptance criteria / cycle numbering / commit binding / result invalidation / note index | None (undefined in the original — **this is the variable under test**) | Present |
| Escalation trigger | R2's own judgment of "done / impossible" | Hypothesis falsified / 3 cycles without progress / routine check every 5 cycles |
| Directory layout | `messages/` only | `docs/`, `logbook/`, `experiments/`, `results/`, `tests/` |

The baseline's role definitions are the **original prompt reproduced verbatim**, with only the mechanical adaptations needed to run. Orchestration (automated harness, review-while-running, background execution, 3-strike fuses) is identical across both — so the only difference left is the prompt. Each package's own README carries a transparency checklist marking exactly which lines are original and which are harness additions.

---

## Model tiering (Claude Code packages only)

Compute is weighted toward deciding and building; review and record-keeping run one tier down — "ship first, lighten the safety check":

| Role | model | effort | Configured in |
|------|-------|--------|---------------|
| Role 1 Researcher (main session) | `best` | `xhigh` | `.claude/settings.json` |
| Role 2 Strategist | `best` | `max` | agent frontmatter |
| Role 3 Implementer | `best` | `max` | agent frontmatter |
| Role 5 Reviewer | `opus` | `max` | agent frontmatter |
| Role 4 Logbook | `opus` | `max` | agent frontmatter |

These are **aliases, not pinned model IDs**: `best` resolves to the strongest model your org can access (Fable 5 as of 2026-07), falling back to the latest Opus otherwise; `opus` is the latest Opus. They follow model releases automatically — and anyone without Fable access can still run the workflow, just with Opus at the top tier.

Both packages use the **identical** model configuration, so it is not a variable under test in the A/B comparison.

**Three gotchas**: the main session's effort caps at `xhigh` (`max` is session-scoped and rejected by config files — run `/effort max` per session if you want it); `CLAUDE_CODE_EFFORT_LEVEL` overrides frontmatter, disabling the effort tiering entirely; and **don't enable ultracode** — it isn't a depth setting but "`xhigh` + have Claude auto-orchestrate dynamic workflows", which competes with this workflow's own state machine for control of the main session.

Requires Claude Code **≥ 2.1.219**. The baseline package is especially sensitive: it continues persistent subagents via SendMessage, and before 2.1.211 a subagent's `model:` override silently reverted to the parent session's model on follow-up.

## Installation

> ⚠️ **Do not install both versions in the same repo** — their config files overwrite each other. Use two separate repos, or two worktrees/branches of one.

### Claude Code (both versions)

Drop the zip in your project repo root and tell Claude Code:

```
解压 科研工作流-自动化版.zip 到当前目录，然后按 BOOTSTRAP.md 执行。
```

("Unzip … into the current directory, then follow BOOTSTRAP.md.") It places files, creates the directory skeleton, checks git, reports a verification checklist, then becomes Role 1 and asks you for your research topic.

<details>
<summary>Manual install (equivalent, 3 steps)</summary>

1. `CLAUDE.md` → repo root; the four `role*.md` and `settings.json` → `.claude/`
2. Create the skeleton:
   ```bash
   mkdir -p .claude/agents docs/route_archive logbook/messages experiments results tests
   touch logbook/index.md logbook/debt.md
   ```
3. Requires Claude Code **v2.1.219+**

</details>

### Codex (both versions)

**Let Codex install itself** — hand the zip's absolute path plus this instruction to a Codex session sitting in your project root:

```
请安全解压这个 ZIP 到临时目录，完整阅读解压目录根部的 BOOTSTRAP.md，
并按它把科研工作流安装到当前 git 项目；安装后在当前任务中立即按新 AGENTS.md 行事。
```

**Or install manually**: unzip, then double-click `install.command` on macOS or run `./install.sh` (the baseline package uses `INSTALL.command`). Then open a new Codex task in your project root and say:

```
把科研多智能体工作流安装到当前目录，然后按 research-workflow-automation 技能执行。
```

Uninstall: `codex plugin remove research-workflow-automation` (generated research records are preserved).

## Usage

1. Start the agent in your repo and **just describe your research topic** — you're talking to Role 1, which does deep research and iterates with you;
2. Once you approve the route, it writes `docs/route.md`, emits M1; say "**开始循环**" (start the loop) to enter the fully automatic experiment loop;
3. After an interruption, a new session picks up from "**继续循环**" (continue the loop).

**Prerequisite**: the target directory must be a git repo — experiment results are bound to commit hashes.

## Operating notes

- Each cycle ≈ 5–8 subagent invocations plus main-session polling. **Token cost is substantial.** Run 1–2 cycles on a small task to gauge quality before committing to a long one.
- Read `logbook/index.md` yourself every 5 cycles to confirm the direction hasn't drifted.
- `/compact` the main session freely when context grows — the protocol keeps all state in files, so compaction loses nothing.
- To switch back to serial "review-then-run", or change the 3-strike fuses or the 5-cycle review period: all are plain numbers in the config file. Edit them.
- **Engineering debt** (hardening, error handling, refactors) is appended to `logbook/debt.md` for a human to handle. Agents never spawn tasks for it.

## Running the comparison

- Same topic, same starting route, comparable cycle counts across both versions;
- Suggested metrics: cycles to reach the same milestone; rework rate (review rejections, compliance failures, fuse trips); readability/credibility of notes and conclusions; token spend; whether it drifts off-course or spins in place;
- Both sides keep a full message archive (`messages/` for baseline, `logbook/messages/` for optimized) for cycle-by-cycle review;
- Start with 2–3 cycles of a small task on each side to see the difference qualitatively, then decide whether to scale up.

## Repository layout

```
packages/    the four installable zips (the release artifacts — install from these)
prompts/     the unpacked prompt sources, for browsing and diffing on GitHub
  claude-code/{baseline,optimized}/
  codex/{baseline,optimized}/
```

`prompts/` mirrors the contents of `packages/` so you can read the prompts and diff the two versions directly on GitHub; install from the zips in `packages/`. The Codex optimized package also ships [`ADAPTATION-AUDIT.md`](prompts/codex/optimized/ADAPTATION-AUDIT.md), a line-by-line audit of the Claude Code → Codex port confirming that only platform differences were changed, never the research prompt.

## License

[MIT](LICENSE)
