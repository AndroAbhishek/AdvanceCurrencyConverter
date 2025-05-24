import 'package:advance_currency_convertor/core/constants/text_constants.dart';
import 'package:advance_currency_convertor/core/theme/color_pallete.dart';
import 'package:advance_currency_convertor/core/theme/theme.dart';
import 'package:advance_currency_convertor/core/utils.dart';
import 'package:advance_currency_convertor/core/widgets/custom_app_bar.dart';
import 'package:advance_currency_convertor/core/widgets/custom_icon.dart';
import 'package:advance_currency_convertor/features/currency_list/view/pages/currency_listing_screen.dart';
import 'package:advance_currency_convertor/features/feature_setting/view/pages/currency_settings.dart';
import 'package:advance_currency_convertor/features/currency/view/pages/currency_page.dart';
import 'package:advance_currency_convertor/service_locator_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependecies();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: TextConstants.appName,
      theme: AppTheme.darkThemeMode,
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    CurrenciesListScreen(),
    CurrencyPage(),
    CurrencySettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: titles[_selectedIndex]),
      body: _screens[_selectedIndex],
      bottomNavigationBar: MoltenBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        domeHeight: 15,
        barHeight: 80,
        duration: const Duration(milliseconds: 300),
        domeCircleColor: Pallete.greenColor,
        barColor: Pallete.whiteColor,
        tabs: [
          MoltenTab(icon: CustomIcon(icon: Icons.list_sharp)),
          MoltenTab(icon: CustomIcon(icon: Icons.currency_exchange_outlined)),
          MoltenTab(icon: CustomIcon(icon: Icons.settings)),
        ],
      ),
    );
  }
}
