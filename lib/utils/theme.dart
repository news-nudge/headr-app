


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class T1{

  static ThemeData darkTheme() {
    return ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: const Color.fromRGBO(30, 31, 33, 1),
      primaryColor: const Color.fromRGBO(255, 255, 255, 1.0),
      cardColor: const Color.fromRGBO(255, 113, 35, 1),
      canvasColor: const Color.fromRGBO(254, 255, 255, 1),
      highlightColor: const Color(0xffb8bdc9),

      textTheme: TextTheme(
        displaySmall: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
        displayLarge: GoogleFonts.inter(),
        displayMedium: GoogleFonts.inter(),

        headlineLarge: GoogleFonts.inter(),
        headlineMedium: GoogleFonts.inter(),
        headlineSmall: GoogleFonts.inter(),

        titleLarge: GoogleFonts.inter(),
        titleMedium: GoogleFonts.inter(),
        titleSmall: GoogleFonts.inter(),

        bodyLarge: GoogleFonts.inter(),
        bodyMedium: GoogleFonts.inter(),
        bodySmall: GoogleFonts.inter(),
      ),
    );
  }

  static List<String> fixTime(TimeOfDay from,TimeOfDay to){
    debugPrint("From Hour :${from.hour}");
    String fromHour= '';
    String toHour = '';
    String fromMinute = '';
    String toMinute = '';
    if(from.hour<10){
      fromHour = '0${from.hour}';
    }else if(from.hour >12){
      if(from.hour<22){
        fromHour = '0${from.hour - 12}';
      }else{
        fromHour = '${from.hour - 12}';
      }
    }else if(from.hour==10 || from.hour==11 || from.hour == 12){
      fromHour = '${from.hour}';
    }

    if(to.hour<10){
      toHour = '0${to.hour}';
    }else if(to.hour>12){
      if(to.hour<22){
        toHour = '0${to.hour - 12}';
      }else{
        toHour = '${to.hour - 12}';
      }
    }else if(to.hour==10 || to.hour==11 || to.hour == 12){
      toHour = '${to.hour}';
    }

    if(to.minute==0){
      toMinute = '00';
    }else if(to.minute<10){
      toMinute = '0${to.minute}';
    }else{
      toMinute = '${to.minute}';
    }

    if(from.minute==0){
      fromMinute = '00';
    }else if(from.minute<10){
      fromMinute = '0${from.minute}';
    }else{
      fromMinute = '${from.minute}';
    }

    debugPrint('From hour :$fromHour');
    return [fromHour,toHour,fromMinute,toMinute];
  }



}