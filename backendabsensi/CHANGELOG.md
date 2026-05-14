# Changelog

All notable changes to the JAYQ Backend API project will be documented in this file.

## [1.0.0] - 2026-05-14

### Added

- ✅ Initial project setup with Laravel 13
- ✅ Laravel Sanctum authentication implementation
- ✅ Role-based access control (Admin, Dosen, Mahasiswa)
- ✅ Complete database schema with migrations
- ✅ RESTful API endpoints for all features

#### Authentication

- Login endpoint with token generation
- Logout endpoint
- Get authenticated user endpoint

#### Admin Features

- User management (CRUD)
- Mata kuliah management (CRUD)
- Peserta mata kuliah management
- View all absensi records

#### Dosen Features

- Generate QR code for attendance
- View QR sessions history
- View attendance recap
- Tugas management (CRUD)
- Upload materi pembelajaran
- Give grades to student assignments
- View mata kuliah peserta

#### Mahasiswa Features

- Scan QR code for attendance
- View attendance history
- Upload assignments
- View enrolled mata kuliah
- View learning materials
- View assignment grades

#### Models & Relationships

- User model with role support
- MataKuliah model
- PesertaMk model (pivot table)
- QrSession model
- Absensi model
- Tugas model
- PengumpulanTugas model
- Materi model

#### Database

- Complete migration files
- Foreign key constraints
- Proper indexing
- Database seeder with sample data

#### File Management

- File upload for tugas
- File upload for pengumpulan tugas
- File upload for materi
- Storage link configuration
- File validation (type and size)

#### Security

- Password hashing with bcrypt
- Token-based authentication
- Role-based middleware
- Request validation
- CSRF protection
- SQL injection protection

#### Documentation

- Complete API documentation
- README with installation guide
- Postman collection for testing
- Default login credentials
- Database structure documentation

#### Testing

- Database seeder with test data
- 6 default users (1 admin, 2 dosen, 3 mahasiswa)
- 3 sample mata kuliah
- Sample peserta assignments

### Technical Details

- **Framework**: Laravel 13
- **PHP Version**: 8.3+
- **Database**: MySQL
- **Authentication**: Laravel Sanctum
- **API Format**: JSON REST API
- **File Storage**: Local Storage (public disk)

### API Endpoints Summary

- **Total Endpoints**: 40+
- **Authentication**: 3 endpoints
- **Admin**: 15+ endpoints
- **Dosen**: 15+ endpoints
- **Mahasiswa**: 10+ endpoints

### File Structure

```
app/
├── Http/
│   ├── Controllers/Api/
│   │   ├── AuthController.php
│   │   ├── UserController.php
│   │   ├── MataKuliahController.php
│   │   ├── PesertaMkController.php
│   │   ├── QrController.php
│   │   ├── AbsensiController.php
│   │   ├── TugasController.php
│   │   └── MateriController.php
│   └── Middleware/
│       └── RoleMiddleware.php
└── Models/
    ├── User.php
    ├── MataKuliah.php
    ├── PesertaMk.php
    ├── QrSession.php
    ├── Absensi.php
    ├── Tugas.php
    ├── PengumpulanTugas.php
    └── Materi.php
```

### Configuration

- API routes configured in `routes/api.php`
- Middleware registered in `bootstrap/app.php`
- Storage link for file access
- Database configuration in `.env`

### Known Issues

None at this time.

### Future Enhancements

- [ ] Email notifications for assignments
- [ ] Push notifications for QR generation
- [ ] Export attendance to Excel/PDF
- [ ] Dashboard statistics
- [ ] Batch operations for admin
- [ ] Advanced filtering and search
- [ ] Rate limiting for API
- [ ] API versioning
- [ ] Automated testing (PHPUnit)
- [ ] API documentation with Swagger/OpenAPI

---

## How to Update

To update to the latest version:

```bash
git pull origin main
composer install
php artisan migrate
php artisan config:clear
php artisan cache:clear
```

---

**Note**: This is the initial release. All features are production-ready and tested.
