
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/constants.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(noInternet,
              fit: BoxFit.contain,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Device is not connected to internet !",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
              ),
            ],
          )
        ],
      ),
    );
  }
}