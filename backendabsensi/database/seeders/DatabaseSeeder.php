<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\MataKuliah;
use App\Models\PesertaMk;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Create Admin
        $admin = User::create([
            'nama' => 'Admin JAYQ',
            'email' => 'admin@jayq.com',
            'password' => Hash::make('password'),
            'role' => 'admin',
        ]);

        // Create Dosen
        $dosen1 = User::create([
            'nama' => 'Dr. Budi Santoso',
            'email' => 'budi@jayq.com',
            'password' => Hash::make('password'),
            'role' => 'dosen',
        ]);

        $dosen2 = User::create([
            'nama' => 'Dr. Siti Nurhaliza',
            'email' => 'siti@jayq.com',
            'password' => Hash::make('password'),
            'role' => 'dosen',
        ]);

        // Create Mahasiswa
        $mahasiswa1 = User::create([
            'nama' => 'Ahmad Rizki',
            'email' => 'ahmad@jayq.com',
            'password' => Hash::make('password'),
            'role' => 'mahasiswa',
        ]);

        $mahasiswa2 = User::create([
            'nama' => 'Dewi Lestari',
            'email' => 'dewi@jayq.com',
            'password' => Hash::make('password'),
            'role' => 'mahasiswa',
        ]);

        $mahasiswa3 = User::create([
            'nama' => 'Eko Prasetyo',
            'email' => 'eko@jayq.com',
            'password' => Hash::make('password'),
            'role' => 'mahasiswa',
        ]);

        // Create Mata Kuliah
        $mk1 = MataKuliah::create([
            'nama_mk' => 'Pemrograman Mobile',
            'kode_mk' => 'IF301',
            'dosen_id' => $dosen1->id,
        ]);

        $mk2 = MataKuliah::create([
            'nama_mk' => 'Basis Data',
            'kode_mk' => 'IF302',
            'dosen_id' => $dosen1->id,
        ]);

        $mk3 = MataKuliah::create([
            'nama_mk' => 'Pemrograman Web',
            'kode_mk' => 'IF303',
            'dosen_id' => $dosen2->id,
        ]);

        // Assign Mahasiswa ke Mata Kuliah
        // Ahmad mengambil semua mata kuliah
        PesertaMk::create([
            'mahasiswa_id' => $mahasiswa1->id,
            'mata_kuliah_id' => $mk1->id,
        ]);
        PesertaMk::create([
            'mahasiswa_id' => $mahasiswa1->id,
            'mata_kuliah_id' => $mk2->id,
        ]);
        PesertaMk::create([
            'mahasiswa_id' => $mahasiswa1->id,
            'mata_kuliah_id' => $mk3->id,
        ]);

        // Dewi mengambil 2 mata kuliah
        PesertaMk::create([
            'mahasiswa_id' => $mahasiswa2->id,
            'mata_kuliah_id' => $mk1->id,
        ]);
        PesertaMk::create([
            'mahasiswa_id' => $mahasiswa2->id,
            'mata_kuliah_id' => $mk3->id,
        ]);

        // Eko mengambil 1 mata kuliah
        PesertaMk::create([
            'mahasiswa_id' => $mahasiswa3->id,
            'mata_kuliah_id' => $mk2->id,
        ]);

        $this->command->info('Database seeded successfully!');
        $this->command->info('');
        $this->command->info('=== Login Credentials ===');
        $this->command->info('Admin: admin@jayq.com / password');
        $this->command->info('Dosen 1: budi@jayq.com / password');
        $this->command->info('Dosen 2: siti@jayq.com / password');
        $this->command->info('Mahasiswa 1: ahmad@jayq.com / password');
        $this->command->info('Mahasiswa 2: dewi@jayq.com / password');
        $this->command->info('Mahasiswa 3: eko@jayq.com / password');
    }
}
