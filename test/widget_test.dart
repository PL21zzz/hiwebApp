import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hiweb_app_management/main.dart';
import 'package:hiweb_app_management/screens/main_navigation_screen.dart';
import 'package:hiweb_app_management/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    AuthService.instance.logout();
  });

  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VietMadeApp());
    expect(find.byType(VietMadeApp), findsOneWidget);
  });

  testWidgets('Account access when logged out opens login without main bottom nav',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainNavigationScreen(initialIndex: 4),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MainNavigationScreen), findsNothing);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsNothing);
  });
}
