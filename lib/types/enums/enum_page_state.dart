/// Different page's states.
enum EnumPageState {
  /// Check if the username is available.
  checkingUsername,

  /// Check if the email is available.
  checkingEmail,

  /// Creating a new account.
  creatingAccount,

  /// An action has been completed.
  done,

  /// Loading data.
  loading,

  /// Loading more data.
  loadingMore,

  /// Waiting for user input.
  idle,

  /// An error occurred on data laod or after a user input.
  error,

  /// Looking for data results according of the user input.
  searching,

  /// Looking for more data results according of the user input.
  searchingMore,
}
