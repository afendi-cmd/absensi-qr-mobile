@echo off
echo ========================================
echo   Reinstalling JAYQ App with New Splash
echo ========================================
echo.

echo Step 1: Uninstalling old app...
adb uninstall com.jayq.jayq_app
echo.

echo Step 2: Running Flutter...
flutter run

pause
