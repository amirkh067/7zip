# Variables
$OldVersion = "23.01"
$NewVersionInstallerURL = "https://www.7-zip.org/a/7z2408-x64.exe" # Update with the correct URL for 7-Zip version 24.08
$InstallerPath = "$env:TEMP\7z2408-x64.exe"

# Function to uninstall old version of 7-Zip
function Uninstall-7Zip {
    Write-Output "Checking for 7-Zip version $OldVersion..."
    $UninstallKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    $InstalledApp = Get-ItemProperty -Path "$UninstallKey\*" | Where-Object {
        $_.DisplayName -match "7-Zip" -and $_.DisplayVersion -eq $OldVersion
    }

    if ($InstalledApp) {
        Write-Output "Uninstalling 7-Zip version $OldVersion..."
        & $InstalledApp.UninstallString /SILENT | Out-Null
        Start-Sleep -Seconds 5
        Write-Output "7-Zip version $OldVersion uninstalled successfully."
    } else {
        Write-Output "7-Zip version $OldVersion is not installed."
    }
}

# Function to install new version of 7-Zip
function Install-7Zip {
    Write-Output "Downloading 7-Zip version 24.08 installer..."
    Invoke-WebRequest -Uri $NewVersionInstallerURL -OutFile $InstallerPath

    Write-Output "Installing 7-Zip version 24.08..."
    Start-Process -FilePath $InstallerPath -ArgumentList "/S" -Wait

    Write-Output "7-Zip version 24.08 installed successfully."
    Remove-Item -Path $InstallerPath -Force
}

# Main Execution
Uninstall-7Zip
Install-7Zip
