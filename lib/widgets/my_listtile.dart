import 'package:flutter/material.dart';
import 'package:pokemon/widgets/shimmer_container.dart';

class MyListTile extends StatelessWidget {
  const MyListTile(
      {required this.title,
      this.onTap,
      this.titleStyle =
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      this.showLeading = true,
      this.height = 85,
      this.tileColor = Colors.transparent,
      this.leadingchild,
      this.leadingHeight = 50,
      this.leadingWidth = 0,
      this.nullHeight = false,
      this.leadingBorderColor = Colors.transparent,
      this.leadingColor = Colors.transparent,
      this.subtitle,
      this.subtitle2,
      this.trailing,
      this.borderColor = Colors.transparent,
      this.borderRadius = BorderRadius.zero,
      this.padding = const EdgeInsets.all(10.0),
      this.margin = EdgeInsets.zero,
      this.shadow,
      super.key});
  final bool showLeading;
  final Widget? leadingchild;
  final Widget? trailing;
  final String title;
  final TextStyle titleStyle;
  final void Function()? onTap;
  final double height;
  final BorderRadius borderRadius;
  final Color borderColor;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color tileColor;
  final double leadingHeight;
  final double leadingWidth;
  final Color leadingBorderColor;
  final Color leadingColor;
  final bool nullHeight;
  final List<BoxShadow>? shadow;
  final Widget? subtitle;
  final Widget? subtitle2;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          color: tileColor,
          borderRadius: borderRadius,
          boxShadow: shadow
        ),
        height: nullHeight ? null : height,
        padding: padding,
        margin: margin,
        child: Row(
          crossAxisAlignment: subtitle == null
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (showLeading)
              Container(
                height: leadingHeight,
                width: leadingWidth == 0 ? leadingHeight : leadingWidth,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: leadingColor,
                    border: Border.all(color: leadingBorderColor),
                    borderRadius: BorderRadius.circular(15)),
                child: leadingchild,
              ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: subtitle == null
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceEvenly,
                children: [
                  title == 'null/'
                      ? const ShimmerContainer(height: 14, width: 140)
                      : Text(title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: titleStyle),
                  if (nullHeight)
                    const SizedBox(
                      height: 3,
                    ),
                  if (subtitle != null) subtitle!,
                  if (nullHeight)
                    const SizedBox(
                      height: 5,
                    ),
                  if (subtitle2 != null) subtitle2!,
                ],
              ),
            ),
            Container(
              child: trailing,
            )
          ],
        ),
      ),
    );
    
  }
}
