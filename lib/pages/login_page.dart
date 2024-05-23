import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:match_leaderboard_maker/components/my_button.dart';
import 'package:match_leaderboard_maker/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sing user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),

              //logo
              Icon(
                Icons.lock,
                size: 100,
              ),

              SizedBox(
                height: 50,
              ),

              // wellcome back,you've been missed
              Text(
                "Welcome back you\'ve been missed!",
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),

              SizedBox(
                height: 25,
              ),

              //username textfield
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),

              SizedBox(
                height: 10,
              ),

              //password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              SizedBox(
                height: 10,
              ),

              //forget password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forget Password?",
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25,),

              //sign in button
              MyButton(
                onTap: signUserIn,
              ),

              SizedBox(height: 50,),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Or continue with',style: TextStyle(color: Colors.grey[700],),),
                    ),
                    Expanded(child: Divider(thickness: 0.5,color: Colors.grey[400],)),
                  ],
                ),
              ),
              // google + number sign in buttons

              //not member? register now
            ],
          ),
        ),
      ),
    );
  }
}
