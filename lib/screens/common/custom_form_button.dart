import 'package:flutter/material.dart';

class CustomFormButton extends StatelessWidget {
  final String innerText;
  final void Function()? onPressed;
  const CustomFormButton({Key? key, required this.innerText, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      decoration: BoxDecoration(
        // color: const Color(0xff233743),
        borderRadius: BorderRadius.circular(26),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(innerText, style: const TextStyle(color: Color.fromARGB(255, 189, 27, 27), fontSize: 20),),
      ),
    );
  }
}
