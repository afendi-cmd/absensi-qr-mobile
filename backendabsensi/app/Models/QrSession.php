<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Carbon\Carbon;

class QrSession extends Model
{
    use HasFactory;

    protected $table = 'qr_sessions';

    protected $fillable = [
        'mata_kuliah_id',
        'kode_qr',
        'expired_at',
    ];

    protected $casts = [
        'expired_at' => 'datetime',
    ];

    public $timestamps = true;
    const UPDATED_AT = null;

    // Relasi
    public function mataKuliah()
    {
        return $this->belongsTo(MataKuliah::class, 'mata_kuliah_id');
    }

    public function absensi()
    {
        return $this->hasMany(Absensi::class, 'qr_session_id');
    }

    // Helper methods
    public function isExpired()
    {
        return Carbon::now()->greaterThan($this->expired_at);
    }

    public function isActive()
    {
        return !$this->isExpired();
    }
}
