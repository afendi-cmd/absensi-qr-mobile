# 🛠️ Utils Documentation

## 📋 Apa itu Utils?

**Utils** (Utilities) adalah kumpulan **helper functions** atau **fungsi bantuan** yang dapat digunakan berulang kali di berbagai tempat dalam aplikasi.

### Keuntungan Menggunakan Utils:

1. ✅ **DRY Principle** - Don't Repeat Yourself
2. ✅ **Easy Maintenance** - Update di satu tempat, berlaku di semua tempat
3. ✅ **Consistency** - Format dan behavior yang sama
4. ✅ **Clean Code** - Code lebih rapi dan mudah dibaca
5. ✅ **Reusability** - Fungsi dapat digunakan di mana saja

---

## 📁 Utils yang Tersedia

### 1. 📅 **DateTimeUtils** - Manipulasi Tanggal & Waktu

**File:** `lib/core/utils/date_utils.dart`

#### Fungsi Utama:

```dart
// Format tanggal Indonesia
DateTimeUtils.formatDate(DateTime.now())
// Output: "17 Mei 2026"

// Format tanggal pendek
DateTimeUtils.formatDateShort(DateTime.now())
// Output: "17 Mei 2026"

// Format waktu
DateTimeUtils.formatTime(DateTime.now())
// Output: "14:30"

// Format tanggal dan waktu lengkap
DateTimeUtils.formatDateTime(DateTime.now())
// Output: "17 Mei 2026, 14:30"

// Format hari dan tanggal
DateTimeUtils.formatDayDate(DateTime.now())
// Output: "Senin, 17 Mei"

// Cek apakah hari ini
DateTimeUtils.isToday(someDate)
// Output: true/false

// Get relative time
DateTimeUtils.getRelativeTime(DateTime.now().subtract(Duration(hours: 2)))
// Output: "2 jam yang lalu"

// Get nama hari
DateTimeUtils.getDayName(DateTime.now())
// Output: "Senin"

// Get nama bulan
DateTimeUtils.getMonthName(DateTime.now())
// Output: "Mei"

// Parse ISO string
DateTimeUtils.parseISOString("2026-05-17T14:30:00Z")
// Output: DateTime object

// Get range minggu ini
DateTimeUtils.getCurrentWeek()
// Output: DateTimeRange

// Get range bulan ini
DateTimeUtils.getCurrentMonth()
// Output: DateTimeRange

// Format durasi
DateTimeUtils.formatDuration(Duration(hours: 2, minutes: 30))
// Output: "2j 30m"
```

#### Contoh Penggunaan:

```dart
// Di widget
Text(DateTimeUtils.formatDate(attendance.date))

// Di list item
Text(DateTimeUtils.getRelativeTime(notification.createdAt))

// Di filter
final thisWeek = DateTimeUtils.getCurrentWeek();
```

---

### 2. 🔤 **StringUtils** - Manipulasi String

**File:** `lib/core/utils/string_utils.dart`

#### Fungsi Utama:

```dart
// Capitalize first letter
StringUtils.capitalize("hello world")
// Output: "Hello world"

// Capitalize setiap kata
StringUtils.capitalizeWords("hello world")
// Output: "Hello World"

// Get initials
StringUtils.getInitials("John Doe")
// Output: "JD"

// Truncate text
StringUtils.truncate("Lorem ipsum dolor sit amet", 10)
// Output: "Lorem i..."

// Mask email
StringUtils.maskEmail("john@example.com")
// Output: "j***@example.com"

// Mask phone
StringUtils.maskPhone("081234567890")
// Output: "0812****7890"

// Format NIM
StringUtils.formatNIM("202301001")
// Output: "2023.01.001"

// Validate email
StringUtils.isValidEmail("test@example.com")
// Output: true

// Validate phone
StringUtils.isValidPhone("081234567890")
// Output: true

// Format file size
StringUtils.formatFileSize(1024000)
// Output: "1000.0 KB"

// Format currency
StringUtils.formatCurrency(1000000)
// Output: "Rp 1.000.000"

// To slug
StringUtils.toSlug("Hello World 123")
// Output: "hello-world-123"
```

#### Contoh Penggunaan:

```dart
// Di profile
Text(StringUtils.getInitials(user.name))

// Di list
Text(StringUtils.truncate(description, 50))

// Di privacy
Text(StringUtils.maskEmail(user.email))
```

---

### 3. ✅ **ValidatorUtils** - Validasi Form

**File:** `lib/core/utils/validator_utils.dart`

#### Fungsi Utama:

```dart
// Required field
ValidatorUtils.required(value, fieldName: 'Nama')

// Email validation
ValidatorUtils.email(value)

// Password validation
ValidatorUtils.password(value, minLength: 6)

// Strong password
ValidatorUtils.strongPassword(value)

// Confirm password
ValidatorUtils.confirmPassword(confirmValue, passwordValue)

// Phone validation
ValidatorUtils.phone(value)

// NIM validation
ValidatorUtils.nim(value, length: 9)

// Min length
ValidatorUtils.minLength(value, 3, fieldName: 'Username')

// Max length
ValidatorUtils.maxLength(value, 50, fieldName: 'Nama')

// Numeric
ValidatorUtils.numeric(value, fieldName: 'Umur')

// Min value
ValidatorUtils.minValue(value, 0, fieldName: 'Nilai')

// Max value
ValidatorUtils.maxValue(value, 100, fieldName: 'Nilai')

// URL validation
ValidatorUtils.url(value)

// Date validation
ValidatorUtils.date(value)

// Time validation
ValidatorUtils.time(value)

// Combine validators
ValidatorUtils.combine([
  (value) => ValidatorUtils.required(value, fieldName: 'Email'),
  ValidatorUtils.email,
])
```

#### Contoh Penggunaan:

```dart
// Di TextFormField
TextFormField(
  decoration: InputDecoration(labelText: 'Email'),
  validator: ValidatorUtils.email,
)

// Multiple validators
TextFormField(
  decoration: InputDecoration(labelText: 'Password'),
  validator: ValidatorUtils.combine([
    (value) => ValidatorUtils.required(value, fieldName: 'Password'),
    ValidatorUtils.strongPassword,
  ]),
)

// Custom validator
TextFormField(
  decoration: InputDecoration(labelText: 'NIM'),
  validator: (value) => ValidatorUtils.nim(value, length: 9),
)
```

---

### 4. 💬 **DialogUtils** - Dialog & Snackbar

**File:** `lib/core/utils/dialog_utils.dart`

#### Fungsi Utama:

```dart
// Show loading
DialogUtils.showLoading(context, message: 'Memuat data...');

// Hide loading
DialogUtils.hideLoading(context);

// Show success
DialogUtils.showSuccess(context, 'Data berhasil disimpan');

// Show error
DialogUtils.showError(context, 'Terjadi kesalahan');

// Show warning
DialogUtils.showWarning(context, 'Peringatan!');

// Show info
DialogUtils.showInfo(context, 'Informasi penting');

// Show confirmation
final confirmed = await DialogUtils.showConfirmation(
  context,
  title: 'Konfirmasi',
  message: 'Apakah Anda yakin?',
);

// Show delete confirmation
final delete = await DialogUtils.showDeleteConfirmation(context);

// Show input dialog
final input = await DialogUtils.showInputDialog(
  context,
  title: 'Masukkan Nama',
  hint: 'Nama lengkap',
);

// Show bottom sheet
await DialogUtils.showBottomSheet(
  context,
  child: YourWidget(),
);
```

#### Contoh Penggunaan:

```dart
// Saat submit form
Future<void> _submitForm() async {
  DialogUtils.showLoading(context);

  try {
    await apiService.saveData(data);
    DialogUtils.hideLoading(context);
    DialogUtils.showSuccess(context, 'Data berhasil disimpan');
  } catch (e) {
    DialogUtils.hideLoading(context);
    DialogUtils.showError(context, e.toString());
  }
}

// Saat delete
Future<void> _deleteItem() async {
  final confirmed = await DialogUtils.showDeleteConfirmation(context);

  if (confirmed) {
    // Delete logic
  }
}
```

---

### 5. 🧭 **NavigationUtils** - Navigasi

**File:** `lib/core/utils/navigation_utils.dart`

#### Fungsi Utama:

```dart
// Push to new screen
NavigationUtils.push(context, DetailScreen());

// Push and replace
NavigationUtils.pushReplacement(context, HomeScreen());

// Push and remove all
NavigationUtils.pushAndRemoveUntil(context, LoginScreen());

// Pop
NavigationUtils.pop(context);

// Pop with result
NavigationUtils.pop(context, result);

// Pop to root
NavigationUtils.popToRoot(context);

// Can pop
if (NavigationUtils.canPop(context)) {
  NavigationUtils.pop(context);
}

// Push with slide transition
NavigationUtils.pushWithSlide(
  context,
  DetailScreen(),
  direction: SlideDirection.right,
);

// Push with fade
NavigationUtils.pushWithFade(context, DetailScreen());

// Push with scale
NavigationUtils.pushWithScale(context, DetailScreen());

// Push named route
NavigationUtils.pushNamed(context, '/detail');
```

#### Contoh Penggunaan:

```dart
// Navigate to detail
onTap: () {
  NavigationUtils.push(context, DetailScreen(id: item.id));
}

// Logout
onTap: () {
  NavigationUtils.pushAndRemoveUntil(context, LoginScreen());
}

// Back with result
onTap: () {
  NavigationUtils.pop(context, selectedItem);
}
```

---

## 🎯 Best Practices

### 1. Import Utils

```dart
import 'package:jayq_app/core/utils/date_utils.dart';
import 'package:jayq_app/core/utils/string_utils.dart';
import 'package:jayq_app/core/utils/validator_utils.dart';
import 'package:jayq_app/core/utils/dialog_utils.dart';
import 'package:jayq_app/core/utils/navigation_utils.dart';
```

### 2. Gunakan Static Methods

```dart
// ✅ Good
DateTimeUtils.formatDate(date)

// ❌ Bad - Tidak perlu instantiate
final utils = DateTimeUtils();
utils.formatDate(date)
```

### 3. Combine Validators

```dart
// ✅ Good - Reusable
final emailValidator = ValidatorUtils.combine([
  (value) => ValidatorUtils.required(value, fieldName: 'Email'),
  ValidatorUtils.email,
]);

TextFormField(validator: emailValidator)
```

### 4. Error Handling

```dart
// ✅ Good
try {
  DialogUtils.showLoading(context);
  await apiCall();
  DialogUtils.hideLoading(context);
  DialogUtils.showSuccess(context, 'Berhasil');
} catch (e) {
  DialogUtils.hideLoading(context);
  DialogUtils.showError(context, e.toString());
}
```

---

## 📚 Contoh Lengkap

### Form dengan Validation

```dart
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: ValidatorUtils.combine([
              (value) => ValidatorUtils.required(value, fieldName: 'Email'),
              ValidatorUtils.email,
            ]),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) => ValidatorUtils.password(value, minLength: 6),
          ),
          ElevatedButton(
            onPressed: _handleLogin,
            child: Text('Login'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    DialogUtils.showLoading(context);

    try {
      await authService.login(
        _emailController.text,
        _passwordController.text,
      );

      DialogUtils.hideLoading(context);
      DialogUtils.showSuccess(context, 'Login berhasil');

      NavigationUtils.pushAndRemoveUntil(
        context,
        DashboardScreen(),
      );
    } catch (e) {
      DialogUtils.hideLoading(context);
      DialogUtils.showError(context, e.toString());
    }
  }
}
```

### List dengan Date Formatting

```dart
class AttendanceList extends StatelessWidget {
  final List<Attendance> attendances;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: attendances.length,
      itemBuilder: (context, index) {
        final attendance = attendances[index];

        return ListTile(
          title: Text(attendance.courseName),
          subtitle: Text(
            DateTimeUtils.formatDateTime(attendance.timestamp),
          ),
          trailing: Text(
            DateTimeUtils.getRelativeTime(attendance.timestamp),
            style: TextStyle(color: Colors.grey),
          ),
          onTap: () {
            NavigationUtils.push(
              context,
              AttendanceDetailScreen(attendance: attendance),
            );
          },
        );
      },
    );
  }
}
```

---

## 🔧 Troubleshooting

### Error: Undefined name 'DateTimeUtils'

**Solution:** Import utils file

```dart
import 'package:jayq_app/core/utils/date_utils.dart';
```

### Error: The method 'formatDate' isn't defined

**Solution:** Check import dan pastikan method ada

```dart
// Check file: lib/core/utils/date_utils.dart
static String formatDate(DateTime date) { ... }
```

---

## 📞 Support

Untuk pertanyaan atau request utils baru, hubungi development team.

---

**Last Updated:** May 17, 2026  
**Version:** 1.0.0
