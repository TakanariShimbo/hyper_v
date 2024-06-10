$VMName = "ubuntu2204-vm"
$Switch = "Default Switch"
$ProjectPath = "D:\hyper_v" # set fullpath of project dir
$VMPath = "$ProjectPath\volumes\$VMName"
$VHDPath = "$VMPath\$VMName.vhdx"
$InstallMedia = "$ProjectPath\images\ubuntu-ja-22.04-desktop-amd64.iso" # set fullpath of iso
$CPUCores = 4
$MemoryStartupBytes = 16GB
$MemoryMinimumBytes = 512MB
$DiskSizeBytes = 96GB
$MinVRAM = 80000000
$MaxVRAM = 100000000


New-VM -Name $VMName `
    -MemoryStartupBytes $MemoryStartupBytes `
    -Generation 2 `
    -NewVHDPath $VHDPath `
    -NewVHDSizeBytes $DiskSizeBytes `
    -Path $VMPath `
    -SwitchName $Switch


Set-VMProcessor -VMName $VMName `
    -Count $CPUCores

Set-VMMemory -VMName $VMName `
    -DynamicMemoryEnabled $true `
    -MinimumBytes $MemoryMinimumBytes `
    -StartupBytes $MemoryStartupBytes `
    -MaximumBytes $MemoryStartupBytes


Add-VMDvdDrive -VMName $VMName `
    -Path $InstallMedia

$DVDDrive = Get-VMDvdDrive -VMName $VMName

Set-VMFirmware -VMName $VMName `
    -FirstBootDevice $DVDDrive `
    -EnableSecureBoot Off


Set-VM -Name $VMName `
    -CheckpointType Disabled


Set-VM -VMName $VMName `
    -EnhancedSessionTransportType HvSocket


Add-VMGpuPartitionAdapter -VMName $VMName

Set-VMGpuPartitionAdapter -VMName $VMName `
    -MinPartitionVRAM $MinVRAM `
    -MaxPartitionVRAM $MaxVRAM `
    -OptimalPartitionVRAM $MaxVRAM `
    -MinPartitionEncode $MinVRAM `
    -MaxPartitionEncode $MaxVRAM `
    -OptimalPartitionEncode $MaxVRAM `
    -MinPartitionDecode $MinVRAM `
    -MaxPartitionDecode $MaxVRAM `
    -OptimalPartitionDecode $MaxVRAM `
    -MinPartitionCompute $MinVRAM `
    -MaxPartitionCompute $MaxVRAM `
    -OptimalPartitionCompute $MaxVRAM
