import 'package:flutter/material.dart';

class ShimmerContainer extends StatefulWidget {
  const ShimmerContainer(
      {required this.height,
      required this.width,
      this.borderRadius,
      this.alignment,
      this.child,
      super.key});

  final double height;
  final double width;
  final BorderRadius? borderRadius;
  final Widget? child;
  final Alignment? alignment;

  @override
  State<ShimmerContainer> createState() => _ShimmerContainerState();
}

class _ShimmerContainerState extends State<ShimmerContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController)
          ..addListener(() {
            setState(() {});
          });
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    if(mounted){
    _animationController.dispose();}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint(_animation.value.toString());
    return Container(
      height: widget.height,
      width: widget.width,
      alignment: widget.alignment,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(5),
        gradient: LinearGradient(
          colors: [
            Colors.grey.withOpacity(0.5),
            Colors.grey.withOpacity(0.1),
            Colors.grey.withOpacity(0.5),
          ],
          stops: [
            _animation.value - 1.0,
            _animation.value,
            _animation.value + 2.6,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: widget.child,
    );
  }
}
