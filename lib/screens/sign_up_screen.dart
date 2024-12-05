import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // TODO: 1. Deklarasi Variable
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  String _errorText = '';

  bool _isSignIN = false;

  bool _obscurePassword = true;

void _signUp() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String name = _nameController.text.trim();
  final String username = _usernameController.text.trim();
  final String password = _passwordController.text.trim();

  // Validasi input
  if (name.isEmpty || username.isEmpty || password.isEmpty) {
    setState(() {
      _errorText = 'Semua kolom harus diisi.';
    });
    return;
  }

  if (password.length < 8 ||
      !password.contains(RegExp(r'[A-Z]')) || 
      !password.contains(RegExp(r'[a-z]')) || 
      !password.contains(RegExp(r'[0-9]')) || 
      !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_]'))) {
    setState(() {
      _errorText = 'Minimal 8 karakter, Kombinasi [A-Z], [a-z], [0-9], [!@#-%^&*(),.?":{}|<>_].';
    });
    return;
  }

  try {
    final encrypt.Key key = encrypt.Key.fromLength(32); // Tetap random, tetapi simpan.
    final encrypt.IV iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encryptedName = encrypter.encrypt(name, iv: iv);
    final encryptedUsername = encrypter.encrypt(username, iv: iv);
    final encryptedPassword = encrypter.encrypt(password, iv: iv);

    // Simpan data yang terenkripsi dan kunci ke SharedPreferences
    await prefs.setString('fullname', encryptedName.base64);
    await prefs.setString('username', encryptedUsername.base64);
    await prefs.setString('password', encryptedPassword.base64);
    await prefs.setString('key', key.base64);
    await prefs.setString('iv', iv.base64);

    print('Registration successful!');
    print('Encrypted Data:');
    print('Name: ${encryptedName.base64}');
    print('Username: ${encryptedUsername.base64}');
    print('Password: ${encryptedPassword.base64}');
    print('Key: ${key.base64}');
    print('IV: ${iv.base64}');

    // Navigasi ke halaman login
    Navigator.pushReplacementNamed(context, '/signin');
  } catch (e) {
    print('Encryption or saving failed: $e');
    setState(() {
      _errorText = 'Terjadi kesalahan saat proses registrasi.';
    });
  }
}

  @override
  void dispose(){
    _usernameController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: 2 Pasang APP BAr
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      // TODO: 3 Pasang BOdy
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: Column(
                // TODO: 4 Atur MainAxisAlignment dan CrossAxisAlignment
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //TODO: 9. Pasang text formField Nama
                   TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // TODO: 5 Pasang TextFormField
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Pengguna',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  // TODO: 6 Pasang TextFormField Kedua
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      errorText: _errorText.isNotEmpty ? _errorText : null,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                  ),
                  // TODO: 7 Pasang ElevatedButton Sign in
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signUp,
                    child: const Text('Sign Up'),
                  ),
                  // TODO: 8 Pasang ElevatedButton Register
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: 'Sudah punya Akun?',
                      style: const TextStyle(fontSize: 16, color: Colors.deepPurple),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Masuk Disini',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () { Navigator.pushNamed(context, '/signin');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
