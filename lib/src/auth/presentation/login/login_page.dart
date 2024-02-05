import 'package:client/src/auth/data/auth_repository.dart';
import 'package:client/src/auth/data/user_model.dart';
import 'package:client/src/auth/presentation/register/register_page.dart';
import 'package:client/src/home/presentation/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AuthRepository authRepository = AuthRepository();

  void _showInvalidCredentialsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Geçersiz Kullanıcı Adı veya Şifre"),
          content: const Text("Lütfen doğru kullanıcı adı ve şifreyi girin."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Tamam"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Client Uygulaması",
                  style: TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                        labelText: 'Username', border: InputBorder.none),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        labelText: 'Password', border: InputBorder.none),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Login butonuna tıklandığında yapılacak işlemleri ekleyin
                    String userName = _usernameController.text;
                    String password = _passwordController.text;
                    // Burada login işlemlerini gerçekleştirebilirsiniz.
                    User? signedUser =
                        await authRepository.signInWithUserNameAndPassword(
                            userName: userName, password: password);
                    if (signedUser != null) {
                      // Giriş başarılı, işlemleri yap
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => HomePage(
                                    user: signedUser,
                                  )));
                      print('Login successful. User: ${signedUser.userName}');
                    } else {
                      _showInvalidCredentialsDialog();
                      // Giriş başarısız, kullanıcıyı uyar veya işlemleri yap
                      print('Invalid username or password');
                    }
                    print(signedUser);
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const RegisterPage(
                                  user: null,
                                )));
                    // Register butonuna tıklandığında yapılacak işlemleri ekleyin
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
