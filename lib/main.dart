// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:counter/models/task.dart';
import 'package:counter/providers/task_provider.dart';
import 'package:counter/screens/home_screen.dart';
import 'package:counter/utils/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(RecurrenceFrequencyAdapter());
  Hive.registerAdapter(TaskAdapter());

  await Hive.openBox<Task>(AppConstants.taskBoxName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TaskProvider())],
      child: MaterialApp(
        title: 'Task Tracker App',
        debugShowCheckedModeBanner: false, // Set to false for production
        theme: ThemeData(
          // Define your appealing colors
          primarySwatch: Colors.blue, // Provides shades of blue
          primaryColor: const Color(
            0xFF2196F3,
          ), // Deep Blue (Material Blue 500)
          hintColor: const Color(
            0xFF00BCD4,
          ), // Teal (Material Cyan 500) for accents
          scaffoldBackgroundColor: const Color(
            0xFFF5F5F5,
          ), // Light grey background
          // App Bar Theme
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2196F3), // Primary color for app bar
            foregroundColor: Colors.white, // White text/icons on app bar
            elevation: 4.0, // Subtle shadow for app bar
            titleTextStyle: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),

          // Text Theme
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
            headlineMedium: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
            titleLarge: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
            bodyLarge: TextStyle(fontSize: 16.0, color: Color(0xFF555555)),
            bodyMedium: TextStyle(fontSize: 14.0, color: Color(0xFF777777)),
            labelLarge: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),

          // Elevated Button Theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(
                0xFF2196F3,
              ), // Primary color for buttons
              foregroundColor: Colors.white, // White text on buttons
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8.0,
                ), // Slightly rounded corners
              ),
              elevation: 3.0, // Subtle button shadow
              textStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Floating Action Button Theme
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF00BCD4), // Accent color for FAB
            foregroundColor: Colors.white,
            elevation: 6.0,
          ),

          // Card Theme
          cardTheme: CardTheme(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 2.0, // Subtle shadow for cards
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12.0,
              ), // Rounded corners for cards
            ),
          ),

          // Input Decoration Theme (for TextFormFields)
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  BorderSide
                      .none, // No border by default, use enabledBorder etc.
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Color(0xFF2196F3),
                width: 2.0,
              ), // Primary color on focus
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.red, width: 2.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.red, width: 2.0),
            ),
            labelStyle: const TextStyle(color: Color(0xFF555555)),
            hintStyle: const TextStyle(color: Color(0xFFBBBBBB)),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
