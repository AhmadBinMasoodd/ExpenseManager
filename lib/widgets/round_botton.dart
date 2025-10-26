import 'package:flutter/material.dart';
class RoundBotton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  bool loading;
  RoundBotton({Key? key,required this.title,required this.onTap,this.loading=false}):super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return  InkWell(
      onTap: onTap,
      child: Container(
          width: 200,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: LinearGradient(colors: [
              Colors.blue,Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
            ),

          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: loading? CircularProgressIndicator(strokeWidth: 2,color: Colors.white,):Text(title,style: TextStyle(
              fontSize:   20,
              color: Colors.white
            ),),
          ),
      ),
    );
  }
}
