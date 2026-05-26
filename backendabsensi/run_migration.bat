@echo off
echo Running migration for pengumuman_reads table...
php artisan migrate
echo.
echo Migration complete!
pause
