import 'package:flutter/material.dart';
import 'package:rootasjey/state/colors.dart';

class Newsletter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.02),
      padding: const EdgeInsets.all(60.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
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
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Your email address',
                border: OutlineInputBorder()
              ),
            ),
          ),

          RaisedButton(
            onPressed: () {},
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
      ),
    );
  }
}
