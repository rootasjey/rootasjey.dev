import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/actions/users.dart';
import 'package:rootasjey/components/footer.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final largeHorizPadding = 90.0;
  final narrowHorizPadding = 20.0;
  final narrowWidthLimit = 800.0;

  String email = '';
  String messageBody = '';
  String messageTitle = '';
  String subject = 'Website';
  String subjectHintPrefix = '';

  bool isLoading = false;
  bool isMessageSent = false;

  bool emailNeverEdited = true;
  bool titleNeverEdited = true;
  bool bodyNeverEdited = true;

  final formKey = GlobalKey<FormState>();

  final Map<String, String> errorMessages = {
    'emptyEmail':
        'The email field is empty. Please enter a valid email address.',
    'invalidEmail':
        'The value entered is not a valid email address. Please enter a valid one.',
    'emptyTitle':
        'Title cannot be empty. Enter a title with more than 3 characters.',
    'tooShortTitle': 'Please enter a title with more than 3 characters.',
    'emptyBody':
        'Body cannot be empty. Enter a body with more than 3 characters.',
    'tooShortBody': 'Please enter a body with more than 3 characters.',
  };

  @override
  initState() {
    super.initState();

    setState(() {
      subjectHintPrefix = 'Your message is about your ';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeAppBar(),
          SliverLayoutBuilder(
            builder: (_, constraints) {
              final padding = constraints.crossAxisExtent < narrowWidthLimit
                  ? narrowHorizPadding
                  : largeHorizPadding;

              return SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding,
                      vertical: 90.0,
                    ),
                    child: headerTitle(),
                  ),
                ]),
              );
            },
          ),
          SliverLayoutBuilder(
            builder: (_, constraints) {
              final padding = constraints.crossAxisExtent < narrowWidthLimit
                  ? narrowHorizPadding
                  : largeHorizPadding;

              return SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: padding,
                ),
                sliver: body(),
              );
            },
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              bottom: 300.0,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Footer(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget body() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          width: 400.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 20.0,
                    ),
                    child: Opacity(
                      opacity: 0.6,
                      child: Text(
                        'Send me an email',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => launch('work@rootasjey.dev'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'work@rootasjey.dev',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Opacity(
                            opacity: 0.6,
                            child: Icon(Icons.open_in_new),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 60.0,
                ),
                child: contactFormState(),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget contactFormState() {
    if (isLoading) {
      return progressForm();
    }

    if (isMessageSent) {
      return successForm();
    }

    return contactForm();
  }

  Widget contactForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: 0.8,
          child: Text(
            'OR use the form below 👇 ',
            style: TextStyle(
              fontSize: 20.0,
              color: stateColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
          ),
          child: Opacity(
            opacity: 0.5,
            child: Text(
              'No, your email will NOT be used to send you spam or shared',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        Container(
          width: 500.0,
          padding: const EdgeInsets.only(
            top: 60.0,
          ),
          child: Card(
            elevation: 4.0,
            color: stateColors.appBackground,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 60.0,
                right: 60.0,
                top: 60.0,
                bottom: 110.0,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    formHeader(),
                    formDrowndownType(),
                    formEmail(),
                    formTitle(),
                    formBody(),
                    validationButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget headerTitle() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        Text(
          'Contact me',
          style: TextStyle(
            fontSize: 70.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget formBody() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40.0,
        bottom: 40.0,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Message',
          icon: Icon(Icons.edit),
          border: OutlineInputBorder(),
          errorText: getBodyErrorText(),
        ),
        maxLines: null,
        minLines: 5,
        validator: (value) {
          if (value.isEmpty) {
            return errorMessages['emptyBoy'];
          }

          if (value.length < 3) {
            return errorMessages['tooShortBody'];
          }

          return null;
        },
        onChanged: (value) {
          bodyNeverEdited = false;

          setState(() {
            messageBody = value;
          });
        },
      ),
    );
  }

  Widget formDrowndownType() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 40.0,
        bottom: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            items: ['Website', 'Mobile app', 'Other thing'].map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: subject,
            onChanged: (value) {
              setState(() {
                subject = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
            ),
            child: Row(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Text(
                    subjectHintPrefix,
                  ),
                ),
                Text(
                  subject.toLowerCase(),
                  style: TextStyle(
                    color: stateColors.primary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget formEmail() {
    return TextFormField(
      autofocus: true,
      decoration: InputDecoration(
        labelText: 'Your email address',
        icon: Icon(Icons.alternate_email),
        errorText: getEmailErrorText(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value.isEmpty) {
          return errorMessages['emptyEmail'];
        }

        if (!UsersActions.checkEmailFormat(email)) {
          return errorMessages['invalidEmail'];
        }

        return null;
      },
      onChanged: (value) {
        emailNeverEdited = false;

        setState(() {
          email = value;
        });
      },
    );
  }

  Widget formHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 40.0,
      ),
      child: Opacity(
        opacity: 0.6,
        child: Text('Direct Message',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }

  Widget formTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30.0,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Title',
          icon: Icon(Icons.topic),
          errorText: getTitleErrorText(),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return errorMessages['emptyTitle'];
          }

          if (value.length < 3) {
            return errorMessages['tooShortTitle'];
          }

          return null;
        },
        onChanged: (value) {
          titleNeverEdited = false;

          setState(() {
            messageTitle = value;
          });
        },
      ),
    );
  }

  Widget progressForm() {
    return SizedBox(
      height: 100.0,
      child: Row(
        children: [
          CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
            ),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                'Sending your message...',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget successForm() {
    return Column(
      children: [
        Icon(
          Icons.check,
          size: 40.0,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
          ),
          child: Opacity(
            opacity: 0.8,
            child: Text(
              'Your message has successfully been sent',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
          ),
          child: Opacity(
            opacity: 0.6,
            child: Text(
              'You will receive an email response shortly',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: TextButton(
            onPressed: () => setState(() => isMessageSent = false),
            child: Text('Send another message?'),
          ),
        ),
      ],
    );
  }

  Widget validationButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30.0,
      ),
      child: ElevatedButton(
        onPressed: () {
          sendMessage();
        },
        style: ElevatedButton.styleFrom(
          primary: stateColors.primary,
          textStyle: TextStyle(
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 320.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('SEND',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Icon(Icons.send, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getEmailErrorText() {
    if (emailNeverEdited) {
      return null;
    }

    if (email.isEmpty) {
      return errorMessages['emptyEmail'];
    }

    if (!UsersActions.checkEmailFormat(email)) {
      return errorMessages['invalidEmail'];
    }

    return null;
  }

  String getTitleErrorText() {
    if (titleNeverEdited) {
      return null;
    }

    if (messageTitle.isEmpty) {
      return errorMessages['emptyTitle'];
    }

    if (messageTitle.length < 3) {
      return errorMessages['tooShortTitle'];
    }

    return null;
  }

  String getBodyErrorText() {
    if (bodyNeverEdited) {
      return null;
    }

    if (messageBody.isEmpty) {
      return errorMessages['emptyBody'];
    }

    if (messageBody.length < 3) {
      return errorMessages['tooShortBody'];
    }

    return null;
  }

  void sendMessage() async {
    if (!formKey.currentState.validate()) {
      Snack.e(
        context: context,
        message: "There are invalid field in the form. "
            "Please check all field and click send again.",
      );

      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'createdAt': Timestamp.now(),
        'email': email,
        'type': subject,
        'body': messageBody,
        'title': messageTitle,
        'isRead': false,
        'isAnwswered': false,
      });

      setState(() {
        isLoading = false;
        isMessageSent = true;
      });
    } catch (error) {
      debugPrint(error.toString());

      Snack.e(
        context: context,
        message: "Couldn't send your message. "
            "Please check your connection and try again.",
      );
    }
  }
}
