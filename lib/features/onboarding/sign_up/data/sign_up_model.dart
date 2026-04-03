// -----------------------------------------------------------------------------
// sign_up_model.dart
// -----------------------------------------------------------------------------
// Firestore data model and mapper for the sign-up feature.
//
// This file is a skeleton. Sign-up currently only uses Firebase Auth — no
// Firestore documents are read or written at this stage. This file exists so
// the data layer is complete and ready for when a Firestore write is needed
// (e.g. creating an initial user profile document on successful registration).
//
// WHEN TO FILL THIS IN:
// If a sign-up step needs to write or read a Firestore document, define the
// model fields below and implement fromFirestore() and toFirestore().
// The repository method that performs the write should live in
// firebase_sign_up_repository.dart and use this model for the conversion.
//
// NOTE:
// Never import this file from domain or providers. It is data-layer only.
// The domain layer works with plain Dart types — this model is the translation
// layer between those types and Firestore's Map<String, dynamic> format.
// -----------------------------------------------------------------------------

// import 'package:cloud_firestore/cloud_firestore.dart';

// class SignUpModel {
//   // -------------------------------------------------------------------------
//   // Fields — mirror the Firestore document structure exactly.
//   // Use snake_case keys to match Firestore conventions.
//   // -------------------------------------------------------------------------
//
//   final String uid;
//   final String email;
//   final DateTime createdAt;
//
//   const SignUpModel({
//     required this.uid,
//     required this.email,
//     required this.createdAt,
//   });
//
//   // -------------------------------------------------------------------------
//   // fromFirestore — maps a Firestore document snapshot to this model.
//   // -------------------------------------------------------------------------
//   factory SignUpModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return SignUpModel(
//       uid: doc.id,
//       email: data['email'] as String,
//       createdAt: (data['created_at'] as Timestamp).toDate(),
//     );
//   }
//
//   // -------------------------------------------------------------------------
//   // toFirestore — maps this model to a Map for writing to Firestore.
//   // -------------------------------------------------------------------------
//   Map<String, dynamic> toFirestore() {
//     return {
//       'email': email,
//       'created_at': Timestamp.fromDate(createdAt),
//     };
//   }
// }