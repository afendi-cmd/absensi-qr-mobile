<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Tabel pengajuan izin / sakit oleh mahasiswa, dapat menyertakan
     * lampiran surat dan ditinjau (disetujui/ditolak) oleh dosen.
     */
    public function up(): void
    {
        Schema::create('izin_sakit', function (Blueprint $table) {
            $table->id();
            $table->foreignId('mahasiswa_id')->constrained('users')->cascadeOnDelete();
            $table->foreignId('mata_kuliah_id')->nullable()->constrained('mata_kuliah')->nullOnDelete();
            $table->date('tanggal');
            $table->enum('jenis', ['izin', 'sakit']);
            $table->text('alasan');
            $table->string('file_surat')->nullable();
            $table->enum('status', ['pending', 'disetujui', 'ditolak'])->default('pending');
            $table->text('catatan')->nullable();
            $table->foreignId('reviewed_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('izin_sakit');
    }
};
