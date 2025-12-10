import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/car_provider.dart';
import 'screens/lock_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('🚗 Car App Starting...');
  runApp(const CarApp());
}

class CarApp extends StatelessWidget {
  const CarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final provider = CarProvider();
            provider.initialize(); // Initialize data on startup
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'SU7 Control',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(
            primary: Colors.teal,
            secondary: Colors.tealAccent,
            surface: Color(0xFF1E293B),
          ),
          textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
          useMaterial3: true,
        ),
        home: const LockScreen(),
      ),
    );
  }
}
