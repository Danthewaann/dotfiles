# dotfiles

My dotfiles and environment setup scripts

Run the following to run the `bootstrap` and `install` scripts:

```bash
./bootstrap && ./install
```

If running on macos, run the following instead:

```bash
./macsetup && ./bootstrap && ./install
```

## other stuff

On M1 MacBooks do the folloing to fix slow iterm2 startup times (from https://superuser.com/a/458059):

- Preferences → Profiles → General → Command: Change from "Login Shell" to "Command: /bin/zsh -l"
