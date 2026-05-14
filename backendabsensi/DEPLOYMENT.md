# 🚀 Deployment Guide - JAYQ Backend API

Panduan deployment backend JAYQ ke production server.

## 📋 Pre-Deployment Checklist

- [ ] Server dengan PHP 8.3+ terinstall
- [ ] MySQL database tersedia
- [ ] Composer terinstall
- [ ] Domain/subdomain sudah disiapkan
- [ ] SSL certificate (HTTPS)
- [ ] Backup database (jika update)

## 🖥️ Server Requirements

### Minimum Requirements

- **PHP**: 8.3 or higher
- **MySQL**: 5.7 or higher / MariaDB 10.3+
- **Memory**: 512MB RAM minimum
- **Storage**: 1GB free space
- **Web Server**: Apache/Nginx

### PHP Extensions Required

- BCMath
- Ctype
- Fileinfo
- JSON
- Mbstring
- OpenSSL
- PDO
- Tokenizer
- XML

## 🔧 Deployment Steps

### 1. Upload Files to Server

#### Via Git (Recommended)

```bash
cd /var/www/html
git clone <repository-url> jayq-backend
cd jayq-backend
```

#### Via FTP/SFTP

Upload semua file kecuali:

- `.git/`
- `node_modules/`
- `vendor/`
- `.env`

### 2. Install Dependencies

```bash
composer install --optimize-autoloader --no-dev
```

### 3. Setup Environment

```bash
cp .env.example .env
nano .env
```

Edit `.env` untuk production:

```env
APP_NAME="JAYQ Backend"
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_URL=https://api.yourdomain.com

DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=your_production_db
DB_USERNAME=your_db_user
DB_PASSWORD=your_secure_password

# Sanctum
SANCTUM_STATEFUL_DOMAINS=yourdomain.com,www.yourdomain.com
```

### 4. Generate Application Key

```bash
php artisan key:generate
```

### 5. Run Migrations

```bash
php artisan migrate --force
```

### 6. Seed Database (First Time Only)

```bash
php artisan db:seed --force
```

### 7. Create Storage Link

```bash
php artisan storage:link
```

### 8. Set Permissions

```bash
chmod -R 755 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
```

### 9. Optimize for Production

```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

## 🌐 Web Server Configuration

### Apache Configuration

Create `.htaccess` in public directory (already included):

```apache
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteRule ^(.*)$ public/$1 [L]
</IfModule>
```

Virtual Host configuration:

```apache
<VirtualHost *:80>
    ServerName api.yourdomain.com
    DocumentRoot /var/www/html/jayq-backend/public

    <Directory /var/www/html/jayq-backend/public>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/jayq-error.log
    CustomLog ${APACHE_LOG_DIR}/jayq-access.log combined
</VirtualHost>
```

Enable required modules:

```bash
sudo a2enmod rewrite
sudo systemctl restart apache2
```

### Nginx Configuration

```nginx
server {
    listen 80;
    server_name api.yourdomain.com;
    root /var/www/html/jayq-backend/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    index index.php;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
```

Restart Nginx:

```bash
sudo systemctl restart nginx
```

## 🔒 SSL/HTTPS Setup

### Using Let's Encrypt (Free)

```bash
sudo apt install certbot python3-certbot-apache
sudo certbot --apache -d api.yourdomain.com
```

For Nginx:

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d api.yourdomain.com
```

Auto-renewal:

```bash
sudo certbot renew --dry-run
```

## 🗄️ Database Backup

### Manual Backup

```bash
mysqldump -u username -p database_name > backup_$(date +%Y%m%d).sql
```

### Automated Daily Backup (Cron)

```bash
crontab -e
```

Add:

```bash
0 2 * * * mysqldump -u username -p'password' database_name > /backups/jayq_$(date +\%Y\%m\%d).sql
```

## 📊 Monitoring & Maintenance

### Check Application Status

```bash
php artisan about
```

### View Logs

```bash
tail -f storage/logs/laravel.log
```

### Clear Cache

```bash
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

### Update Application

```bash
git pull origin main
composer install --optimize-autoloader --no-dev
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

## 🔐 Security Best Practices

### 1. Environment File

- ✅ Never commit `.env` to version control
- ✅ Use strong database passwords
- ✅ Set `APP_DEBUG=false` in production
- ✅ Set `APP_ENV=production`

### 2. File Permissions

```bash
# Directories
find . -type d -exec chmod 755 {} \;

# Files
find . -type f -exec chmod 644 {} \;

# Storage & Cache
chmod -R 775 storage bootstrap/cache
```

### 3. Database Security

- ✅ Use separate database user with limited privileges
- ✅ Don't use root user
- ✅ Enable MySQL firewall rules

### 4. Server Security

- ✅ Keep PHP and MySQL updated
- ✅ Use firewall (UFW/iptables)
- ✅ Disable directory listing
- ✅ Hide PHP version
- ✅ Regular security updates

### 5. API Security

- ✅ Rate limiting enabled
- ✅ CORS properly configured
- ✅ Token expiration set
- ✅ Input validation on all endpoints

## 🚨 Troubleshooting

### 500 Internal Server Error

1. Check file permissions
2. Check `.env` configuration
3. Check error logs: `storage/logs/laravel.log`
4. Clear cache: `php artisan cache:clear`

### Database Connection Error

1. Verify database credentials in `.env`
2. Check MySQL is running: `sudo systemctl status mysql`
3. Test connection: `mysql -u username -p`

### Storage Files Not Accessible

1. Check storage link: `php artisan storage:link`
2. Check permissions: `chmod -R 775 storage`
3. Check web server configuration

### API Returns 404

1. Check web server configuration
2. Verify document root points to `/public`
3. Check `.htaccess` or Nginx config

## 📈 Performance Optimization

### 1. Enable OPcache

Edit `php.ini`:

```ini
opcache.enable=1
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=60
```

### 2. Use Queue Workers

```bash
php artisan queue:work --daemon
```

Setup supervisor for queue workers:

```ini
[program:jayq-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/html/jayq-backend/artisan queue:work --sleep=3 --tries=3
autostart=true
autorestart=true
user=www-data
numprocs=2
redirect_stderr=true
stdout_logfile=/var/www/html/jayq-backend/storage/logs/worker.log
```

### 3. Enable Response Caching

```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

### 4. Database Optimization

```sql
-- Add indexes for frequently queried columns
ALTER TABLE absensi ADD INDEX idx_mahasiswa_tanggal (mahasiswa_id, tanggal);
ALTER TABLE pengumpulan_tugas ADD INDEX idx_tugas_mahasiswa (tugas_id, mahasiswa_id);
```

## 🔄 CI/CD Setup (Optional)

### GitHub Actions Example

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Production

on:
    push:
        branches: [main]

jobs:
    deploy:
        runs-on: ubuntu-latest
        steps:
            - name: Deploy to server
              uses: appleboy/ssh-action@master
              with:
                  host: ${{ secrets.HOST }}
                  username: ${{ secrets.USERNAME }}
                  key: ${{ secrets.SSH_KEY }}
                  script: |
                      cd /var/www/html/jayq-backend
                      git pull origin main
                      composer install --optimize-autoloader --no-dev
                      php artisan migrate --force
                      php artisan config:cache
                      php artisan route:cache
                      php artisan view:cache
```

## 📞 Support & Maintenance

### Regular Maintenance Tasks

- [ ] Weekly: Check error logs
- [ ] Weekly: Database backup verification
- [ ] Monthly: Update dependencies
- [ ] Monthly: Security audit
- [ ] Quarterly: Performance review

### Monitoring Tools (Recommended)

- Laravel Telescope (development)
- New Relic / DataDog (production)
- Sentry for error tracking
- Uptime monitoring (UptimeRobot, Pingdom)

## ✅ Post-Deployment Checklist

- [ ] API accessible via HTTPS
- [ ] All endpoints responding correctly
- [ ] Database migrations completed
- [ ] Storage files accessible
- [ ] Logs are being written
- [ ] Backups configured
- [ ] SSL certificate valid
- [ ] Performance optimizations applied
- [ ] Security measures in place
- [ ] Monitoring tools configured

## 🎉 Deployment Complete!

Your JAYQ Backend API is now live in production!

**API URL**: https://api.yourdomain.com/api

Remember to:

- Monitor logs regularly
- Keep backups updated
- Update dependencies periodically
- Review security practices

---

For issues or questions, contact the development team.
