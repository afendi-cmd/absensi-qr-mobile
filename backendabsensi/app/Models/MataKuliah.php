<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MataKuliah extends Model
{
    use HasFactory;

    protected $table = 'mata_kuliah';

    protected $fillable = [
        'nama_mk',
        'kode_mk',
        'dosen_id',
    ];

    // Relasi
    public function dosen()
    {
        return $this->belongsTo(User::class, 'dosen_id');
    }

    public function peserta()
    {
        return $this->belongsToMany(User::class, 'peserta_mk', 'mata_kuliah_id', 'mahasiswa_id')
            ->withTimestamps();
    }

    public function qrSessions()
    {
        return $this->hasMany(QrSession::class, 'mata_kuliah_id');
    }

    public function absensi()
    {
        return $this->hasMany(Absensi::class, 'mata_kuliah_id');
    }

    public function tugas()
    {
        return $this->hasMany(Tugas::class, 'mata_kuliah_id');
    }

    public function materi()
    {
        return $this->hasMany(Materi::class, 'mata_kuliah_id');
    }
}
