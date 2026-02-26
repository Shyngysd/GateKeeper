# 🔐 Firebase Authentication в Flutter (2026)

**Полнофункциональная система аутентификации с Firebase**, включая Email/Password, Google Sign-In, управление профилем и автоматическую защиту маршрутов.

![Flutter](https://img.shields.io/badge/Flutter-3.9+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.9+-green.svg)
![Firebase](https://img.shields.io/badge/Firebase-Latest-orange.svg)
![License](https://img.shields.io/badge/License-MIT-purple.svg)

## ✨ Функциональность

- ✅ **Регистрация и вход** по email/паролю
- ✅ **Google Sign-In** для быстрого входа
- ✅ **Сброс пароля** (Forgot Password) с email подтверждением
- ✅ **Профиль пользователя** с фото и редактированием
- ✅ **Автоматическая смена экранов** (защита маршрутов)
- ✅ **Обработка ошибок** Firebase с понятными сообщениями
- ✅ **Индикаторы загрузки** для лучшей UX
- ✅ **Валидация входных данных** перед отправкой
- ✅ **Riverpod 2.0** для управления состоянием
- ✅ **Material Design 3** для современного UI

## 📊 Архитектура

```
┌───────────── main.dart ──────────────┐
│   Firebase инициализация              │
│   StreamBuilder для маршрутизации     │
└────────────┬────────────────────────┘
             │
      ┌──────┴──────┐
      ▼             ▼
  LoginScreen   HomeScreen
  (sign up,    (profile,
   sign in,     edit,
   forgot pwd)  logout)
```

**Слои:**
- 🎨 **UI Layer**: `LoginScreen`, `HomeScreen`
- 🔧 **Service Layer**: `AuthService`, `AuthNotifier`
- 🔥 **Firebase Layer**: `Auth`, `Authentication Methods`
- ✅ **Utils**: `Validators`, `Widgets`

## 🚀 Быстрый старт

### 1. Клонируйте/загрузите проект
```bash
cd day32
```

### 2. Запустите конфигурацию Firebase
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 3. Установите зависимости
```bash
flutter pub get
```

### 4. Запустите приложение
```bash
flutter run
```

## 📋 Требования

- Flutter `^3.9.2`
- Dart `^3.9.2`
- Firebase Console аккаунт
- Android SDK 21+ или iOS 11+

## 📦 Зависимости

```yaml
firebase_core: ^3.8.0      # Core Firebase
firebase_auth: ^5.2.0      # Authentication
firebase_ui_auth: ^1.7.0   # Pre-built UI (optional)
google_sign_in: ^6.2.2     # Google Sign-In
riverpod: ^2.8.0           # State management
flutter_riverpod: ^2.8.0   # Riverpod for Flutter
```

## 📁 Структура проекта

```
lib/
├── main.dart                      # Точка входа, Firebase init
├── firebase_options.dart          # Firebase config (генерируется)
├── screens/
│   ├── login_screen.dart          # Вход, регистрация, Forgot Password
│   └── home_screen.dart           # Профиль, редактирование, выход
├── services/
│   ├── auth_service.dart          # Firebase Auth операции
│   └── auth_notifier.dart         # Riverpod провайдеры
├── widgets/
│   └── auth_widgets.dart          # Переиспользуемые компоненты
└── utils/
    └── validators.dart            # Валидация входных данных
```

## 🔧 Конфигурация Firebase

### Шаг 1: Создайте Firebase проект
1. Перейдите на [Firebase Console](https://console.firebase.google.com)
2. Нажмите "Create New Project"
3. Введите имя и создайте

### Шаг 2: Добавьте приложение
- Выберите платформы: Android, iOS, Web
- Следуйте инструкциям скачивания конфиг файлов

### Шаг 3: Включите методы аутентификации
В Firebase Console → Build → Authentication:
- ✅ **Email/Password** (обязательно)
- ✅ **Google** (опционально)

### Шаг 4: Запустите flutterfire configure
```bash
flutterfire configure
```

Это автоматически:
- Обновит `pubspec.yaml`
- Сгенерирует `firebase_options.dart`
- Настроит платформо-специфичные файлы

## 💡 Использование

### Вход по email/паролю
```dart
final authService = AuthService();
await authService.signInWithEmailPassword(
  email: 'user@example.com',
  password: 'password123',
);
```

### Вход через Google
```dart
await authService.signInWithGoogle();
```

### Сброс пароля
```dart
await authService.sendPasswordResetEmail('user@example.com');
```

### Выход
```dart
await authService.signOut();
```

### Обновление профиля
```dart
await authService.updateUserProfile(
  displayName: 'New Name',
  photoURL: 'https://example.com/photo.jpg',
);
```

## 🎯 Основные компоненты

### AuthService
Управление всеми операциями Firebase Auth с обработкой ошибок:
```dart
signUpWithEmailPassword() → UserCredential
signInWithEmailPassword() → UserCredential
signInWithGoogle() → UserCredential?
signOut() → Future<void>
sendPasswordResetEmail() → Future<void>
updateUserProfile() → Future<void>
```

### StreamBuilder Navigation
Автоматическая смена экранов на основе auth состояния:
```dart
StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return HomeScreen();
    }
    return LoginScreen();
  },
)
```

### Riverpod Providers
Управление состоянием операций аутентификации:
```dart
authServiceProvider         # Получить AuthService
authStateChangesProvider    # Слушать изменения auth
currentUserProvider         # Текущий пользователь
authNotifierProvider        # Управлять операциями
```

## 🛡️ Обработка ошибок

Приложение обрабатывает все типичные Firebase ошибки:

| Ошибка | Сообщение |
|--------|-----------|
| `user-not-found` | Пользователь не найден |
| `wrong-password` | Неверный пароль |
| `email-already-in-use` | Email уже используется |
| `weak-password` | Пароль слишком слабый |
| `too-many-requests` | Слишком много попыток |

## 📚 Документация

| Файл | Описание |
|------|---------|
| [GETTING_STARTED.md](GETTING_STARTED.md) | Быстрый старт за 5 минут |
| [FIREBASE_SETUP.md](FIREBASE_SETUP.md) | Подробная настройка Firebase |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Архитектура приложения |
| [FIREBASE_OPTIONS_EXAMPLE.md](FIREBASE_OPTIONS_EXAMPLE.md) | Пример конфигурации |

## 🧪 Тестирование

```bash
# Юнит тесты
flutter test

# Интеграционные тесты
flutter test integration_test/
```

## 🔐 Безопасность

### Best Practices
- ✅ Валидация данных на frontend
- ✅ Защита маршрутов через StreamBuilder
- ✅ Безопасное хранение токенов (Firebase управляет)
- ✅ HTTPS для всех коммуникаций
- ✅ Ограничение API ключей в Firebase Console

### Firebase Security Rules
```json
{
  "rules": {
    "users/{uid}": {
      "allow read, write: if request.auth.uid == uid;"
    }
  }
}
```

## 🐛 Решение проблем

### Google Sign-In не работает на Android
```bash
# Получите SHA-1:
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey -storepass android -keypass android

# Добавьте в Firebase Console
```

### Firebase config не найден
```bash
# Перезапустите конфигурацию:
flutterfire configure --reconfigure
```

## 🚀 Развертывание

### Production Build Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### Production Build iOS
```bash
flutter build ios --release
```

### Production Build Web
```bash
flutter build web --release
```

## 📊 Статистика проекта

- 📝 **Строк кода**: ~1500
- 📦 **Зависимостей**: 6 основных
- 🎨 **UI Экранов**: 2
- 🔧 **Services**: 2
- ✅ **Функций**: 10+

## 🎓 Обучение

### Для новичков
1. Начните с [GETTING_STARTED.md](GETTING_STARTED.md)
2. Изучите [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
3. Попробуйте понять [main.dart](lib/main.dart)

### Для опытных разработчиков
1. Смотрите [ARCHITECTURE.md](ARCHITECTURE.md)
2. Изучите использование Riverpod
3. Модифицируйте под ваши нужды

## 🤝 Способы улучшения

- 🔔 Добавить push уведомления
- 💾 Интегрировать Firestore для дополнительных данных
- 🖼️ Firebase Storage для загрузки фото
- 📧 Email верификация
- 🔐 Двухфакторная аутентификация (2FA)
- 📱 Биометрическая аутентификация

## 📄 Лицензия

MIT License - смотрите [LICENSE](LICENSE) файл

## 👨‍💻 Автор

**Flutter Developer**  
День 32 Flutter Challenge 2026

## 🔗 Полезные ссылки

- 📚 [Firebase Documentation](https://firebase.google.com/docs)
- 🔐 [Firebase Auth Reference](https://firebase.google.com/docs/auth/flutter-start)
- 📦 [Riverpod Documentation](https://riverpod.dev)
- 🔵 [Google Sign-In Flutter](https://pub.dev/packages/google_sign_in)
- 📱 [Flutter Documentation](https://flutter.dev/docs)

---

**⭐ Если понравилось - поставьте звезду в репозитории!**

**Последнее обновление:** 26 февраля 2026
samples, guidance on mobile development, and a full API reference.
