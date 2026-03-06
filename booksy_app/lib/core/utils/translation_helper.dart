import 'package:booksy_app/core/utils/translation_helpers.dart' as helpers;

class TranslationHelper {
  static String translateCondition(String? condition) {
    return helpers.translateCondition(condition);
  }

  static String translateOperation(String? type) {
    return helpers.translateOperationType(type);
  }

  static String translateStatus(String? status) {
    return helpers.translateStatus(status);
  }
}
