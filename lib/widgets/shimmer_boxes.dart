import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_blurhash/flutter_blurhash.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

T getOne<T>(List<T> l) {
  return l[Random().nextInt(l.length)];
}

List<String> blurHashes = [
  'LOHTN|}wItIq~B^PnTNKo{tPs;s;',
  'L8DIL;5M00xITjx04m-r02WV~WNX',
  'LbDm,SMwITxv~VM|Ips-?cRjRPoz',
  'L17AxV\$%100#}W4pKO9b.7t7-V9]',
  'LO6Iw9tVp0RNOxS,a\$ngVqtTV?XA',
  'L7Db:6T24T}U00-r.A9Y}U{v;eF|',
];

class CustomCacheImage extends StatelessWidget {
  const CustomCacheImage({
    super.key,
    required this.imageUrl,
    this.blurHash,
    this.radius = 0,
    this.showError = false,
  });

  final String imageUrl;
  final String? blurHash;
  final double radius;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
          cacheManager: CacheManager(
            Config(
              "cache",
              stalePeriod: const Duration(days: 3600),
            ),
          ),
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => showError
              ? Container(
                  color: Colors.white,
                  child: Center(
                    child: kDebugMode ? Text(error.toString()) : const Placeholder(),
                  ),
                )
              : BlurHash(hash: (blurHash != null) ? blurHash! : getOne(blurHashes)),
          progressIndicatorBuilder: (context, url, DownloadProgress progress) {
            return Stack(
              children: [
                BlurHash(hash: (blurHash != null) ? blurHash! : getOne(blurHashes)),
                // Center(
                //   child: CircularProgressIndicator(
                //     value: progress.progress ?? 1,
                //   ),
                // ),
              ],
            ).animate(
              onPlay: (controller) {
                controller.repeat();
              },
            ).shimmer(
              delay: 1500.ms,
              duration: 1500.ms,
              curve: Curves.decelerate,
              angle: 1,
            );
          },
          imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    // colorFilter: const ColorFilter.mode(
                    //   Colors.red,
                    //   BlendMode.colorBurn,
                    // ),
                  ),
                ),
              )
          // .animate()
          // .scale(
          //       duration: 300.ms,
          //       begin: const Offset(1.25, 1.25),
          //       end: const Offset(1, 1),
          //     ),
          ),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({Key? key, required this.isLoading, required this.child, required this.loadingChild})
      : super(key: key);

  final bool isLoading;
  final Widget child;
  final Widget loadingChild;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loadingChild.animate(
            onPlay: (controller) {
              controller.repeat();
            },
          ).shimmer(
            delay: 1500.ms,
            duration: 1500.ms,
            curve: Curves.decelerate,
            angle: 1,
          )
        : child;
  }
}
