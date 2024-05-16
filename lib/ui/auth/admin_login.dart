

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:headr/controllers/auth_controller.dart';
import 'package:headr/utils/constants.dart';
import 'package:headr/widgets/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {

  final AuthController ac = Get.find();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: ()async{
                if(emailController.text!='' && passwordController.text!=''){
                  ac.anonymousLogin(context,emailController.text, passwordController.text);
                }else{
                  errorToast('Please enter all the fields');
                }
              },
              child: Container(
                width: 90.w,
                height: 6.h,
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Login (Admins only)",style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 3.h,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent
                        ),
                        child: const Center(child: Icon(Icons.chevron_left_rounded),),
                      ),
                    ),
                    Text("Enter the details",style: Get.textTheme.titleLarge,),
                    SizedBox(width: 10.w,)
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 4.h,),
                    CustomTextFormField(
                      hintText: 'Enter email address',
                      color: Colors.white.withOpacity(0.5),
                      prefixIcon: const Icon(Icons.account_circle_outlined,color: Colors.white,),
                      controller: emailController,
                      focusNode: emailNode,
                    ),

                    SizedBox(height: 4.h,),
                    CustomTextFormField(
                      hintText: 'Enter password',
                      color: Colors.white.withOpacity(0.5),
                      prefixIcon: const Icon(Icons.password,color: Colors.white,),
                      controller: passwordController,
                      focusNode: passwordNode,
                      type: TextInputType.visiblePassword,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
