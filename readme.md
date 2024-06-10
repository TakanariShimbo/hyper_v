## About

Create VM on Hyper-V with GPU Passthrough

## Dirs

```ps1
hyper_v
    ├--- scripts
    |       |
    |       └--- create.ps1
    |
    ├---  images # create dir and set fullpath of iso
    |       |
    |       └--- linux or windows.iso
    |
    └--- volumes
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

7. prepare wsl dir at host os

- nvmdsig.inf_amd64_xxxxxxxxxxxxxxxx

```ps1
explorer.exe "$(Get-CimInstance -ClassName Win32_VideoController -Property * | Select-Object -ExpandProperty InstalledDisplayDrivers | Write-Output)".Split(",")[0].Trim("\nvldumdx.dll")
```

- lib

```ps1
explorer.exe "C:\Windows\System32\lxss\lib"
```

- make wsl dir and arrange like bellow

```
    wsl/
    ├--- lib/
    |
    └--- drivers/
            |
            └--- nv_dispi.inf_amd64_50916785244854f2/
```

8. deploy wsl dir on guest os

- copy wsl from host to guest

- deploy wsl dir to `/usr/lib/wsl`

```terminal
mv ./wsl /usr/lib/wsl
```

- change mod

```terminal
sudo chown -R root:root /usr/lib/wsl
sudo chmod 555 /usr/lib/wsl/lib/*
```

9. add path `/usr/lib/wsl/lib`

- add to `/etc/ld.so.conf.d/ld.wsl.conf`

```
echo "/usr/lib/wsl/lib" | sudo tee /etc/ld.so.conf.d/ld.wsl.conf
```

- apply

```
sudo ldconfig
```

if error `/sbin/ldconfig.real: /usr/lib/wsl/lib/libcuda.so.1 is not a symbolic link` do bellow.

```terminal
cd /usr/lib/wsl/lib/
sudo rm libcuda.so libcuda.so.1
sudo ln -s libcuda.so.1.1 libcuda.so.1
sudo ln -s libcuda.so.1 libcuda.so
sudo ldconfig
```

- add to `/etc/profile.d/wsl.sh`

```
echo "export PATH=$PATH:/usr/lib/wsl/lib" | sudo tee /etc/profile.d/wsl.sh
```

- change mod

```
sudo chmod +x /etc/profile.d/wsl.sh
```

10. add custom kernel

- download headers and image of kernel

```terminal
# https://github.com/brokeDude2901/dxgkrnl_ubuntu/releases/tag/main
wget << headers deb link >>
wget << image deb link >>
```

- install headers and image of kernel

```terminal
sudo apt install -y << headers deb >>
sudo apt install -y << image deb >>
```

- add grub menu

```
sudo sed -i "s/GRUB_DEFAULT=0/GRUB_DEFAULT=saved/g" /etc/default/grub
sudo sed -i "s/GRUB_TIMEOUT_STYLE=hidden/GRUB_TIMEOUT_STYLE=menu/g" /etc/default/grub
sudo sed -i "s/GRUB_TIMEOUT=0/GRUB_TIMEOUT=30/g" /etc/default/grub
sudo grep -q -F "GRUB_SAVEDEFAULT=true" /etc/default/grub || echo "GRUB_SAVEDEFAULT=true" | sudo tee -a /etc/default/grub
sudo update-grub
```

11. open custom kernel

- select `Advanced options for Ubuntu`
- select `Ubuntu, with Linux 5.10.102.1-dxgrknl`
