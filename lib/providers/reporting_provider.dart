import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ems_offbeat/utils/token_storage.dart';
import 'package:flutter_riverpod/legacy.dart';

final isReportingProvider = FutureProvider.autoDispose<bool>((ref) async {
  return await TokenStorage.getIsReporting();
});
