<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('absensi', function (Blueprint $table) {
            $table->id();
            $table->foreignId('mahasiswa_id')
                  ->constrained('users')
                  ->onDelete('cascade');
            $table->foreignId('mata_kuliah_id')
                  ->constrained('mata_kuliah')
                  ->onDelete('cascade');
            $table->foreignId('qr_session_id')
                  ->constrained('qr_sessions')
                  ->onDelete('cascade');
            $table->date('tanggal');
            $table->time('jam');
            $table->enum('status', ['hadir', 'izin', 'alfa'])->default('hadir');
            $table->string('latitude', 50)->nullable();
            $table->string('longitude', 50)->nullable();
            $table->timestamp('created_at')->nullable()->useCurrent();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('absensi');
    }
};
