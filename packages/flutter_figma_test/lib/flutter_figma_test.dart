library flutter_figma_test;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_figma_test/data/figma_config.dart';
import 'package:flutter_figma_test/service/figma_api.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';

FutureOr<void> compareFigmaAndGolden<T>({
  required Widget Function(ThemeData theme, ThemeMode themeMode) widgetBuilder,
  required String Function(FigmaConfig config) getGoldenName,
  required List<FigmaConfig> figmaLayouts,
  required String figmaToken,
}) async {
  final imageBytes = <String, Uint8List?>{};

  testWidgets(
    'Retrieve figma images of $T',
    (widgetTester) async {
      await Future.forEach(
        figmaLayouts,
        (config) async {
          final figmaLink = config.link;
          await widgetTester.runAsync(
            () async {
              await HttpOverrides.runZoned(
                () async {
                  final image = await FigmaRestApi.downloadFrameImage(
                    figmatToken: figmaToken,
                    figmaframeUrl: figmaLink,
                    imageScale: 1,
                  );

                  if (image != null) {
                    imageBytes[config.link] = image;
                  }
                },
                createHttpClient: (SecurityContext? context) {
                  return _MyHttpOverrides().createHttpClient(context);
                },
              );
            },
          );
        },
      );
    },
  );

  testGoldens(
    'Figma and Implementation Comparison of $T',
    (tester) async {
      for (final FigmaConfig config in figmaLayouts) {
        final image = imageBytes[config.link];

        if (image != null) {
          final builder = GoldenBuilder.grid(
            columns: 2,
            widthToHeightRatio: 0.2,
          );

          builder.addScenario(
            'Figma',
            Transform.translate(
              offset: Offset(-config.cropOffset.left, -config.cropOffset.top),
              child: _CroppedImageWidget(image, config.cropOffset),
            ),
          );

          builder.addScenario(
            'Real',
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: config.size.width - config.cropOffset.left - config.cropOffset.right,
                maxHeight: config.size.height - config.cropOffset.top - config.cropOffset.bottom,
              ),
              child: SizedBox(
                width: config.size.width - config.cropOffset.left - config.cropOffset.right,
                height: config.size.height - config.cropOffset.top - config.cropOffset.bottom,
                child: widgetBuilder(config.theme, config.themeMode),
              ),
            ),
          );

          await tester.pumpWidgetBuilder(
            builder.build(),
            surfaceSize: Size(
              (config.size.width - config.cropOffset.left - config.cropOffset.right) * 2 + 50,
              (config.size.height - config.cropOffset.bottom - config.cropOffset.top) + 100,
            ),
            wrapper: materialAppWrapper(),
          );

          await screenMatchesGolden(
            tester,
            getGoldenName(config),
          );
        }
      }
    },
  );
}

class _MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class _CustomImageClipper extends CustomClipper<Rect> {
  final EdgeInsets cropOffset;

  _CustomImageClipper(this.cropOffset);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      cropOffset.left,
      cropOffset.top,
      size.width - cropOffset.right,
      size.height - cropOffset.bottom,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}

class _CroppedImageWidget extends StatelessWidget {
  final Uint8List imageBytes;
  final EdgeInsets cropOffset;

  const _CroppedImageWidget(this.imageBytes, this.cropOffset);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipper: _CustomImageClipper(cropOffset),
      child: Image.memory(imageBytes),
    );
  }
}
