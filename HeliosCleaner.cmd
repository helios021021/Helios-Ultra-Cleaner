:: --- HELIOS AUTO-UPDATER BASLANGICI ---
set "CURRENT_VERSION=1.0"
set "VERSION_URL=https://raw.githubusercontent.com/helios021021/Helios-Ultra-Cleaner/main/version.txt"
set "UPDATE_URL=https://raw.githubusercontent.com/helios021021/Helios-Ultra-Cleaner/main/HeliosUltraCleaner.cmd"

for /f "delims=" %%i in ('powershell -command "(Invoke-WebRequest -Uri '%VERSION_URL%' -UseBasicParsing).Content.Trim()" 2^>nul') do set "LATEST_VERSION=%%i"

if "%LATEST_VERSION%"=="" goto :StartApp
if "%CURRENT_VERSION%"=="%LATEST_VERSION%" goto :StartApp

powershell -WindowStyle Hidden -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Helios Ultra Cleaner icin yeni bir surum (v%LATEST_VERSION%) bulundu. Guncelleme yapiliyor, lutfen bekleyin...', 'Helios Auto-Updater', 'OK', 'Information')"

powershell -command "Invoke-WebRequest -Uri '%UPDATE_URL%' -OutFile '%temp%\HeliosUpdated.cmd'"
if exist "%temp%\HeliosUpdated.cmd" (
    move /y "%temp%\HeliosUpdated.cmd" "%~f0" >nul
    start "" "%~f0"
    exit /B
)
:StartApp
:: --- HELIOS AUTO-UPDATER BITISI ---


@echo off
title HELIOS ULTRA CLEANER
net session >nul 2>&1
if %errorLevel% NEQ 0 (powershell -WindowStyle Hidden -Command "Start-Process -FilePath '%~dpnx0' -Verb RunAs"; exit /B)
cd /d "%~dp0"

powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command "$lines = Get-Content '%~f0'; $start = $lines.IndexOf('# --- GUI BASLANGICI ---'); $code = $lines[($start+1)..($lines.Count-1)] -join [Environment]::NewLine; Invoke-Expression $code"
exit /B

# --- GUI BASLANGICI ---
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "HELIOS ULTRA CLEANER"
$form.Size = New-Object System.Drawing.Size(400, 500)
$form.BackColor = [System.Drawing.Color]::Black
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

$colorYellow = [System.Drawing.Color]::Yellow
$colorGray = [System.Drawing.Color]::DimGray
$fontBtn = New-Object System.Drawing.Font("Consolas", 12, [System.Drawing.FontStyle]::Bold)

$toolTip = New-Object System.Windows.Forms.ToolTip

# Butonlar
$btnMod1 = New-Object System.Windows.Forms.Button; $btnMod1.Text = "MOD 1: HIZLI"; $btnMod1.Size = New-Object System.Drawing.Size(300, 60); $btnMod1.Location = New-Object System.Drawing.Point(50, 50); $btnMod1.BackColor = $colorGray; $btnMod1.ForeColor = $colorYellow; $btnMod1.Font = $fontBtn; $form.Controls.Add($btnMod1)
$btnMod2 = New-Object System.Windows.Forms.Button; $btnMod2.Text = "MOD 2: DERIN"; $btnMod2.Size = New-Object System.Drawing.Size(300, 60); $btnMod2.Location = New-Object System.Drawing.Point(50, 130); $btnMod2.BackColor = $colorGray; $btnMod2.ForeColor = $colorYellow; $btnMod2.Font = $fontBtn; $form.Controls.Add($btnMod2)
$btnMod3 = New-Object System.Windows.Forms.Button; $btnMod3.Text = "MOD 3: ULTRA TEMIZLIK"; $btnMod3.Size = New-Object System.Drawing.Size(300, 60); $btnMod3.Location = New-Object System.Drawing.Point(50, 210); $btnMod3.BackColor = $colorGray; $btnMod3.ForeColor = $colorYellow; $btnMod3.Font = $fontBtn; $form.Controls.Add($btnMod3)

# ToolTip Metinleri
$toolTip.SetToolTip($btnMod1, "Mod 1: Gecici (Temp) dosyalar temizlenir. Gunluk bakim.")
$toolTip.SetToolTip($btnMod2, "Mod 2: DNS, Cop Kutusu ve Windows Update artiklari silinir.")
$toolTip.SetToolTip($btnMod3, "Mod 3: Sistem imaji ve eski guncelleme yedekleri temizlenir. Geri donus saglanamaz.")

$lblStatus = New-Object System.Windows.Forms.Label; $lblStatus.Size = New-Object System.Drawing.Size(300, 100); $lblStatus.Location = New-Object System.Drawing.Point(50, 310); $lblStatus.ForeColor = $colorYellow; $lblStatus.Font = New-Object System.Drawing.Font("Consolas", 10); $form.Controls.Add($lblStatus)

# Geliştirici İmzası
$lblDev = New-Object System.Windows.Forms.Label; $lblDev.Text = "Gelistirici: Helios"; $lblDev.Size = New-Object System.Drawing.Size(300, 20); $lblDev.Location = New-Object System.Drawing.Point(50, 430); $lblDev.ForeColor = $colorGray; $lblDev.Font = New-Object System.Drawing.Font("Consolas", 8, [System.Drawing.FontStyle]::Italic); $form.Controls.Add($lblDev)

# Olaylar
$btnMod1.Add_Click({ $lblStatus.Text = "Hizli temizlik yapiliyor..."; $form.Refresh(); del /s /f /q %temp%\*.* >$null 2>&1; $lblStatus.Text = "Islem Tamamlandi!" })
$btnMod2.Add_Click({ $lblStatus.Text = "Derin temizlik yapiliyor..."; $form.Refresh(); ipconfig /flushdns >$null 2>&1; rd /s /q C:\$Recycle.Bin >$null 2>&1; del /f /s /q C:\Windows\SoftwareDistribution\Download\*.* >$null 2>&1; $lblStatus.Text = "Islem Tamamlandi!" })
$btnMod3.Add_Click({ $lblStatus.Text = "ULTRA TEMIZLIK YAPILIYOR..."; $form.Refresh(); dism /online /cleanup-image /startcomponentcleanup /resetbase >$null 2>&1; cleanmgr /sagerun:1 >$null 2>&1; $lblStatus.Text = "Ultra temizlik tamamlandi!" })

$form.ShowDialog() | Out-Null