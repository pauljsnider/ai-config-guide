# Update Dependency Snapshot

## Goal

Ensure the `package.json` and generated dependency documentation stay in sync.

## Steps

1. **Install dependencies**
   ```bash
   pnpm install
   ```
2. **Generate lockfile diff**
   ```bash
   pnpm dlx depcheck
   ```
3. **Regenerate docs**
   ```bash
   pnpm docs:deps
   ```
4. **Run tests**
   ```bash
   pnpm test --filter smoke
   ```
5. **Summarize changes**
   - Note new/removed packages
   - Flag unmet peer dependencies
   - Record follow-up tickets if scripts fail

## Completion Checklist

- [ ] Lockfile committed
- [ ] Dependency docs updated
- [ ] Test results attached to response
- [ ] Follow-up actions noted
