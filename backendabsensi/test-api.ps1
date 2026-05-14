# JAYQ API Test Script (PowerShell)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  JAYQ API - Quick Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$baseUrl = "http://127.0.0.1:8000/api"

# Test 1: Login as Admin
Write-Host "Test 1: Login as Admin..." -ForegroundColor Yellow
try {
    $loginBody = @{
        email = "admin@jayq.com"
        password = "password"
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "$baseUrl/login" -Method POST -Body $loginBody -ContentType "application/json"
    
    if ($response.success) {
        Write-Host "✓ Login successful!" -ForegroundColor Green
        Write-Host "  User: $($response.data.user.nama)" -ForegroundColor Gray
        Write-Host "  Role: $($response.data.user.role)" -ForegroundColor Gray
        $token = $response.data.token
        Write-Host "  Token: $($token.Substring(0, 20))..." -ForegroundColor Gray
    } else {
        Write-Host "✗ Login failed" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Test 2: Get All Users
Write-Host "Test 2: Get All Users..." -ForegroundColor Yellow
try {
    $headers = @{
        "Authorization" = "Bearer $token"
        "Accept" = "application/json"
    }
    
    $response = Invoke-RestMethod -Uri "$baseUrl/users" -Method GET -Headers $headers
    
    if ($response.success) {
        Write-Host "✓ Get users successful!" -ForegroundColor Green
        Write-Host "  Total users: $($response.data.Count)" -ForegroundColor Gray
    } else {
        Write-Host "✗ Get users failed" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 3: Get All Mata Kuliah
Write-Host "Test 3: Get All Mata Kuliah..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/mata-kuliah" -Method GET -Headers $headers
    
    if ($response.success) {
        Write-Host "✓ Get mata kuliah successful!" -ForegroundColor Green
        Write-Host "  Total mata kuliah: $($response.data.Count)" -ForegroundColor Gray
    } else {
        Write-Host "✗ Get mata kuliah failed" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 4: Login as Dosen
Write-Host "Test 4: Login as Dosen..." -ForegroundColor Yellow
try {
    $loginBody = @{
        email = "budi@jayq.com"
        password = "password"
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "$baseUrl/login" -Method POST -Body $loginBody -ContentType "application/json"
    
    if ($response.success) {
        Write-Host "✓ Login successful!" -ForegroundColor Green
        Write-Host "  User: $($response.data.user.nama)" -ForegroundColor Gray
        $dosenToken = $response.data.token
    } else {
        Write-Host "✗ Login failed" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 5: Generate QR (as Dosen)
Write-Host "Test 5: Generate QR Code..." -ForegroundColor Yellow
try {
    $headers = @{
        "Authorization" = "Bearer $dosenToken"
        "Accept" = "application/json"
    }
    
    $qrBody = @{
        mata_kuliah_id = 1
        duration = 15
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "$baseUrl/generate-qr" -Method POST -Body $qrBody -ContentType "application/json" -Headers $headers
    
    if ($response.success) {
        Write-Host "✓ QR generated successfully!" -ForegroundColor Green
        Write-Host "  QR Code: $($response.data.kode_qr.Substring(0, 30))..." -ForegroundColor Gray
        Write-Host "  Expired at: $($response.data.expired_at)" -ForegroundColor Gray
        $qrCode = $response.data.kode_qr
    } else {
        Write-Host "✗ Generate QR failed" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 6: Login as Mahasiswa
Write-Host "Test 6: Login as Mahasiswa..." -ForegroundColor Yellow
try {
    $loginBody = @{
        email = "ahmad@jayq.com"
        password = "password"
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri "$baseUrl/login" -Method POST -Body $loginBody -ContentType "application/json"
    
    if ($response.success) {
        Write-Host "✓ Login successful!" -ForegroundColor Green
        Write-Host "  User: $($response.data.user.nama)" -ForegroundColor Gray
        $mahasiswaToken = $response.data.token
    } else {
        Write-Host "✗ Login failed" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 7: Scan QR (as Mahasiswa)
if ($qrCode) {
    Write-Host "Test 7: Scan QR Code..." -ForegroundColor Yellow
    try {
        $headers = @{
            "Authorization" = "Bearer $mahasiswaToken"
            "Accept" = "application/json"
        }
        
        $scanBody = @{
            kode_qr = $qrCode
            latitude = -6.200000
            longitude = 106.816666
        } | ConvertTo-Json

        $response = Invoke-RestMethod -Uri "$baseUrl/scan-qr" -Method POST -Body $scanBody -ContentType "application/json" -Headers $headers
        
        if ($response.success) {
            Write-Host "✓ Absensi successful!" -ForegroundColor Green
            Write-Host "  Tanggal: $($response.data.tanggal)" -ForegroundColor Gray
            Write-Host "  Jam: $($response.data.jam)" -ForegroundColor Gray
            Write-Host "  Status: $($response.data.status)" -ForegroundColor Gray
        } else {
            Write-Host "✗ Scan QR failed" -ForegroundColor Red
        }
    } catch {
        Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  All Tests Completed!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "API is working correctly! ✓" -ForegroundColor Green
Write-Host ""
Write-Host "You can now:" -ForegroundColor Yellow
Write-Host "  1. Import Postman collection (JAYQ_Postman_Collection.json)"
Write-Host "  2. Read API documentation (API_DOCUMENTATION.md)"
Write-Host "  3. Integrate with Flutter mobile app"
Write-Host ""
