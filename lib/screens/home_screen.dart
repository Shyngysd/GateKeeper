import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:day32/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  late User? _currentUser;
  bool _isUpdatingProfile = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentUser = _authService.currentUser;
    _nameController.text = _currentUser?.displayName ?? '';
    _photoUrlController.text = _currentUser?.photoURL ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleSignOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Вы действительно хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      try {
        await _authService.signOut();
        _showSnackBar('Вы вышли из аккаунта');
      } catch (e) {
        _showSnackBar('Ошибка при выходе: $e', isError: true);
      }
    }
  }

  Future<void> _updateProfileDialog() async {
    _nameController.text = _currentUser?.displayName ?? '';
    _photoUrlController.text = _currentUser?.photoURL ?? '';

    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Редактировать профиль'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Имя',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _photoUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL фото',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                  hintText: 'https://example.com/photo.jpg',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              setState(() => _isUpdatingProfile = true);

              try {
                await _authService.updateUserProfile(
                  displayName: _nameController.text.isEmpty
                      ? null
                      : _nameController.text,
                  photoURL: _photoUrlController.text.isEmpty
                      ? null
                      : _photoUrlController.text,
                );

                setState(() {
                  _currentUser = _authService.currentUser;
                });

                if (context.mounted) {
                  Navigator.pop(context);
                }
                _showSnackBar('Профиль обновлен');
              } catch (e) {
                _showSnackBar('Ошибка: $e', isError: true);
              } finally {
                setState(() => _isUpdatingProfile = false);
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _handleSignOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Выход',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade400, Colors.blue.shade800],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  children: [
                    // User Avatar
                    if (_currentUser?.photoURL != null &&
                        _currentUser!.photoURL!.isNotEmpty)
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            NetworkImage(_currentUser!.photoURL!),
                        onBackgroundImageError: (exception, stackTrace) {},
                        child: const Icon(Icons.person, size: 60),
                      )
                    else
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    const SizedBox(height: 16),

                    // User Name
                    Text(
                      _currentUser?.displayName ?? 'Пользователь',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // User Email
                    Text(
                      _currentUser?.email ?? 'email@unknown.com',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Profile Information Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Информация профиля',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email verification status
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: Text(_currentUser?.email ?? 'N/A'),
                      trailing: _currentUser?.emailVerified ?? false
                          ? const Icon(Icons.verified, color: Colors.green)
                          : const Icon(Icons.pending, color: Colors.orange),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // User ID
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.vpn_key),
                      title: const Text('User ID'),
                      subtitle: Text(
                        _currentUser?.uid ?? 'N/A',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Last Sign In
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Последний вход'),
                      subtitle: Text(
                        _currentUser!.metadata.lastSignInTime
                                ?.toString() ??
                            'N/A',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Edit Profile Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isUpdatingProfile ? null : _updateProfileDialog,
                      icon: const Icon(Icons.edit),
                      label: const Text('Редактировать профиль'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Sign Out Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleSignOut,
                      icon: const Icon(Icons.logout),
                      label: const Text('Выход'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
