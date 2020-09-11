import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/actions/users.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/snack.dart';

class Newsletter extends StatefulWidget {
  @override
  _NewsletterState createState() => _NewsletterState();
}

bool _isSubscribed = false;

class _NewsletterState extends State<Newsletter> {
  bool isLoading = false;

  String email = '';
  String errorText;

  final newsreaderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.02),
      padding: const EdgeInsets.all(60.0),
      child: body(),
    );
  }

  Widget body() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_isSubscribed) {
      return completedView();
    }

    return idleView();
  }

  Widget idleView() {
    return Column(
      children: [
        Icon(
          Icons.email_outlined,
          size: 80.0,
        ),

        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            bottom: 8.0,
          ),
          child: Text(
            'Subscribe to my newsletter',
            style: TextStyle(
              fontSize: 40.0,
            ),
          ),
        ),

        Opacity(
          opacity: 0.6,
          child: Text(
            'Get the latest posts in your inbox (~once per month).',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),

        Container(
          width: 500.0,
          padding: const EdgeInsets.only(
            top: 60.0,
            bottom: 40.0,
          ),
          child: TextFormField(
            controller: newsreaderController,
            decoration: InputDecoration(
              labelText: 'Your email address',
              border: OutlineInputBorder(),
              errorText: errorText,
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              email = value;

              final isWellFormatted = checkEmailFormat(email);
              errorText = isWellFormatted
                ? null
                : 'The value entered is not a valid email address';

              setState(() {});
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Email cannot be empty';
              }

              final isWellFormatted = checkEmailFormat(email);
              if (!isWellFormatted) { return 'The value entered is not a valid email address'; }

              return null;
            },
          ),
        ),

        RaisedButton(
          onPressed: subscribe,
          color: stateColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 16.0,
          ),
          child: SizedBox(
            width: 200.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SUBSCRIBE',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget completedView() {
    return Column(
      children: [
        Icon(
          Icons.favorite,
          color: Colors.pink,
          size: 80.0,
        ),

        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            bottom: 8.0,
          ),
          child: Text(
            'Thank you!',
            style: TextStyle(
              fontSize: 40.0,
            ),
          ),
        ),

        Opacity(
          opacity: 0.6,
          child: Text(
            'Thank you for subscribing to the newsletter. See you soon 👋',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextButton(
            onPressed: () => setState(() => _isSubscribed = false),
            child: Text('Use another email'),
          ),
        ),
      ],
    );
  }

  void subscribe() async {
    final isWellFormatted = checkEmailFormat(email);

    if (!isWellFormatted) {
      showSnack(
        context: context,
        message: 'The value entered is not a valid email address',
        type: SnackType.error,
      );

      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance
        .collection('newsreaders')
        .doc()
        .set({
          'email': email,
          'categories': {
            'all': true,
          },
          'rng': Random().nextInt(100000),
          'seed': Random().nextInt(100000),
        });

      setState(() {
        isLoading = false;
        _isSubscribed = true;
      });

    } catch (error) {
      debugPrint(error.toString());
      setState(() => isLoading = false);
    }
  }
}
