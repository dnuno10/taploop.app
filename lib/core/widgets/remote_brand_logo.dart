import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RemoteBrandLogo extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const RemoteBrandLogo({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  bool get _isSvg {
    final normalized = imageUrl.toLowerCase().split('?').first;
    return normalized.endsWith('.svg');
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isSvg) {
      return SvgPicture.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholderBuilder: (_) => _placeholder(),
      );
    }

    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      gaplessPlayback: true,
      frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return _placeholder();
      },
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }
}
