import 'package:flutter/services.dart';

class WebViewMessageChannel {
  late final MessageCodec codec;
  final BinaryMessenger? binaryMessenger;
  WebViewMessageChannel({MessageCodec? codec, this.binaryMessenger}) {
    this.codec = codec ?? const StandardMessageCodec();
  }

  Future<Map<Object?, Object?>?> send(
    String name,
    dynamic message,
  ) async {
    final BasicMessageChannel channel =
        BasicMessageChannel(name, codec, binaryMessenger: binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(message) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return replyMap;
    }
  }
}
