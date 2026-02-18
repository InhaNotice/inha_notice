import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void ensureTestBinding() {
  TestWidgetsFlutterBinding.ensureInitialized();
}

Future<SharedPreferences> seedMockPrefs(
  Map<String, Object> initialValues,
) async {
  SharedPreferences.setMockInitialValues(initialValues);
  return SharedPreferences.getInstance();
}

Future<void> resetMockPrefs() async {
  SharedPreferences.setMockInitialValues({});
  await SharedPreferences.getInstance();
}
