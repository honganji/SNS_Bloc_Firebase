/* 
  LOGIN PAGE

  on this page, an existing user can login with their:
  - email
  - password

  ------------------------------------------------------------------------------

  Once the user successfully logs in, they will be redirected to home page.
  If user doesn't have an account yet, they can go to register page from here to
  create one.
*/

import 'package:flutter/material.dart';
import 'package:sns_bloc_firebase/features/auth/presentation/components/my_button.dart';
import 'package:sns_bloc_firebase/features/auth/presentation/components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({
    super.key,
    required this.togglePages
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final confirmPwController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_open_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 60),
                Text(
                  "Let's create an account for you!",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary, fontSize: 16),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: nameController,
                  hintText: "Name",
                  obscureText: false
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: pwController,
                  hintText: "Password",
                  obscureText: true
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: confirmPwController,
                  hintText: "Confirm Password",
                  obscureText: true
                ),
                const SizedBox(height: 25),
                MyButton(
                  onTap: (){},
                  text: "Register"
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already a member? ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        "Login now",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
