# Security Considerations

The public repository is intentionally different from the live lab. The goal is to preserve enough technical detail to explain the work without publishing information that would expose the environment.

## Information intentionally excluded or generalized

- private LAN and overlay-network addresses
- hostnames and account names
- identifying local filesystem paths
- internal service endpoints and mapped ports where unnecessary
- Discord webhook URLs
- API keys, tokens, and credentials
- n8n credential references
- raw workflow execution history
- raw operational logs
- screenshots containing account, browser-session, or private infrastructure details

Generic placeholders such as `<host>`, `<port>`, and `<user>` are used where the specific value is not needed to understand the workflow.

## Automation boundary

The recovery work in this lab uses bounded actions rather than unrestricted command execution.

For the disk branch, the recovery logic is limited to known cleanup operations and is followed by a new disk-usage measurement. Local AI experimentation is documented separately from recovery authority; model output is not treated as trusted shell input.

## Credentials

Credentials belong in the service or secret store that needs them, not in source files. Public examples should show the shape of a configuration without containing a usable credential.

## Public documentation principle

Technical documentation should explain:

- what was monitored
- what condition caused a branch
- what remediation was allowed
- how the result was verified

It does not need to expose the live identifiers that make the environment reachable.
