# Geoffrey_Installer

This is the public, secrets-free bootstrap for Geoffrey.

Its job is only to:

1. Clone or update the public Geoffrey package.
2. Put it in `~/Geoffrey`.
3. Run Geoffrey's own bootstrap.

The friend does not need a GitHub account to download Geoffrey. During
onboarding, Geoffrey helps them create or sign into GitHub because Geoffrey's
memory lives in a private repo.
It asks whether they already have GitHub and opens signup if they do not.

## Friend Command

Open Terminal, paste this, and press Enter:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/hammbino/Geoffrey_Installer/main/install.sh)"
```

Normal friends do not need a GitHub account to start.

## Daily Use After Setup

Open a new Terminal and type:

```bash
Geoffrey
```

That opens Claude Code in the person's Geoffrey memory repo, starts with the
daily briefing and email/follow-up skills, and syncs memory changes with GitHub
before and after the session.

## Future Updates

After Geoffrey is installed, updates are:

```bash
cd ~/Geoffrey
./bin/geoffrey update
```

Geoffrey also schedules a Mac update check every other week. If a new Geoffrey
version is available, it asks before installing it.

The update keeps private account tokens and the person's memory repo outside the
Geoffrey app folder.
