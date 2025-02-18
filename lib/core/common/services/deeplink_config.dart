import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app_flutter/features/auth/presentation/pages/update_password_page.dart';

class DeeplinkConfig {
  ///
  /// Reset Password Deeplinking method
  static resetPasswordLinking(BuildContext context) {
    final appLinks = AppLinks();

    appLinks.uriLinkStream.listen(
      (uri) {
        ///
        if (uri.host == "reset_password") {
          Navigator.push (
            context,
            MaterialPageRoute(
              builder: (context) => const UpdatePasswordPage(),
            ),
          );
        }
      },
    );
  }
}
