<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Materi extends Model
{
    use HasFactory;

    protected $table = 'materi';

    protected $fillable = [
        'mata_kuliah_id',
        'judul',
        'deskripsi',
        'file_materi',
    ];

    public $timestamps = true;
    const UPDATED_AT = null;

    // Relasi
    public function mataKuliah()
    {
        return $this->belongsTo(MataKuliah::class, 'mata_kuliah_id');
    }
}
