import 'package:ease_annotation/ease_annotation.dart';
import 'package:ease_state_helper/ease_state_helper.dart';
import 'package:flutter/widgets.dart';

part 'form_state.ease.dart';

/// Form data for testing local providers.
class FormData {
  final String field1;
  final String field2;
  final bool isValid;

  const FormData({
    this.field1 = '',
    this.field2 = '',
    this.isValid = false,
  });

  FormData copyWith({String? field1, String? field2, bool? isValid}) {
    return FormData(
      field1: field1 ?? this.field1,
      field2: field2 ?? this.field2,
      isValid: isValid ?? this.isValid,
    );
  }
}

/// Local form state - should NOT appear in ease.g.dart.
@Ease(local: true)
class FormState extends StateNotifier<FormData> {
  FormState() : super(const FormData());

  void updateField1(String value) {
    state = state.copyWith(field1: value, isValid: _validate());
  }

  void updateField2(String value) {
    state = state.copyWith(field2: value, isValid: _validate());
  }

  bool _validate() {
    return state.field1.isNotEmpty && state.field2.isNotEmpty;
  }

  void reset() => state = const FormData();
}
