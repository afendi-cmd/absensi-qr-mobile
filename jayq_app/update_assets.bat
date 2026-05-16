@echo off
echo Installing dependencies...
call flutter pub get

echo.
echo Generating app icons...
call dart run flutter_launcher_icons

echo.
echo Generating splash screen...
call dart run flutter_native_splash:create

echo.
echo Cleaning build...
call flutter clean

echo.
echo Done! Now run: flutter run
pause
