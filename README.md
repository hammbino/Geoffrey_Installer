# Geoffrey_Installer

This is the public, secrets-free bootstrap for Geoffrey.

Its job is only to:

1. Download the public Geoffrey package.
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
