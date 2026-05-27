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
        Schema::table('mata_kuliah', function (Blueprint $table) {
            $table->enum('hari', ['senin', 'selasa', 'rabu', 'kamis', 'jumat', 'sabtu'])->nullable()->after('semester');
            $table->time('jam_mulai')->nullable()->after('hari');
            $table->time('jam_selesai')->nullable()->after('jam_mulai');
            $table->string('ruangan', 50)->nullable()->after('jam_selesai');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('mata_kuliah', function (Blueprint $table) {
            $table->dropColumn(['hari', 'jam_mulai', 'jam_selesai', 'ruangan']);
        });
    }
};
