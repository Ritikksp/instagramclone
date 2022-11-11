// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/Widget/Textfield_Input.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/responsive/mobile_screens_layout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/Sign_up_screem.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';

class LogIn extends StatefulWidget{
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _emailController= TextEditingController();
  final TextEditingController _passController= TextEditingController();
  bool _isloading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isloading = true;
    });

    String res = await AuthMethods().LoginUser(email: _emailController.text, password: _passController.text);
    if(res == 'success'){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>const 
          ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(), 
            webScreenLayout: WebScreenLayout(),
            )
          ));
      ShowSnackBar("Successfully Login", context);
    }else{
      ShowSnackBar(res, context);
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Flexible(flex: 2,child: Container(),),
              //svg image
              SvgPicture.asset('assets/images/Instagram-Wordmark-Black-Logo.wine.svg',
              color: primaryColor,
              height: 64,
              ),
              
              //text input for email
              TextFieldInput(
                hintText: "Enter your email", 
                textEditingController: _emailController, 
                textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24,),
              //text input for password
              TextFieldInput(
                hintText: "Enter your password", 
                textEditingController: _passController, 
                textInputType: TextInputType.visiblePassword,
                isPass: true,
                ),
                const SizedBox(height: 24,),
              //button login
              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)
                      )
                    ),
                  child: _isloading ? const Center(
                     child: CircularProgressIndicator(color: Colors.white,),
                     ) : 
                  const Text("Login"),
                ),
              ),
              const SizedBox(height: 12,),
              Flexible(flex: 2,child: Container()),
              // signing up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Don't have an account? ", style: TextStyle(
                      fontSize: 14
                    ),),
                  ),
                  GestureDetector(
                    onTap: (){Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignUpScreen(),));},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("SignIn", style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8,)
            ],
          ),
        ),
      ),      
    );
  }
}