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

```ps1
Start-Process powershell -ArgumentList "-File D:\hyper_v\scripts\create.ps1" -Verb runAs # set fullpath of create.ps1
```
