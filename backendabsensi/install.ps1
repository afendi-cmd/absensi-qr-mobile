# JAYQ Backend API - Installation Script (PowerShell)
# This script automates the installation process for Windows

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  JAYQ Backend API - Installation Script" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if composer is installed
try {
    $composerVersion = composer --version 2>$null
    Write-Host "✓ Composer is installed" -ForegroundColor Green
} catch {
    Write-Host "✗ Error: Composer is not installed" -ForegroundColor Red
    Write-Host "Please install Composer first: https://getcomposer.org/" -ForegroundColor Yellow
    exit 1
}

# Check if PHP is installed
try {
    $phpVersion = php -r "echo PHP_VERSION;" 2>$null
    Write-Host "✓ PHP version: $phpVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Error: PHP is not installed" -ForegroundColor Red
    Write-Host "Please install PHP 8.3 or higher" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Step 1: Installing Composer dependencies..." -ForegroundColor Yellow
composer install --optimize-autoloader

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error: Composer install failed" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Composer dependencies installed" -ForegroundColor Green

Write-Host ""
Write-Host "Step 2: Setting up environment file..." -ForegroundColor Yellow
if (-not (Test-Path .env)) {
    Copy-Item .env.example .env
    Write-Host "✓ .env file created" -ForegroundColor Green
} else {
    Write-Host "! .env file already exists, skipping..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Step 3: Generating application key..." -ForegroundColor Yellow
php artisan key:generate
Write-Host "✓ Application key generated" -ForegroundColor Green

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Database Configuration" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Please enter your database details:"

$DB_NAME = Read-Host "Database name [absensi_qr_mobile]"
if ([string]::IsNullOrWhiteSpace($DB_NAME)) {
    $DB_NAME = "absensi_qr_mobile"
}

$DB_USER = Read-Host "Database username [root]"
if ([string]::IsNullOrWhiteSpace($DB_USER)) {
    $DB_USER = "root"
}

$DB_PASS = Read-Host "Database password" -AsSecureString
$DB_PASS_Plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($DB_PASS))

# Update .env file
$envContent = Get-Content .env
$envContent = $envContent -replace "DB_DATABASE=.*", "DB_DATABASE=$DB_NAME"
$envContent = $envContent -replace "DB_USERNAME=.*", "DB_USERNAME=$DB_USER"
$envContent = $envContent -replace "DB_PASSWORD=.*", "DB_PASSWORD=$DB_PASS_Plain"
$envContent | Set-Content .env

Write-Host "✓ Database configuration updated" -ForegroundColor Green

Write-Host ""
Write-Host "Step 4: Creating database..." -ForegroundColor Yellow
Write-Host "! Please create the database manually if it doesn't exist:" -ForegroundColor Yellow
Write-Host "  CREATE DATABASE $DB_NAME;" -ForegroundColor Cyan
$confirmation = Read-Host "Press Enter when database is ready"

Write-Host ""
Write-Host "Step 5: Running migrations..." -ForegroundColor Yellow
php artisan migrate --force

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error: Migration failed" -ForegroundColor Red
    Write-Host "Please check your database configuration" -ForegroundColor Yellow
    exit 1
}
Write-Host "✓ Migrations completed" -ForegroundColor Green

Write-Host ""
Write-Host "Step 6: Seeding database with sample data..." -ForegroundColor Yellow
php artisan db:seed --force
Write-Host "✓ Database seeded" -ForegroundColor Green

Write-Host ""
Write-Host "Step 7: Creating storage link..." -ForegroundColor Yellow
php artisan storage:link
Write-Host "✓ Storage link created" -ForegroundColor Green

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Installation Complete! 🎉" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Default Login Credentials:" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "Admin:" -ForegroundColor Cyan
Write-Host "  Email: admin@jayq.com"
Write-Host "  Password: password"
Write-Host ""
Write-Host "Dosen:" -ForegroundColor Cyan
Write-Host "  Email: budi@jayq.com / siti@jayq.com"
Write-Host "  Password: password"
Write-Host ""
Write-Host "Mahasiswa:" -ForegroundColor Cyan
Write-Host "  Email: ahmad@jayq.com / dewi@jayq.com / eko@jayq.com"
Write-Host "  Password: password"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host ""
Write-Host "To start the development server, run:" -ForegroundColor Yellow
Write-Host "  php artisan serve" -ForegroundColor Cyan
Write-Host ""
Write-Host "API will be available at:" -ForegroundColor Yellow
Write-Host "  http://localhost:8000/api" -ForegroundColor Cyan
Write-Host ""
Write-Host "For more information, read:" -ForegroundColor Yellow
Write-Host "  - README.md"
Write-Host "  - QUICK_START.md"
Write-Host "  - API_DOCUMENTATION.md"
Write-Host ""
Write-Host "Happy coding! 🚀" -ForegroundColor Green
