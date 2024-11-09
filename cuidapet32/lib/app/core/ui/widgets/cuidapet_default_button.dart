import 'package:flutter/material.dart';
import 'package:cuidapet32/app/core/ui/extension/theme_extension.dart';

class CuidapetDefaultButton extends StatelessWidget {

  final VoidCallback? onPressed;
  final double borderRadius;
  final Color? color;
  final String label;
  final Color? labelColor;
  final double labelSize;
  final double padding;
  final double width;
  final double height;


  const CuidapetDefaultButton({
     super.key, 
     required this.onPressed,
     this.borderRadius = 10,
     this.color,
     required this.label,
      this.labelColor,
      this.labelSize = 20,
      this.padding = 10,
      this.width = double.infinity,
      this.height = 66
     });

   @override
   Widget build(BuildContext context) {
       return Container(
        padding: EdgeInsets.all(padding),
        width: width,
        height: height,
         child: ElevatedButton(
          onPressed: onPressed, 
          
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? context.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
                        ),
          child: Text(label, style: 
           TextStyle(
            color: labelColor ?? Colors.white,
            fontSize: labelSize),
            ),
            ),
       );
  }
}