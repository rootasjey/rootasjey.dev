/// Enumerated signal ids.
/// These are unique to listen to specific changes.
enum EnumSignalId {
  /// Upload window signal id.
  showUploadWindow,

  /// Upload task list signal id.
  /// Used to listen to changes in upload tasks.
  uploadTaskList,

  /// Upload bytes transferred signal id.
  /// Used to listen to changes in upload bytes transferred.
  uploadBytesTransferred,

  /// Firebase auth signal id.
  /// Used to listen to changes in firebase authentication.
  userAuth,

  /// Firestore signal id.
  /// Used to listen to changes in firestore.
  userFirestore,
}
