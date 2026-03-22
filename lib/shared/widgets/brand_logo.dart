import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.size = 120,
    this.showWordmark = true,
    this.tagline,
    this.center = true,
  });

  final double size;
  final bool showWordmark;
  final String? tagline;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset(
          'assets/branding/juntapp_logo.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) {
            return Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.groups_rounded,
                size: size * 0.42,
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          },
        ),
      ),
      if (showWordmark) ...[
        const SizedBox(height: 10),
        Text(
          'Juntar plata fácil',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: center ? TextAlign.center : TextAlign.start,
        ),
      ],
      if ((tagline ?? '').isNotEmpty) ...[
        const SizedBox(height: 4),
        Text(
          tagline!,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: center ? TextAlign.center : TextAlign.start,
        ),
      ],
    ];

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: children,
    );

    if (center) {
      return Center(child: content);
    }
    return content;
  }
}
