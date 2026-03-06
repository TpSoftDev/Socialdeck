class OpeningScreenState {
  final bool isLoading;
  final bool isAuthenticated;
  final String statusMessage;

  const OpeningScreenState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.statusMessage = 'Status: Not checked yet',
  });

  //Copy with method
  OpeningScreenState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? statusMessage,
  }) {
    return OpeningScreenState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      statusMessage: statusMessage ?? this.statusMessage,
    );
  }

  //Equals method
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is OpeningScreenState &&
            runtimeType == other.runtimeType &&
            isLoading == other.isLoading &&
            isAuthenticated == other.isAuthenticated &&
            statusMessage == other.statusMessage;
  }

  //Hash code method
  @override
  int get hashCode => Object.hash(isLoading, isAuthenticated, statusMessage);
}
