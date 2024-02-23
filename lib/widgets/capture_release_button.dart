import 'package:flutter/material.dart';
import 'package:pokemon/widgets/show_image.dart';

class CaptureReleaseButton extends StatefulWidget {
  const CaptureReleaseButton({
    required this.initialValue,
    required this.onClick,
    required this.value,
    this.maxSize = 20,
    Key? key}) : super(key: key);
  final void Function() onClick;
  final void Function(bool value) value;
  final bool initialValue;
  final double maxSize;

  @override
  _CaptureReleaseButtonState createState() => _CaptureReleaseButtonState();
}

class _CaptureReleaseButtonState extends State<CaptureReleaseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  


  void _toggleCaptured() {
    widget.onClick();

    if (!widget.initialValue) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _sizeAnimation = Tween<double>(begin: widget.maxSize - 3, end: widget.maxSize).animate(_controller);
  }


  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: _toggleCaptured,
      child: AnimatedBuilder(
        animation: _controller,
      
        builder: (context, child) {
          return SizedBox(
            child: Row(
              children: [
                Container(
                  width: _sizeAnimation.value,
                  height: _sizeAnimation.value,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    
                  ),
                  child: Center(
                    child: widget.initialValue
                        ?  ShowImage(imagelink: 'assets/icons/poke_ball.png',height: widget.maxSize,)
                        :  ShowImage(imagelink:  'assets/icons/pokeball.svg',height: widget.maxSize,),
                  ),
                ),
                 SizedBox(width: widget.maxSize * 0.1,),
                 widget.initialValue
                        ? Text('Release',style: TextStyle(fontSize: widget.maxSize/1.6 ),)
                        : Text('Capture',style: TextStyle(fontSize: widget.maxSize/1.6 )),
              ],
            ),
          );
        },
      ),
    );
  }

  
}
