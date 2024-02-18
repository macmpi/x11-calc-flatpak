# x11-calc-flatpak

This is a preliminary [x-11-calc](https://github.com/mike632t/x11-calc) flatpak distribution package for HP calc simulators.

[Sample x86-64 package](https://github.com/macmpi/x11-calc-flatpak/releases/download/v0.1/x11-calc.flatpak) can be installed on most distributions with:\
`flatpak install x11-calc.flatpak`\
Application icon should then appear in launcher.\
It can also be launched under terminal (to monitor eventual error messages):\
`flatpak run io.github.mike632t.x11_calc`

User can launch any of the project calculator simulator. Preferred calculator model reference can be set by running in terminal:\
`flatpak run io.github.mike632t.x11_calc --setup`\
or similarly editing:\
`nano ~/.var/app/io.github.mike632t.x11_calc/config/x11-calc/x11-calc.conf`\
(default is `MODEL=25c`)

Voyager models (10c, 11c, 12c, 15c, 16c) can be used if relevant rom file is supplied at:\
`~/.var/app/io.github.mike632t.x11_calc/data/x11-calc/$MODEL.rom`

## Building & testing
Install flatpak-builder.
Copy / clone this repo in a directory and then run:\
`flatpak-builder -v --force-clean build-dir io.github.mike632t.x11_calc.yaml`\
Test install:\
`flatpak-builder --user --install --force-clean build-dir io.github.mike632t.x11_calc.yaml`

Once ready, extract side-loadable `x11-calc.flatpak` package for later distribution:\
`flatpak build-bundle ~/.local/share/flatpak/repo x11-calc.flatpak io.github.mike632t.x11_calc master`

