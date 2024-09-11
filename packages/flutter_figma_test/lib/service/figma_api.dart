import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_figma_test/data/figma_api_error.dart';
import 'package:flutter_figma_test/data/figma_image_request_data.dart';

class FigmaRestApi {
  const FigmaRestApi._();

  static Future<Uint8List?> downloadFrameImage({
    required String figmatToken,
    required String figmaframeUrl,
    required double imageScale,
  }) async {
    final figmaParams = await parseNodeId(figmaframeUrl);

    final dio = Dio(
      BaseOptions(
        baseUrl: "https://api.figma.com",
        headers: {
          'X-Figma-Token': figmatToken,
          'Accept': 'application/json',
        },
      ),
    );

    final result = await dio.get(
      '/v1/images/${figmaParams.fileKey}',
      queryParameters: {
        'ids': figmaParams.nodeId,
        'scale': imageScale,
      },
    );

    final linkToImage = await handleResponse(result, figmaParams.nodeId);
    final response = await dio.get<List<int>>(
      linkToImage,
      options: Options(responseType: ResponseType.bytes),
    );

    final data = response.data;
    return data == null ? null : Uint8List.fromList(data);
  }

  static Future<String> handleResponse(Response httpResponse, String nodeId) async {
    final statusCode = httpResponse.statusCode;
    if (statusCode != null && statusCode >= 200 && statusCode < 300) {
      final responseJson = httpResponse.data;

      if (responseJson['err'] != null) {
        return Future.error(FigmaApiError(responseJson['err']));
      }

      final images = responseJson['images'];
      if (!images.containsKey(nodeId)) {
        // If Figma API returns node ID with colon instead of dash.
        final nodeIdWithColon = nodeId.replaceAll('-', ':');
        if (images.containsKey(nodeIdWithColon)) {
          return images[nodeIdWithColon];
        }

        return Future.error(FigmaApiError("Node ID ('$nodeId') not found."));
      }

      return images[nodeId];
    } else {
      throw HttpException(
        "Failed to load image: ${httpResponse.statusMessage}",
        uri: httpResponse.realUri,
      );
    }
  }

  static Future<FigmaImageRequestData> parseNodeId(String frameUrl) {
    final uri = Uri.tryParse(frameUrl);

    if (uri == null) {
      return Future.error(_createFrameUrlError);
    }

    final queryParameters = uri.queryParameters;

    if (!queryParameters.containsKey('node-id')) {
      return Future.error(_createFrameUrlError);
    }

    final nodeId = queryParameters['node-id']!;
    final fileKey = uri.pathSegments[1];

    return Future.value(FigmaImageRequestData(
      nodeId: nodeId,
      fileKey: fileKey,
    ));
  }

  static FigmaApiError _createFrameUrlError(String frameUrl) => FigmaApiError(
        "Invalid frame URL: $frameUrl. Should like this: 'https://www.figma.com/file/<file-key>/<figma-file-name>?node-id=<node-id>'",
      );
}
