import 'package:flutter/material.dart';

import '../../../themes/themes.dart';

class ButtonRegister extends StatelessWidget {
  const ButtonRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Center(
          child: RichText(
            text: TextSpan(
              text: 'Não possui uma conta? ',
              style: TextStyle(
                color: AppColors.dark80,
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: ' Registrar',
                  style: TextStyle(
                    color: AppColors.dark100,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
