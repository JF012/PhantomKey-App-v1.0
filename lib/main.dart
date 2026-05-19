import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'providers/vault_provider.dart';
import 'screens/lock_screen.dart';
import 'screens/home_screen.dart';
import 'utils/constants.dart';

// ============================================================
// PHANTOMKEY - Punto de entrada principal
// Transiciones animadas entre temas y pantallas
// ============================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const PhantomKeyApp(),
    ),
  );
}

class PhantomKeyApp extends StatelessWidget {
  const PhantomKeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VaultProvider(),
      child: Consumer<VaultProvider>(
        builder: (context, vault, _) {
          return MaterialApp(
            title: 'PhantomKey',
            debugShowCheckedModeBanner: false,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            theme: ThemeData(
              brightness: vault.isDarkMode ? Brightness.dark : Brightness.light,
              scaffoldBackgroundColor: AppColors.background,
              primaryColor: AppColors.cyan,
              colorScheme: vault.isDarkMode
                  ? ColorScheme.dark(
                      primary: AppColors.cyan,
                      secondary: AppColors.violet,
                      surface: AppColors.surface,
                    )
                  : ColorScheme.light(
                      primary: AppColors.cyan,
                      secondary: AppColors.violet,
                      surface: AppColors.surface,
                    ),
              useMaterial3: true,
            ),
            // ---- ANIMACIÓN LOCK ↔ HOME (fade + escala sutil) ----
            home: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.94, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                    child: child,
                  ),
                );
              },
              child: vault.isUnlocked
                  ? const HomeScreen(key: ValueKey('home'))
                  : const LockScreen(key: ValueKey('lock')),
            ),
          );
        },
      ),
    );
  }
}
