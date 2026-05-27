# Admin Form Update - Manual Instructions

## ✅ Changes Already Applied

1. **Controllers Added** (in `_showAddDialog` and `_showEditDialog`):
   - ✅ `jamMulaiController`
   - ✅ `jamSelesaiController`
   - ✅ `ruanganController`
   - ✅ `selectedHari` variable

2. **API Calls Updated**:
   - ✅ `createMataKuliah` - includes schedule fields
   - ✅ `updateMataKuliah` - includes schedule fields

3. **Detail Bottom Sheet Updated**:
   - ✅ Shows Hari, Jam Mulai, Jam Selesai, Ruangan

---

## ⚠️ MANUAL STEPS REQUIRED

You need to manually add the schedule form fields in TWO places:

### 1. In `_showAddDialog` Method

**Location:** After the "Dosen Pengampu" dropdown (around line 280)

**Add this code:**

```dart
const SizedBox(height: 16),
// Dropdown Hari
DropdownButtonFormField<String>(
  value: selectedHari,
  dropdownColor: isDark ? const Color(0xFF374151) : Colors.white,
  style: TextStyle(
    color: isDark ? Colors.white : const Color(0xFF1F2937),
  ),
  decoration: InputDecoration(
    labelText: 'Hari',
    hintText: 'Pilih hari kuliah',
    hintStyle: TextStyle(
      fontSize: 12,
      color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
    ),
    labelStyle: TextStyle(
      color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFF59E0B)),
    ),
  ),
  items: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu']
      .map((hari) => DropdownMenuItem<String>(
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
  style: TextStyle(
    color: isDark ? Colors.white : const Color(0xFF1F2937),
  ),
  decoration: InputDecoration(
    labelText: 'Jam Mulai',
    hintText: 'Pilih jam mulai',
    hintStyle: TextStyle(
      fontSize: 12,
      color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
    ),
    labelStyle: TextStyle(
      color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
    ),
    suffixIcon: Icon(
      Icons.access_time_rounded,
      color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFF59E0B)),
    ),
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
  style: TextStyle(
    color: isDark ? Colors.white : const Color(0xFF1F2937),
  ),
  decoration: InputDecoration(
    labelText: 'Jam Selesai',
    hintText: 'Pilih jam selesai',
    hintStyle: TextStyle(
      fontSize: 12,
      color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
    ),
    labelStyle: TextStyle(
      color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
    ),
    suffixIcon: Icon(
      Icons.access_time_rounded,
      color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFF59E0B)),
    ),
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
  style: TextStyle(
    color: isDark ? Colors.white : const Color(0xFF1F2937),
  ),
  decoration: InputDecoration(
    labelText: 'Ruangan',
    hintText: 'Contoh: Lab Komputer 3',
    hintStyle: TextStyle(
      fontSize: 12,
      color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
    ),
    labelStyle: TextStyle(
      color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFF59E0B)),
    ),
  ),
),
```

### 2. In `_showEditDialog` Method

**Location:** After the "Dosen Pengampu" dropdown (around line 480)

**Add the SAME code as above** (copy-paste the entire block)

---

## 📝 How to Add the Fields

1. Open `manage_matakuliah_screen.dart`
2. Find `_showAddDialog` method
3. Scroll to the "Dosen Pengampu" dropdown
4. After the closing `),` of the dropdown, add the schedule fields code
5. Repeat for `_showEditDialog` method

---

## ✅ Verification

After adding the fields, verify:

- [ ] Add dialog shows all schedule fields
- [ ] Edit dialog shows all schedule fields with existing data
- [ ] Time picker opens when tapping jam mulai/selesai
- [ ] Dropdown hari works correctly
- [ ] Data saves to database
- [ ] Detail bottom sheet shows schedule info

---

## 🎯 Expected Result

**Add Dialog Fields (in order):**

1. Nama Mata Kuliah
2. Kode Mata Kuliah
3. SKS
4. Semester
5. Dosen Pengampu
6. **Hari** ← NEW
7. **Jam Mulai** ← NEW
8. **Jam Selesai** ← NEW
9. **Ruangan** ← NEW

**Edit Dialog:**

- Same fields as Add Dialog
- Pre-filled with existing data

**Detail Bottom Sheet:**

- Shows all fields including schedule info

---

## 🔧 Alternative: Use Provided File

If manual editing is difficult, I can provide a complete replacement file with all changes included.

---

**Status:** Partially complete - Manual field addition required
**Estimated time:** 5-10 minutes
