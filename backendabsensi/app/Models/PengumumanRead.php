<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PengumumanRead extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'pengumuman_id',
        'user_id',
        'read_at',
    ];

    protected $casts = [
        'read_at' => 'datetime',
    ];

    /**
     * Get the pengumuman that was read
     */
    public function pengumuman(): BelongsTo
    {
        return $this->belongsTo(Pengumuman::class);
    }

    /**
     * Get the user who read the pengumuman
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
