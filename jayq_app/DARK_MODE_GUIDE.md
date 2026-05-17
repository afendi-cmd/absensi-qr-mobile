# 🌙 Dark Mode Implementation Guide

## Quick Start

### 1. Install Dependencies

Pastikan `shared_preferences` sudah ada di `pubspec.yaml`:

```yaml
dependencies:
  shared_preferences: ^2.2.2
```

### 2. Run the App

```bash
flutter pub get
flutter run
```

## How It Works

### Architecture

```
┌─────────────────────────────────────┐
│         ThemeProvider               │
│  - isDarkMode: bool                 │
│  - toggleTheme()                    │
│  - lightTheme: ThemeData            │
│  - darkTheme: ThemeData             │
└─────────────────────────────────────┘
              │
              │ ChangeNotifier
              ▼
┌─────────────────────────────────────┐
│         MaterialApp                 │
│  - theme: lightTheme                │
│  - darkTheme: darkTheme             │
│  - themeMode: dynamic               │
└─────────────────────────────────────┘
              │
              │ Consumer
              ▼
┌─────────────────────────────────────┐
│      All Screens                    │
│  - AdminDashboard                   │
│  - AdminProfile                     │
│  - etc...                           │
└─────────────────────────────────────┘
```

### State Flow

1. **Initialization**
   - App starts
   - ThemeProvider loads saved preference from SharedPreferences
   - Default: Light Mode

2. **Toggle Theme**
   - User taps switch in profile
   - `toggleTheme()` called
   - Preference saved to SharedPreferences
   - `notifyListeners()` triggers rebuild
   - All screens update automatically

3. **Persistence**
   - Theme preference saved locally
   - Persists across app restarts
   - No server sync needed

## Color Palette

### Light Mode

```dart
Background:     #F5F5F5  // Light gray
Surface:        #FFFFFF  // White
Primary:        #2563EB  // Blue
Secondary:      #1E40AF  // Dark blue
Text Primary:   #111827  // Almost black
Text Secondary: #6B7280  // Gray
Border:         #E5E7EB  // Light gray
```

### Dark Mode

```dart
Background:     #111827  // Very dark gray
Surface:        #1F2937  // Dark gray
Primary:        #3B82F6  // Lighter blue
Secondary:      #2563EB  // Blue
Text Primary:   #FFFFFF  // White
Text Secondary: #9CA3AF  // Light gray
Border:         #374151  // Medium gray
```

## Implementation Examples

### 1. Using Theme in Widgets

```dart
Widget build(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final isDark = themeProvider.isDarkMode;

  return Container(
    color: isDark ? Color(0xFF1F2937) : Colors.white,
    child: Text(
      'Hello',
      style: TextStyle(
        color: isDark ? Colors.white : Color(0xFF111827),
      ),
    ),
  );
}
```

### 2. Dynamic Colors

```dart
// Background
backgroundColor: isDark ? Color(0xFF111827) : Color(0xFFF5F5F5)

// Card/Surface
color: isDark ? Color(0xFF1F2937) : Colors.white

// Primary Text
color: isDark ? Colors.white : Color(0xFF111827)

// Secondary Text
color: isDark ? Color(0xFF9CA3AF) : Color(0xFF6B7280)

// Border
color: isDark ? Color(0xFF374151) : Color(0xFFE5E7EB)
```

### 3. Shadows

```dart
BoxShadow(
  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
  blurRadius: 8,
  offset: Offset(0, 2),
)
```

## Best Practices

### ✅ DO

1. **Use Provider for Theme State**

   ```dart
   final themeProvider = Provider.of<ThemeProvider>(context);
   final isDark = themeProvider.isDarkMode;
   ```

2. **Consistent Color Usage**
   - Use defined color palette
   - Maintain contrast ratios
   - Test in both modes

3. **Dynamic Shadows**
   - Darker shadows in dark mode
   - Lighter shadows in light mode

4. **Icon Colors**
   - Adjust icon colors based on theme
   - Maintain visibility

### ❌ DON'T

1. **Hardcode Colors**

   ```dart
   // Bad
   color: Colors.white

   // Good
   color: isDark ? Colors.white : Color(0xFF111827)
   ```

2. **Forget Borders**

   ```dart
   // Bad - invisible in dark mode
   border: Border.all(color: Color(0xFFE5E7EB))

   // Good
   border: Border.all(
     color: isDark ? Color(0xFF374151) : Color(0xFFE5E7EB)
   )
   ```

3. **Ignore Contrast**
   - Always test readability
   - Use contrast checker tools

## Testing Checklist

- [ ] All screens render correctly in light mode
- [ ] All screens render correctly in dark mode
- [ ] Text is readable in both modes
- [ ] Icons are visible in both modes
- [ ] Borders are visible in both modes
- [ ] Shadows look good in both modes
- [ ] Toggle switch works smoothly
- [ ] Preference persists after app restart
- [ ] No color flashing during theme change
- [ ] Status bar adapts to theme

## Troubleshooting

### Issue: Theme not persisting

**Solution**: Check SharedPreferences initialization

```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setBool('isDarkMode', _isDarkMode);
```

### Issue: Colors not updating

**Solution**: Ensure `notifyListeners()` is called

```dart
Future<void> toggleTheme() async {
  _isDarkMode = !_isDarkMode;
  // Save to preferences...
  notifyListeners(); // Important!
}
```

### Issue: White flash on startup

**Solution**: Load theme before MaterialApp builds

```dart
ThemeProvider() {
  _loadThemePreference();
}
```

## Performance Tips

1. **Minimize Rebuilds**
   - Use `Consumer` for specific widgets
   - Avoid unnecessary `Provider.of` calls

2. **Cache Colors**

   ```dart
   final bgColor = isDark ? Color(0xFF111827) : Color(0xFFF5F5F5);
   // Use bgColor multiple times
   ```

3. **Lazy Loading**
   - Load theme preference asynchronously
   - Don't block app startup

## Accessibility

### Contrast Ratios

- Normal text: minimum 4.5:1
- Large text: minimum 3:1
- UI components: minimum 3:1

### Testing Tools

- Chrome DevTools Contrast Checker
- WCAG Contrast Checker
- Material Design Color Tool

## Resources

- [Material Design Dark Theme](https://material.io/design/color/dark-theme.html)
- [Flutter Theme Documentation](https://docs.flutter.dev/cookbook/design/themes)
- [Provider Package](https://pub.dev/packages/provider)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)

## Support

Jika ada pertanyaan atau masalah:

1. Check dokumentasi ini
2. Review implementation examples
3. Test dengan checklist
4. Contact development team
