## About

Create VM on Hyper-V with GPU Passthrough

## Dirs

```ps1
hyper_v
    |
    ---- scripts
    |       |
    |       ---- create.ps1
    |
    ---- images # create dir and set fullpath of iso
    |       |
    |       ---- linux or windows.iso
    |
    ---- volumes
```

## Create

1. create vm at host os

```ps1
Start-Process powershell -ArgumentList "-File D:\hyper_v\scripts\create.ps1" -Verb runAs # set fullpath of create.ps1
```

2. install xrdp at guest os

```terminal
sudo apt update
sudo apt upgrade

sudo apt intstall xrdp
```

3. edit `/etc/xrdp/xrdp.ini` at guest os

```ini
# from port=3389 to port=vsock://-1:3389
# port=3389
port=vsock://-1:3389
```

4. edit `/etc/gdm3/custom.conf` at guest os

```conf
# from # WaylandEnable=false to WaylandEnable=false
WaylandEnable=false
```

5. restart xrdp at guest os

```terminal
sudo systemctl enable xrdp
sudo systemctl restart xrdp

# memo
sudo systemctl status xrdp
```

6. edit `/etc/xrdp/startwm.sh` at guest os

```sh
#!/bin/sh
# xrdp X session start script (c) 2015, 2017, 2021 mirabilos
# published under The MirOS Licence

# Rely on /etc/pam.d/xrdp-sesman using pam_env to load both
# /etc/environment and /etc/default/locale to initialise the
# locale and the user environment properly.

if test -r /etc/profile; then
        . /etc/profile
fi

# ---------------- add bellow ----------------
export DESKTOP_SESSION=ubuntu
export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
# --------------------------------------------

test -x /etc/X11/Xsession && exec /etc/X11/Xsession
exec /bin/sh /etc/X11/Xsession
```
