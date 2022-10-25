import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/components/better_avatar.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/types/alias/json_alias.dart';
import 'package:rootasjey/types/user/user_firestore.dart';

/// A component showing user's avatar, name, and location.
/// Tapping on the avatar will redirect to user's profile page.
class AuthorComponent extends StatefulWidget {
  const AuthorComponent({
    Key? key,
    required this.userId,
    this.padding = EdgeInsets.zero,
    this.simpleMode = true,
  }) : super(key: key);

  final String userId;
  final EdgeInsets padding;
  final bool simpleMode;

  @override
  State<AuthorComponent> createState() => _AuthorComponentState();
}

class _AuthorComponentState extends State<AuthorComponent> with UiLoggy {
  UserFirestore _user = UserFirestore.empty();

  @override
  void initState() {
    super.initState();
    fetchAuthor();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.simpleMode) {
      return Opacity(
        opacity: 0.6,
        child: Text(
          _user.name,
          style: Utilities.fonts.body2(
            textStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return authorWithAvatar();
  }

  Widget authorWithAvatar() {
    final profilePicture = _user.getProfilePicture();

    final avatarUrl = profilePicture.isNotEmpty
        ? profilePicture
        : "https://img.icons8.com/plasticine/100/000000/flower.png";

    return Padding(
      padding: widget.padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(
            tag: 'pp',
            child: BetterAvatar(
              size: 60.0,
              image: NetworkImage(avatarUrl),
              colorFilter: const ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
              onTap: goToUserProfile,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(
                  opacity: 0.8,
                  child: Text(
                    _user.name,
                    style: Utilities.fonts.body(
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.4,
                  child: Text(
                    _user.location,
                    style: Utilities.fonts.body(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Fetch author from Firestore doc public data (fast).
  void fetchAuthor() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection("user_public_fields")
          .doc("base")
          .get();

      final Json? data = snapshot.data();

      if (!snapshot.exists || data == null) {
        return;
      }

      setState(() {
        data["id"] = widget.userId;
        _user = UserFirestore.fromMap(data);
      });
    } catch (error) {
      loggy.error(error);
    }
  }

  void goToUserProfile() {
    // Beamer.of(context).beamToNamed(
    //   HomeLocation.profileRoute.replaceFirst(":userId", widget.userId),
    //   data: {"userId": widget.userId},
    // );
  }
}
