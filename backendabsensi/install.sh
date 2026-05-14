#!/bin/bash

# JAYQ Backend API - Installation Script
# This script automates the installation process

echo "=========================================="
echo "  JAYQ Backend API - Installation Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if composer is installed
if ! command -v composer &> /dev/null
then
    echo -e "${RED}Error: Composer is not installed${NC}"
    echo "Please install Composer first: https://getcomposer.org/"
    exit 1
fi

# Check if PHP is installed
if ! command -v php &> /dev/null
then
    echo -e "${RED}Error: PHP is not installed${NC}"
    echo "Please install PHP 8.3 or higher"
    exit 1
fi

# Check PHP version
PHP_VERSION=$(php -r "echo PHP_VERSION;")
echo -e "${GREEN}✓${NC} PHP version: $PHP_VERSION"

# Check if MySQL is running
if ! command -v mysql &> /dev/null
then
    echo -e "${YELLOW}Warning: MySQL command not found${NC}"
    echo "Make sure MySQL is installed and running"
fi

echo ""
echo "Step 1: Installing Composer dependencies..."
composer install --optimize-autoloader

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Composer install failed${NC}"
    exit 1
fi
echo -e "${GREEN}✓${NC} Composer dependencies installed"

echo ""
echo "Step 2: Setting up environment file..."
if [ ! -f .env ]; then
    cp .env.example .env
    echo -e "${GREEN}✓${NC} .env file created"
else
    echo -e "${YELLOW}!${NC} .env file already exists, skipping..."
fi

echo ""
echo "Step 3: Generating application key..."
php artisan key:generate
echo -e "${GREEN}✓${NC} Application key generated"

echo ""
echo "=========================================="
echo "  Database Configuration"
echo "=========================================="
echo ""
echo "Please enter your database details:"
read -p "Database name [absensi_qr_mobile]: " DB_NAME
DB_NAME=${DB_NAME:-absensi_qr_mobile}

read -p "Database username [root]: " DB_USER
DB_USER=${DB_USER:-root}

read -sp "Database password: " DB_PASS
echo ""

# Update .env file
sed -i "s/DB_DATABASE=.*/DB_DATABASE=$DB_NAME/" .env
sed -i "s/DB_USERNAME=.*/DB_USERNAME=$DB_USER/" .env
sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$DB_PASS/" .env

echo -e "${GREEN}✓${NC} Database configuration updated"

echo ""
echo "Step 4: Creating database..."
mysql -u$DB_USER -p$DB_PASS -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;" 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Database created successfully"
else
    echo -e "${YELLOW}!${NC} Could not create database automatically"
    echo "Please create the database manually: CREATE DATABASE $DB_NAME;"
    read -p "Press Enter when database is ready..."
fi

echo ""
echo "Step 5: Running migrations..."
php artisan migrate --force

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Migration failed${NC}"
    echo "Please check your database configuration"
    exit 1
fi
echo -e "${GREEN}✓${NC} Migrations completed"

echo ""
echo "Step 6: Seeding database with sample data..."
php artisan db:seed --force
echo -e "${GREEN}✓${NC} Database seeded"

echo ""
echo "Step 7: Creating storage link..."
php artisan storage:link
echo -e "${GREEN}✓${NC} Storage link created"

echo ""
echo "Step 8: Setting permissions..."
chmod -R 775 storage bootstrap/cache
echo -e "${GREEN}✓${NC} Permissions set"

echo ""
echo "=========================================="
echo "  Installation Complete! 🎉"
echo "=========================================="
echo ""
echo "Default Login Credentials:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Admin:"
echo "  Email: admin@jayq.com"
echo "  Password: password"
echo ""
echo "Dosen:"
echo "  Email: budi@jayq.com / siti@jayq.com"
echo "  Password: password"
echo ""
echo "Mahasiswa:"
echo "  Email: ahmad@jayq.com / dewi@jayq.com / eko@jayq.com"
echo "  Password: password"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "To start the development server, run:"
echo "  php artisan serve"
echo ""
echo "API will be available at:"
echo "  http://localhost:8000/api"
echo ""
echo "For more information, read:"
echo "  - README.md"
echo "  - QUICK_START.md"
echo "  - API_DOCUMENTATION.md"
echo ""
echo "Happy coding! 🚀"
