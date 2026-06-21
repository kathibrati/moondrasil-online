# Security Principles

- Never trust the client.
- The server is authoritative for all gameplay state.
- Clients send intentions, not final state.
- Validate every incoming message.
- Rate-limit sensitive actions.
- Never expose internal IDs that grant authority.
- Do not trust client-side cooldowns, damage, inventory, gold, EXP or position.
- Use TLS/WSS in production.
- Use short-lived access tokens.
- Validate sessions on every connection.
- Log suspicious behavior.