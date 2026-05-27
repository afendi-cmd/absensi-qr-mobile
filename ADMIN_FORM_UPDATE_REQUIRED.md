# Admin Form Update Required ⚠️

## Status: PENDING

Setelah menambahkan field jadwal ke tabel `mata_kuliah`, form admin perlu diupdate untuk bisa input jadwal saat create/edit mata kuliah.

---

## 📝 Field Jadwal yang Ditambahkan

Di tabel `mata_kuliah`:

- `hari` - ENUM (senin, selasa, rabu, kamis, jumat, sabtu)
- `jam_mulai` - TIME (format: HH:mm:ss)
- `jam_selesai` - TIME (format: HH:mm:ss)
- `ruangan` - VARCHAR(50)

---

## 🔧 File yang Perlu Diupdate

### 1. `manage_matakuliah_screen.dart`

**Location:** `jayq_app/lib/screens/admin/manage_matakuliah_screen.dart`

**Changes Required:**

#### A. Add Controllers (di method `_showAddDialog` dan `_showEditDialog`):

```dart
final hariController = TextEditingController();
final jamMulaiController = TextEditingController();
final jamSelesaiController = TextEditingController();
final ruanganController = TextEditingController();
String? selectedHari;
```

#### B. Add Form Fields (setelah field Dosen):

```dart
// Dropdown Hari
DropdownButtonFormField<String>(
  value: selectedHari,
  decoration: InputDecoration(
    labelText: 'Hari',
    // ... styling sama seperti field lain
  ),
  items: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu']
      .map((hari) => DropdownMenuItem(
            value: hari.toLowerCase(),
            child: Text(hari),
          ))
      .toList(),
  onChanged: (value) {
    setState(() {
      selectedHari = value;
    });
  },
),

const SizedBox(height: 16),

// Time Picker - Jam Mulai
TextFormField(
  controller: jamMulaiController,
  readOnly: true,
  decoration: InputDecoration(
    labelText: 'Jam Mulai',
    suffixIcon: Icon(Icons.access_time),
    // ... styling
  ),
  onTap: () async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      jamMulaiController.text =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
    }
  },
),

const SizedBox(height: 16),

// Time Picker - Jam Selesai
TextFormField(
  controller: jamSelesaiController,
  readOnly: true,
  decoration: InputDecoration(
    labelText: 'Jam Selesai',
    suffixIcon: Icon(Icons.access_time),
    // ... styling
  ),
  onTap: () async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      jamSelesaiController.text =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
    }
  },
),

const SizedBox(height: 16),

// Ruangan
TextFormField(
  controller: ruanganController,
  decoration: InputDecoration(
    labelText: 'Ruangan',
    hintText: 'Contoh: Lab Komputer 3',
    // ... styling
  ),
),
```

#### C. Update API Call (di onPressed button Simpan):

```dart
await _mataKuliahService.createMataKuliah({
  'nama_mk': namaMkController.text,
  'kode_mk': kodeMkController.text,
  'sks': int.parse(sksController.text),
  'semester': semesterController.text,
  'dosen_id': selectedDosenId,
  // ADD THESE:
  'hari': selectedHari,
  'jam_mulai': jamMulaiController.text.isNotEmpty
      ? jamMulaiController.text
      : null,
  'jam_selesai': jamSelesaiController.text.isNotEmpty
      ? jamSelesaiController.text
      : null,
  'ruangan': ruanganController.text.isNotEmpty
      ? ruanganController.text
      : null,
});
```

#### D. Update Edit Dialog (initialize controllers with existing data):

```dart
final hariController = TextEditingController();
final jamMulaiController = TextEditingController(
  text: mataKuliah['jam_mulai'] ?? '',
);
final jamSelesaiController = TextEditingController(
  text: mataKuliah['jam_selesai'] ?? '',
);
final ruanganController = TextEditingController(
  text: mataKuliah['ruangan'] ?? '',
);
String? selectedHari = mataKuliah['hari'];
```

#### E. Update Detail Bottom Sheet (add schedule info):

```dart
_buildDetailRow('Hari', mataKuliah['hari'] ?? '-', isDark),
_buildDetailRow('Jam Mulai', mataKuliah['jam_mulai'] ?? '-', isDark),
_buildDetailRow('Jam Selesai', mataKuliah['jam_selesai'] ?? '-', isDark),
_buildDetailRow('Ruangan', mataKuliah['ruangan'] ?? '-', isDark),
```

---

## 🎯 Testing Checklist

Setelah update form:

- [ ] Bisa create mata kuliah dengan jadwal
- [ ] Bisa edit mata kuliah dan update jadwal
- [ ] Time picker berfungsi dengan baik
- [ ] Dropdown hari berfungsi
- [ ] Data jadwal tersimpan ke database
- [ ] Detail bottom sheet menampilkan jadwal
- [ ] Mahasiswa bisa lihat jadwal di schedule screen

---

## 📌 Notes

- Field jadwal bersifat **optional** (nullable)
- Jika tidak diisi, jadwal tidak akan muncul di schedule screen mahasiswa
- Format waktu: `HH:mm:ss` (contoh: `08:00:00`)
- Hari harus lowercase: `senin`, `selasa`, `rabu`, `kamis`, `jumat`, `sabtu`

---

## 🚀 Priority

**HIGH** - Form ini perlu diupdate agar admin bisa menambahkan jadwal untuk mata kuliah yang sudah ada dan yang baru.

---

**Status:** Waiting for implementation
**Assigned to:** Admin form developer
**Estimated time:** 30-45 minutes
