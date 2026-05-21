import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Normalizes TheMealDB and other recipe image URLs for sharper display.
String normalizeRecipeImageUrl(String url) {
  if (url.isEmpty) return url;
  String normalized = url.trim();
  if (!normalized.startsWith('http')) {
    normalized = 'https://$normalized';
  }
  if (normalized.endsWith('/preview')) {
    normalized = normalized.substring(0, normalized.length - '/preview'.length);
  }
  return normalized;
}

class RecipeImageView extends StatelessWidget {
  const RecipeImageView({
    super.key,
    required this.imageUrl,
    required this.imageData,
    this.aspectRatio = 4 / 3,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final Uint8List imageData;
  final double aspectRatio;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final BorderRadius radius = borderRadius ?? BorderRadius.zero;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _buildImageContent(context, colorScheme),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContent(BuildContext context, ColorScheme colorScheme) {
    final String normalizedUrl = normalizeRecipeImageUrl(imageUrl);

    if (normalizedUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: normalizedUrl,
        fit: fit,
        alignment: Alignment.center,
        filterQuality: FilterQuality.high,
        fadeInDuration: const Duration(milliseconds: 280),
        fadeOutDuration: const Duration(milliseconds: 120),
        placeholder: (_, __) => _loadingPlaceholder(colorScheme),
        errorWidget: (_, __, ___) => _errorPlaceholder(colorScheme),
      );
    }

    if (imageData.isNotEmpty) {
      return Image.memory(
        imageData,
        fit: fit,
        alignment: Alignment.center,
        filterQuality: FilterQuality.high,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => _errorPlaceholder(colorScheme),
      );
    }

    return _errorPlaceholder(colorScheme);
  }

  Widget _loadingPlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: colorScheme.primary.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Widget _errorPlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.restaurant_menu_rounded,
        size: 40,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.45),
      ),
    );
  }
}
