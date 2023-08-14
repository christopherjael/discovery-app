import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:discoveryapp/components/my_button.dart';
import 'package:discoveryapp/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key, this.onTap});
  final Function()? onTap;
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();


  void ShowWrongMessage(String message) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(title: Center(child: Text(message)));
    });
  }

  // sign user in method
  void signUserUp() async{
    showDialog(context: context, builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
    try{
      if(passwordController.text == confirmPasswordController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      }else{
        ShowWrongMessage('Las contraseñas no coinciden');
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e){
      Navigator.pop(context);
      if(e.code == 'user-not-found'){
        ShowWrongMessage(e.code);
      }else if (e.code == 'wrong-password'){
        ShowWrongMessage(e.code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                const Icon(
                  Icons.map,
                  size: 50,
                ),
                Text('DiscoveryApp'),
                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  'Vamos a crear una cuenta para ti!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 25),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirmar Contraseña',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  text: 'Crear cuenta',
                  onTap: signUserUp,
                ),

                const SizedBox(height: 50),


                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ya tiene una cuenta?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Iniciar Sesion Aqui',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
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
