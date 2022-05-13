import 'package:flutter/cupertino.dart' show BuildContext, ModalRoute;

extension PegaArgumento on BuildContext {
  T? pegaArgumento<T>() {
    final modalRota = ModalRoute.of(this);
    if (modalRota != null) {
      final args = modalRota.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  }
}
