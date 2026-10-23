import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:thingsboard_app/constants/assets_path.dart';
import 'package:thingsboard_app/widgets/tb_progress_indicator.dart';

/// What the app shows while it starts (checks the session, loads the user).
///
/// Drawn in the app's own look (the last light / dark mode the iMEX pages showed), so the
/// native splash, which can only ever be white, is handed over as soon as Flutter can draw.
class ImexStartupScreen extends StatefulWidget {
  const ImexStartupScreen({super.key, this.showProgress = true});

  final bool showProgress;

  @override
  State<ImexStartupScreen> createState() => _ImexStartupScreenState();
}

class _ImexStartupScreenState extends State<ImexStartupScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => FlutterNativeSplash.remove(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(ThingsboardImage.thingsboardCenter, height: 96),
            const SizedBox(height: 40),
            SizedBox(
              height: 32,
              child: widget.showProgress
                  ? const TbProgressIndicator(size: 32)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
