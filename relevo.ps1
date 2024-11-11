# Obtener el nombre del equipo para usarlo como nombre del archivo
$computerName = (Get-WmiObject Win32_ComputerSystem).Name
$outputFile = "$PSScriptRoot\$computerName.txt"

# Información del sistema
$systemInfo = @()

# Obtener información de la placa madre
$motherboard = Get-WmiObject Win32_BaseBoard
$systemInfo += "Placa Madre: $($motherboard.Manufacturer) $($motherboard.Product)"

# Obtener información de la memoria RAM
$ram = Get-WmiObject Win32_PhysicalMemory | ForEach-Object {
    $ramType = $_.MemoryType
    switch ($ramType) {
        20 { $ramType = "DDR" }
        21 { $ramType = "DDR2" }
        24 { $ramType = "DDR3" }
        26 { $ramType = "DDR4" }
        default { $ramType = "Desconocido" }
    }
    "RAM: $($_.Capacity / 1GB) GB - Tipo: $ramType"
}
$systemInfo += $ram

# Obtener información de almacenamiento (discos duros)
$disks = Get-WmiObject Win32_DiskDrive | ForEach-Object {
    $diskType = if ($_.MediaType -match "Solid State") { "SSD" } else { "HDD" }
    "Disco: $($_.Model) - Tamaño: $([math]::Round($_.Size / 1GB, 2)) GB - Tipo: $diskType"
}
$systemInfo += $disks

# Obtener información del procesador
$cpu = Get-WmiObject Win32_Processor
$systemInfo += "Procesador: $($cpu.Name)"

# Guardar la información en un archivo .txt en el directorio del script
$systemInfo | Out-File -FilePath $outputFile -Encoding utf8

Write-Output "Información guardada en $outputFile"
