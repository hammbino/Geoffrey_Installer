# Geoffrey_Installer

This is the public, secrets-free bootstrap for Geoffrey.

It does not contain Geoffrey's OAuth configuration, account data, memory, or
private package files. Its job is only to:

1. Check the Mac setup.
2. Install GitHub CLI through Homebrew if needed.
3. Sign the user into GitHub.
4. Clone the private Geoffrey package.
5. Run Geoffrey's own bootstrap.

## Friend Command

Open Terminal, paste this, and press Enter:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/hammbino/Geoffrey_Installer/main/install.sh)"
```

The friend must be invited to the private `hammbino/Geoffrey-WhiteGlove` repo
before running this.
