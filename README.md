# Flatpak packaging for [x11-calc](https://github.com/mike632t/x11-calc) HP RPN calculator emulator

Application icon should appear in launcher after install.\
It can also be launched under terminal (to monitor eventual error messages):\
`flatpak run io.github.mike632t.x11-calc`

User can launch any of the project emulator.\
Preferred calculator model name can be set right-clicking on application icon, or running in terminal:\
`flatpak run io.github.mike632t.x11-calc --setup`\
or similarly editing:\
`nano ~/.var/app/io.github.mike632t.x11-calc/config/x11-calc/x11-calc.conf`

Some sample saved programs are in `/app/share/x11-calc/prg/`

Voyager models (hp10c, hp11c, hp12c, hp15c, hp16c) can be used if relevant rom file is supplied at:\
`~/.var/app/io.github.mike632t.x11-calc/data/x11-calc/x11-calc-"${MODEL#hp}".rom`

## Building & testing
Install flatpak-builder.
Copy / clone this repo in a directory and then run:\
`flatpak-builder -v --force-clean build-dir io.github.mike632t.x11-calc.yaml`\
Test install:\
`flatpak-builder --user --install --force-clean build-dir io.github.mike632t.x11-calc.yaml`

Once ready, extract side-loadable `x11-calc.flatpak` package for later distribution:\
`flatpak build-bundle ~/.local/share/flatpak/repo x11-calc.flatpak io.github.mike632t.x11-calc`

