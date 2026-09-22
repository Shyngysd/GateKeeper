# 🚀 QUICK REFERENCE GUIDE

## 🔥 Firebase Auth команды

```dart
// Регистрация
await authService.signUpWithEmailPassword(
  email: 'user@example.com',
  password: 'Pass123',
  displayName: 'John',
);

// Вход
await authService.signInWithEmailPassword(
  email: 'user@example.com',
  password: 'Pass123',
);

// Google вход
await authService.signInWithGoogle();

// Выход
await authService.signOut();

// Сброс пароля
await authService.sendPasswordResetEmail('user@example.com');

// Обновить профиль
await authService.updateUserProfile(
  displayName: 'Jane',
  photoURL: 'https://...',
);

// Текущий пользователь
User? user = authService.currentUser;

// Слушать изменения
authService.authStateChanges.listen((user) {
  if (user == null) print('Logged out');
  else print('Logged in: ${user.email}');
});
```

## 📁 Файлы и их задачи

| Файл | Задача |
|------|--------|
| `main.dart` | Firebase инициализация + навигация |
| `auth_service.dart` | Все операции Firebase Auth |
| `auth_notifier.dart` | Riverpod состояние |
| `login_screen.dart` | UI вход/регистрация |
| `home_screen.dart` | UI профиля пользователя |
| `validators.dart` | Валидация данных |
| `auth_widgets.dart` | UI компоненты |

## 🎯 Частые ошибки

| Проблема | Решение |
|----------|---------|
| `Firebase not initialized` | Запустите `flutterfire configure` |
| `Google Sign-In не работает` | Добавьте SHA-1 в Firebase Console |
| `Can't find firebase_options` | Пересоздайте через `flutterfire configure --reconfigure` |
| `Pod install ошибка (iOS)` | Запустите `cd ios && pod install --repo-update && cd ..` |
| `API key invalid` | Проверьте что ключи ограничены по платформам |

## 📱 Запуск

```bash
# Конфигурация Firebase
flutterfire configure

# Установка зависимостей
flutter pub get

# Запуск на эмуляторе
flutter run

# Запуск на физическом устройстве
flutter run -d <device_id>
```

## 🔑 Ключевые концепции

### StreamBuilder для маршрутизации
```dart
StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.hasData) return HomeScreen();
    return LoginScreen();
  },
)
```

### Обработка ошибок
```dart
try {
  await authService.signInWithEmailPassword(...);
} catch (e) {
  // e уже содержит переведенное сообщение
  print(e);
}
```



### Riverpod использование
```dart
final authState = ref.watch(authStateChangesProvider);
authState.when(
  data: (user) { /* ... */ },
  loading: () { /* ... */ },
  error: (error, st) { /* ... */ },
);
```

## ✅ Чек Лист Запуска

- [ ] Firebase проект создан
- [ ] `flutterfire configure` выполнен
- [ ] Email/Password включен в Firebase Console
- [ ] `flutter pub get` выполнен
- [ ] Проект компилируется
- [ ] Приложение запускается
- [ ] Можно зарегистрировать пользователя
- [ ] Можно войти в систему
- [ ] HomeScreen отображается после входа

## 📊 Архитектура в одном рисунке

```
User Input
     ↓
LoginScreen / HomeScreen (UI)
     ↓
AuthService / AuthNotifier (Business Logic)
     ↓
Firebase Auth (Backend)
     ↓
StreamBuilder (Router)
     ↓
Show HomeScreen / LoginScreen
```

## 🎨 Валидация API

```dart
// Email
Validators.validateEmail(email) → String? or null

// Пароль
Validators.validatePassword(password) → String? or null

// Имя
Validators.validateName(name) → String? or null

// Проверить валидность
Validators.isValidEmail(email) → bool
Validators.isValidPassword(password) → bool
```

## 🔐 Firebase Security Rules шаблон

```json
{
  "rules": {
    "users/{uid}": {
      "allow read, write: if request.auth.uid == uid;"
    }
  }
}
```

## 💡 Tips & Tricks

1. **Отладка Firebase:**
   ```dart
   FirebaseAuth.instance.currentUser?.getIdToken(forceRefresh: true);
   ```

2. **Проверка авторизации:**
   ```dart
   bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
   ```

3. **Получить UID:**
   ```dart
   String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
   ```

4. **Отправить email:**
   ```dart
   FirebaseAuth.instance.sendPasswordResetEmail(email: email);
   ```

## 📞 Где найти помощь

| Проблема | Помощь |
|----------|--------|
| Firebase документация | https://firebase.google.com/docs |
| Riverpod помощь | https://riverpod.dev |
| Flutter issues | https://github.com/flutter/flutter/issues |
| Stack Overflow | [firebase-authentication] tag |
| Firebase Support | https://firebase.google.com/support |

## 🎯 Вопросы для себя

- ✓ Где хранятся пароли? В Firebase Secure Storage (автоматически)
- ✓ Как обновить токен? Автоматически при access token expiry
- ✓ Как логировать ошибки? Используйте FirebaseAuth.instance методы
- ✓ Как кэшировать user? Используйте Riverpod провайдеры
- ✓ Как сделать 2FA? Firebase поддерживает natively

---

**Сохраните эту страницу как закладку для быстрого доступа!**
