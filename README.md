# Agent Packs Homebrew Tap

This tap publishes the Homebrew formula for
[`agent-packs`](https://github.com/agent-packs/cli).

## Release Sync

The formula is synced from the latest public `agent-packs/cli` GitHub release.
The sync workflow can run three ways:

- automatically every hour;
- manually with `workflow_dispatch`;
- immediately after a CLI release when the CLI repo dispatches the
  `agent-packs-release` event.

The sync script reads the latest release, downloads `checksums.txt`, updates
`Formula/agent-packs.rb`, validates Ruby syntax, and commits only when the
formula version changes.
