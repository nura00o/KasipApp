// import 'package:backend/api_client.dart';

import 'api_client.dart';

Future<void> syncUserWithBackend() async {
  await ApiClient.post("/api/auth/ensureUser", {});
}
