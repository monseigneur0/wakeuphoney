import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wakeuphoney/common/common.dart';

class StreamError extends StatelessWidget {
  final dynamic error;
  final StackTrace stackTrace;
  const StreamError(this.error, this.stackTrace, {super.key});

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
    logger.e(
      'Error: $error Stack Trace: $stackTrace',
    );
    return Text('Error: $error, Stack Trace: $stackTrace');
  }
}
