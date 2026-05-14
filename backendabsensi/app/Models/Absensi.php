<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Absensi extends Model
{
    use HasFactory;

    protected $table = 'absensi';

    protected $fillable = [
        'mahasiswa_id',
        'mata_kuliah_id',
        'qr_session_id',
        'tanggal',
        'jam',
        'status',
        'latitude',
        'longitude',
    ];

    protected $casts = [
        'tanggal' => 'date',
    ];

    public $timestamps = true;
    const UPDATED_AT = null;

    // Relasi
    public function mahasiswa()
    {
        return $this->belongsTo(User::class, 'mahasiswa_id');
    }

    public function mataKuliah()
    {
        return $this->belongsTo(MataKuliah::class, 'mata_kuliah_id');
    }

    public function qrSession()
    {
        return $this->belongsTo(QrSession::class, 'qr_session_id');
    }
}
