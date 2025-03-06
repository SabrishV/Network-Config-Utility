@echo off
setlocal EnableDelayedExpansion

:: Request administrative privileges if not already running as admin
>nul 2>&1 net session
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /B
)

:: Define interface names
set "INTERFACE_ETH=Ethernet"
set "INTERFACE_WIFI=Wi-Fi"

:select_interface
cls
echo ============================================
echo      Sab's Network Configuration Utility
echo ============================================
echo       Select Interface for Configuration
echo ============================================
echo [1] %INTERFACE_ETH%
echo [2] %INTERFACE_WIFI%
echo ============================================
set /p iface_choice="Enter your choice: "
if "%iface_choice%"=="1" (
    set "INTERFACE=%INTERFACE_ETH%"
) else if "%iface_choice%"=="2" (
    set "INTERFACE=%INTERFACE_WIFI%"
) else (
    echo Invalid selection. Please choose again.
    timeout /t 2 >nul
    goto select_interface
)

goto display_status

:display_status
cls
echo ============================================
echo      Sab's Network Configuration Utility
echo ============================================
echo.
echo Currently selected interface for configuration: %INTERFACE%
echo --------------------------------------------
call :display_interface_details "%INTERFACE%"
echo.
echo [1] Switch to DHCP (Automatic) on %INTERFACE%
echo [2] Home - Static IP on %INTERFACE%
echo [3] Office - Static IP on %INTERFACE%
echo [4] Refresh Status
echo [5] Change Interface Selection
echo [6] Exit
echo ============================================
echo.
set /p choice="Enter your choice: "

if "%choice%"=="1" (
    echo Switching %INTERFACE% to DHCP...
    netsh interface ip set address "%INTERFACE%" dhcp
    netsh interface ip set dns "%INTERFACE%" dhcp
    echo DHCP Mode Enabled Successfully.
    timeout /t 3 >nul
    goto display_status
) else if "%choice%"=="2" (
    echo Setting %INTERFACE% to Home Static IP...
    netsh interface ip set address "%INTERFACE%" static <HOME_STATIC_IP> <HOME_SUBNET_MASK> <HOME_GATEWAY>
    netsh interface ip set dns "%INTERFACE%" static <HOME_DNS_SERVER>
    echo Static IP Set Successfully.
    timeout /t 3 >nul
    goto display_status
) else if "%choice%"=="3" (
    echo Setting %INTERFACE% to Office Static IP...
    netsh interface ip set address "%INTERFACE%" static <OFFICE_STATIC_IP> <OFFICE_SUBNET_MASK> <OFFICE_GATEWAY>
    netsh interface ip set dns "%INTERFACE%" static <OFFICE_DNS_SERVER>
    echo Static IP Set Successfully.
    timeout /t 3 >nul
    goto display_status
) else if "%choice%"=="4" (
    goto display_status
) else if "%choice%"=="5" (
    goto select_interface
) else if "%choice%"=="6" (
    echo Exiting...
    exit /B
) else (
    echo Invalid choice! Please try again.
    timeout /t 2 >nul
    goto display_status
)

:display_interface_details
:: %1 is the interface name passed in
set "intf=%~1"
echo Interface: %intf%
echo --------------------------------------------

if /I "%intf%"=="Wi-Fi" (
    echo --- Wi-Fi Details ---
    :: Extract SSID, BSSID, and Signal from netsh wlan show interfaces
    for /f "tokens=2* delims=:" %%A in ('netsh wlan show interfaces ^| findstr /R /C:"^\s*SSID\s*:"') do (
        set "SSID=%%B"
    )
    for /f "tokens=2* delims=:" %%A in ('netsh wlan show interfaces ^| findstr /R /C:"^\s*BSSID\s*:"') do (
        set "BSSID=%%B"
    )
    for /f "tokens=2* delims=:" %%A in ('netsh wlan show interfaces ^| findstr /R /C:"^\s*Signal\s*:"') do (
        set "Signal=%%B"
    )
    for /f "tokens=* delims= " %%B in ("!SSID!") do set "SSID=%%B"
    for /f "tokens=* delims= " %%B in ("!BSSID!") do set "BSSID=%%B"
    for /f "tokens=* delims= " %%B in ("!Signal!") do set "Signal=%%B"
    echo SSID              : !SSID!
    echo BSSID             : !BSSID!
    echo Signal Strength   : !Signal!
    echo ---------------------------
)

:: Detect DHCP Mode using netsh
set "MODE=UNKNOWN"
for /f "tokens=2 delims=:" %%A in ('netsh interface ipv4 show config name^="%intf%" ^| findstr /i /c:"DHCP enabled"') do (
    set "MODE=%%A"
)
:: Trim any leading spaces
for /f "tokens=* delims= " %%B in ("!MODE!") do set "MODE=%%B"
if /I "!MODE!"=="Yes" (
    echo Current Mode      : DHCP (Automatic)
) else if /I "!MODE!"=="No" (
    echo Current Mode      : STATIC (Manual)
) else (
    echo Current Mode      : UNKNOWN
)

:: Get current IP address
set "CURRENT_IP=UNKNOWN"
for /f "tokens=2 delims=:" %%A in ('netsh interface ip show address name^="%intf%" ^| findstr /C:"IP Address"') do (
    set "CURRENT_IP=%%A"
)
for /f "tokens=* delims= " %%B in ("!CURRENT_IP!") do set "CURRENT_IP=%%B"

:: Get Subnet Mask from netsh interface ipv4 show config
set "SUBNET_MASK=UNKNOWN"
for /f "tokens=2 delims=:" %%A in ('netsh interface ipv4 show config name^="%intf%" ^| findstr /C:"Subnet Prefix"') do (
    set "SUBNET_MASK=%%A"
)
for /f "tokens=1 delims=/" %%A in ("!SUBNET_MASK!") do set "SUBNET_MASK=%%A"
for /f "tokens=* delims= " %%B in ("!SUBNET_MASK!") do set "SUBNET_MASK=%%B"

:: Get Default Gateway
set "GATEWAY=UNKNOWN"
for /f "tokens=2 delims=:" %%A in ('netsh interface ipv4 show config name^="%intf%" ^| findstr /C:"Default Gateway"') do (
    set "GATEWAY=%%A"
)
for /f "tokens=* delims= " %%B in ("!GATEWAY!") do set "GATEWAY=%%B"

:: Get DNS Server(s)
set "DNS_SERVER=UNKNOWN"
for /f "tokens=2 delims=:" %%A in ('netsh interface ipv4 show config name^="%intf%" ^| findstr /C:"DNS Servers"') do (
    set "DNS_SERVER=%%A"
)
for /f "tokens=* delims= " %%B in ("!DNS_SERVER!") do set "DNS_SERVER=%%B"

echo IP Address          : !CURRENT_IP!
echo Subnet Mask         : !SUBNET_MASK!
echo Default Gateway     : !GATEWAY!
echo DNS Server(s)       : !DNS_SERVER!
echo --------------------------------------------
goto :EOF
