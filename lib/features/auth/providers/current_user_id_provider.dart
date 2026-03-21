import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';

final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(currentUserProvider)?.uid;
});
