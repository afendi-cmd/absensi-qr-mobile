<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class AuditLog extends Model
{
    use HasFactory;

    protected $table = 'audit_logs';

    public $timestamps = false;

    protected $fillable = [
        'user_id',
        'module',
        'action',
        'description',
        'ip_address',
        'created_at',
    ];

    protected $casts = [
        'created_at' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    /**
     * Helper untuk mencatat aktivitas dengan mudah.
     *
     * @param string      $module      Nama modul (mis. "Autentikasi", "Nilai", "Absensi")
     * @param string      $action      Aksi singkat (mis. "Login", "Input", "Delete")
     * @param string|null $description  Deskripsi detail
     * @param int|null    $userId       ID pengguna (default: user yang sedang login)
     */
    public static function record(string $module, string $action, ?string $description = null, ?int $userId = null): self
    {
        return static::create([
            'user_id' => $userId ?? optional(auth()->user())->id,
            'module' => $module,
            'action' => $action,
            'description' => $description,
            'ip_address' => request()->ip(),
            'created_at' => now(),
        ]);
    }
}
