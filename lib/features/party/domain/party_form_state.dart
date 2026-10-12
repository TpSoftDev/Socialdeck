// -----------------------------------------------------------------------------
// party_form_state.dart
// Local inputs for create/join. Persistent membership lives in Firestore.
// -----------------------------------------------------------------------------
class PartyFormState {
  const PartyFormState({this.name = '', this.code = ''});
  final String name;
  final String code;
  bool get canCreate => name.trim().isNotEmpty && name.trim().length <= 24;
  bool get canJoin => canCreate && RegExp(r'^\d{6}$').hasMatch(code.trim());
  PartyFormState copyWith({String? name, String? code}) =>
      PartyFormState(name: name ?? this.name, code: code ?? this.code);
}
