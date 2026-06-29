<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Tambah kolom profil yang dipakai controller (nim, nidn, no_hp, alamat,
     * foto_profil) namun belum tersedia di tabel users.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('nim', 30)->nullable()->unique()->after('nama');
            $table->string('nidn', 30)->nullable()->unique()->after('nim');
            $table->string('no_hp', 20)->nullable()->after('email');
            $table->text('alamat')->nullable()->after('no_hp');
            $table->string('foto_profil')->nullable()->after('alamat');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropUnique(['nim']);
            $table->dropUnique(['nidn']);
            $table->dropColumn(['nim', 'nidn', 'no_hp', 'alamat', 'foto_profil']);
        });
    }
};
