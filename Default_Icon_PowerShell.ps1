# Header:
# Dev Herzz09
# Date 09/02/2026
# Name Default_Icon_PowerShell.ps1

#######################################################################
<#
.SYNOPSIS
    Registers template.ps1 in the Windows Explorer "New Item" (ShellNew) menu for .ps1 files.

.DESCRIPTION
    Creates the required registry entry so that Windows displays the option to create
    new PowerShell scripts (.ps1) directly from the Explorer's "New" context menu,
    and places the corresponding template file in C:\Windows\ShellNew.

.NOTES
    Requires administrative privileges (self-elevation included).
#>

#######################################################################
# --- Enforce strict variable usage (catches typos like $ShellNew_Path) ---
Set-StrictMode -Version Latest

#######################################################################
# --- Self-elevate to Administrator ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

#######################################################################
Clear-Host
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "=== PowerShell Template Registrar for ShellNew ===" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

#######################################################################
# --- Declare all paths up front ---
$ShellNewPath     = "C:\Windows\ShellNew"
$WorkingDir       = "$HOME\Desktop"
$RegFileName      = ".\new_powershell.reg"
$TemplateFileName = ".\template.ps1"

#######################################################################
try {
    # --- Ensure the ShellNew folder exists ---
    if (-not (Test-Path -Path $ShellNewPath)) {
        New-Item -Path $ShellNewPath -ItemType Directory -Force -ErrorAction Stop | Out-Null
        Write-Host "[OK] ShellNew folder created at $ShellNewPath" -ForegroundColor Green
    } else {
        Write-Host "[INFO] ShellNew folder already exists." -ForegroundColor Yellow
    }

#######################################################################
    # --- Set working directory ---
    Set-Location -Path $WorkingDir -ErrorAction Stop

#######################################################################
    # --- Build the registry file content ---
    $RegText = @"
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\.ps1]
@="Microsoft.PowerShellScript.1"

[HKEY_CLASSES_ROOT\.ps1\ShellNew]
"FileName"="template.ps1"
"@

#######################################################################
    # --- Create the .reg file ---
    $RegText | Out-File -FilePath $RegFileName -Encoding Unicode -Force -ErrorAction Stop
    Write-Host "[OK] Registry file created: $RegFileName" -ForegroundColor Green

#######################################################################
    # --- Create the empty template.ps1 (initial content for "New Item") ---
    New-Item -Path $TemplateFileName -ItemType File -Force -ErrorAction Stop | Out-Null
    Write-Host "[OK] Template created: $TemplateFileName" -ForegroundColor Green

#######################################################################
    # --- Move both files to ShellNew ---
    Move-Item -Path $RegFileName, $TemplateFileName -Destination $ShellNewPath -Force -ErrorAction Stop
    Write-Host "[OK] Files moved to $ShellNewPath" -ForegroundColor Green

#######################################################################
    Write-Host ""
    Write-Host "=== Process completed successfully! ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Go to C:\Windows\ShellNew and check that the files now exist." -ForegroundColor Gray
    Write-Host "In the end, you can personalize the template.ps1 file with your favorite commands." -ForegroundColor Gray
    Write-Host "Whenever you create a new .ps1 file, it will come pre-filled with the commands from template.ps1" -ForegroundColor Gray
}

#######################################################################
catch {
    Write-Host ""
    Write-Host "[ERROR] Something went wrong during execution:" -ForegroundColor Red
    Write-Host "Line: $($_.InvocationInfo.ScriptLineNumber)  |  Command: $($_.InvocationInfo.Line.Trim())" -ForegroundColor DarkRed
    Write-Host $_.Exception.Message -ForegroundColor Red
}

#######################################################################
finally {
    Write-Host ""
    Pause
}