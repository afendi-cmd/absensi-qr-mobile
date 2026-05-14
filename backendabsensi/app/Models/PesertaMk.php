<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PesertaMk extends Model
{
    use HasFactory;

    protected $table = 'peserta_mk';

    protected $fillable = [
        'mahasiswa_id',
        'mata_kuliah_id',
    ];

    public $timestamps = true;

    // Relasi
    public function mahasiswa()
    {
        return $this->belongsTo(User::class, 'mahasiswa_id');
    }

    public function mataKuliah()
    {
        return $this->belongsTo(MataKuliah::class, 'mata_kuliah_id');
    }
}
