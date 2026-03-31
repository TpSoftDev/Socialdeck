
import 'dart:async';

class IntroduceProfileCardState{
  final bool isTextVisible;
  final String displayText;
  final Timer? initialDelayTimer;
  final Timer? fadeOutTimer;

  //Constructor for needed fields
  const IntroduceProfileCardState({
    this.isTextVisible = true,
    this.displayText = "Hi there! I'm your profile card.",
    this.initialDelayTimer,
    this.fadeOutTimer,
  });

  IntroduceProfileCardState copyWith({
    bool? isTextVisible,
    String? displayText,
    Timer? initialDelayTimer,
    Timer? fadeOutTimer,
  }) {
    return IntroduceProfileCardState(
      isTextVisible: isTextVisible ?? this.isTextVisible,
      displayText: displayText ?? this.displayText,
      initialDelayTimer: initialDelayTimer ?? this.initialDelayTimer,
      fadeOutTimer: fadeOutTimer ?? this.fadeOutTimer,
    );
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is IntroduceProfileCardState &&
      isTextVisible == other.isTextVisible &&
      displayText == other.displayText &&
      initialDelayTimer == other.initialDelayTimer &&
      fadeOutTimer == other.fadeOutTimer;

  @override
  int get hashCode => Object.hash(
    isTextVisible,
    displayText,
    initialDelayTimer,
    fadeOutTimer,
    );

}