
import 'dart:async';

class IntroduceProfileCardState{
  final bool isTextVisible;
  final bool moveNext;
  final String displayText;
  final Timer? initialDelayTimer;
  final Timer? fadeOutTimer;
  final Timer? routingTimer;

  //Constructor for needed fields
  const IntroduceProfileCardState({
    this.isTextVisible = true,
    this.moveNext = false,
    this.displayText = "Hi there! I'm your profile card.",
    this.initialDelayTimer,
    this.fadeOutTimer,
    this.routingTimer,
  });

  IntroduceProfileCardState copyWith({
    bool? isTextVisible,
    bool? moveNext,
    String? displayText,
    Timer? initialDelayTimer,
    Timer? fadeOutTimer,
    Timer? routingTimer,
  }) {
    return IntroduceProfileCardState(
      isTextVisible: isTextVisible ?? this.isTextVisible,
      moveNext: moveNext ?? this.moveNext,
      displayText: displayText ?? this.displayText,
      initialDelayTimer: initialDelayTimer ?? this.initialDelayTimer,
      fadeOutTimer: fadeOutTimer ?? this.fadeOutTimer,
      routingTimer: routingTimer ?? this.routingTimer,
    );
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is IntroduceProfileCardState &&
      isTextVisible == other.isTextVisible &&
      moveNext == other.moveNext &&
      displayText == other.displayText &&
      initialDelayTimer == other.initialDelayTimer &&
      fadeOutTimer == other.fadeOutTimer &&
      routingTimer == other.routingTimer;

  @override
  int get hashCode => Object.hash(
    isTextVisible,
    moveNext,
    displayText,
    initialDelayTimer,
    fadeOutTimer,
    routingTimer,
    );

}