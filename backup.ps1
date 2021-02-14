## Configuration
# How many backups to keep before pruning older copies
# 0 keeps all backups
$NumToKeep = 250

#what to backup
$BackupSource = "C:\TestSourceFolder"

# Where to save backups
$BackupDest = "C:\TestDestFolder"

# Name of each unique backup file
$FilePrefix = "Backup_"
$TimeStamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

## Main Script (modify at own risk)
$DestinationPath = "$BackupDest\$FilePrefix$TimeStamp"

# Create the backup directory
$compress = @{
  Path = "$BackupSource\*"
  CompressionLevel = "Fastest"
  DestinationPath = $DestinationPath
}
Compress-Archive @compress

# Prune old backups
if ($NumToKeep -gt 0) {
    $ExistingBackups = Get-ChildItem -Path $BackupDest -Filter "*.zip" -File | Sort-Object -Descending
    for ($i = 0; $i -lt $ExistingBackups.Count; $i++) {
        if ($i -gt ($NumToKeep - 1)) {
            Remove-Item $ExistingBackups[$i] -Recurse -Force
        }
    }
}
