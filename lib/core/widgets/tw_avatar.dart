import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TwAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final AvailabilityDot? availabilityDot;
  final bool showBorder;
  final VoidCallback? onTap;

  const TwAvatar({
    super.key,
    this.imageUrl,
    this.size = 56,
    this.availabilityDot,
    this.showBorder = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: showBorder
                  ? Border.all(color: AppColors.accent, width: 2)
                  : null,
            ),
            child: ClipOval(
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: AppColors.primaryLight,
                        child: Icon(
                          Icons.person,
                          color: AppColors.mediumGrey,
                          size: size * 0.5,
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.primaryLight,
                        child: Icon(
                          Icons.person,
                          color: AppColors.mediumGrey,
                          size: size * 0.5,
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.primaryLight,
                      child: Icon(
                        Icons.person,
                        color: AppColors.mediumGrey,
                        size: size * 0.5,
                      ),
                    ),
            ),
          ),
          if (availabilityDot != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.25,
                height: size * 0.25,
                decoration: BoxDecoration(
                  color: availabilityDot!.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryDark, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum AvailabilityDot {
  available(AppColors.available),
  busy(AppColors.busy),
  offline(AppColors.offline);

  final Color color;
  const AvailabilityDot(this.color);
}
