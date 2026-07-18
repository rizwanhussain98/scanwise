import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scanwise/res/string.dart';
import 'package:scanwise/services/navigation_service.dart';
import 'package:scanwise/utils/routes/routes.dart';
import 'package:scanwise/utils/routes/routes_name.dart';
import 'package:scanwise/view_model/login_view_model.dart';
import 'package:scanwise/view_model/signup_view_model.dart';
import 'package:scanwise/view_model/user_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OrtEnv.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LoginViewModel()),
            ChangeNotifierProvider(create: (_) => SignupViewModel()),
            ChangeNotifierProvider(create: (_) => UserViewModel()),
          ],
          child: MaterialApp(
            navigatorKey: NavigationService.navigatorKey,
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle.light,
              ),
            ),
            title: Strings.appTitle,
            debugShowCheckedModeBanner: false,
            initialRoute: RoutesNames.splashView,
            onGenerateRoute: Routes.generateRoute,
          ),
        );
      },
    );
  }
}
