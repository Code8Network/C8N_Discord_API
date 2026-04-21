# C8N Discord API

Powerful Discord integration API for FiveM. Fetch roles by **name** (no hardcoded IDs), retrieve user and guild data, enforce permissions, and display an optional splash screen — all with built-in caching to respect Discord's rate limits.

## Features

- Full Discord REST API integration (v10)
- Lookup roles by **name** — no more hunting for role IDs
- Simple `HasRole` / `HasAnyRole` / `HasAllRoles` exports
- Player data: username, server nickname, avatar, roles, email *(if available)*
- Guild data: name, icon, splash, banner, member & online counts, role list
- TTL cache for member/role/guild fetches → fewer 429s
- Configurable `RoleList` mapping for friendly names
- Optional splash screen with Discord & website links
- Automatic rate-limit retry with `retry_after` awareness

## Installation

1. Drop the `C8N_Discord_API` folder into your `resources/`.
2. In your `server.cfg`:
   ```cfg
   set discord_bot_token "YOUR_BOT_TOKEN_HERE"
   set discord_guild_id  "YOUR_GUILD_ID_HERE"
   ensure C8N_Discord_API
   ```
3. Invite your bot to the guild with the **Server Members Intent** enabled on the Discord developer portal.
4. Configure `config.lua` — especially `Config.RoleList` and `Config.Splash`.

## Example Usage

```lua
local api = exports['C8N_Discord_API']

-- Permissions
if api:HasRole(source, 'Admin') then
    -- grant admin menu
end

if api:HasAnyRole(source, { 'VIP', 'Donator' }) then
    -- perks
end

-- Player data
local data = api:GetPlayerData(source)
print(data.username, data.nickname, data.avatar)
for _, roleName in ipairs(data.roles) do print(roleName) end

-- Guild data
local info = api:GetGuildInfo()
print(info.name, info.memberCount, info.onlineCount)
```

## Exports

### Identity
| Export | Description |
|---|---|
| `GetDiscordId(source)` | Returns Discord user id or nil |
| `IsInGuild(source)` | Is the player a member of the configured guild |

### Roles
| Export | Description |
|---|---|
| `HasRole(source, name)` | True if player has the role |
| `HasAnyRole(source, {names})` | True if player has any of the roles |
| `HasAllRoles(source, {names})` | True only if player has all of the roles |
| `GetPlayerRoles(source)` | Array of role names |
| `GetPlayerRoleIds(source)` | Array of role ids |
| `GetRoleIdByName(name)` | Role id or nil |
| `GetRoleByName(name)` | Full role object or nil |
| `GetAllRoles()` | Full role list |

### Player
| Export | Description |
|---|---|
| `GetPlayerName(source)` | Discord username |
| `GetPlayerNickname(source)` | Guild nickname (falls back to username) |
| `GetPlayerAvatar(source, size?)` | Avatar URL |
| `GetPlayerEmail(source)` | Email if exposed by user object (usually nil) |
| `GetPlayerData(source)` | Bundle of all user data |

### Guild
| Export | Description |
|---|---|
| `GetGuildName()` / `GetGuildIcon(size?)` / `GetGuildSplash(size?)` / `GetGuildBanner(size?)` |
| `GetGuildMemberCount()` / `GetGuildOnlineCount()` |
| `GetGuildInfo()` | Bundle of all guild info |

### Cache
`InvalidateMember(source|id)`, `InvalidateRoles()`, `InvalidateGuild()`, `ClearCache()`

## Commands

- `/discordinfo` – prints your Discord info to chat
- `/splash` – re-open the splash screen (client)

## Notes

- **Email** is only available via OAuth2 with the `email` scope. Pure bot integrations will usually receive `nil` — this is by design of the Discord API.
- Some endpoints may require adjustments based on future Discord API changes. Contributions welcome!

## License

See [LICENSE](LICENSE).
