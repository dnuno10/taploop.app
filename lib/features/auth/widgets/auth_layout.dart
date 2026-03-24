import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/theme/app_theme_extensions.dart';

/// Wraps auth screens in a centered, scrollable, responsive card layout.
class AuthLayout extends StatelessWidget {
  final Widget child;

  const AuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final cardWidth = Responsive.authCardWidth(context);
    final hPadding = Responsive.authPadding(context);

    return Scaffold(
      backgroundColor: context.bgPage,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/equipos-hero.jpg', fit: BoxFit.cover),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(color: Colors.white.withValues(alpha: 0.58)),
            ),
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 0 : hPadding,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: cardWidth),
                  child: isMobile
                      ? Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: context.bgCard.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: context.borderColor),
                          ),
                          child: child,
                        )
                      : Card(
                          color: context.bgCard.withValues(alpha: 0.9),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: context.borderColor,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: child,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
