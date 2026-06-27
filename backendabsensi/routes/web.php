<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
| Semua rute web mengarah ke shell SPA (resources/views/app.blade.php).
| Aplikasi front-end ini mengonsumsi REST API di /api menggunakan token
| Sanctum (Bearer). Rute /api dan /storage tetap dikecualikan agar tidak
| ditangkap catch-all.
*/

Route::get('/{any?}', function () {
    return view('app');
})->where('any', '^(?!api|storage).*$');
