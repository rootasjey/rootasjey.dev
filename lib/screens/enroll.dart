import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/actions/users.dart';
import 'package:rootasjey/components/features/additional_web.dart';
import 'package:rootasjey/components/features/web.dart';
import 'package:rootasjey/components/footer.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/components/outline_toggle_button.dart';
import 'package:rootasjey/router//router.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/enums.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:verbal_expressions/verbal_expressions.dart';
import 'package:supercharged/supercharged.dart';

class Enroll extends StatefulWidget {
  @override
  _EnrollState createState() => _EnrollState();
}

class _EnrollState extends State<Enroll> {
  bool isCheckingDomain = false;
  bool isCompleted      = false;
  bool isDomainFree     = false;
  bool isLoading        = false;
  bool meetInPerson     = false;

  DateTime selectedStartDate;
  DateTime selectedEndDate;

  double mainCost       = 0;
  double additionalCost = 0;

  final largeHorizPadding   = 90.0;
  final narrowHorizPadding  = 20.0;
  final narrowWidthLimit    = 800.0;

  int projectIndex      = 0;
  int totalSteps        = 0;
  int currentStep       = 0;

  List<Map<String, Object>> additionalSelectedFeatures = [];

  static const DOMAIN_NEW          = 'newdomain';
  static const DOMAIN_EXISTING     = 'existingdomain';
  static const DOMAIN_LOST         = 'lost';

  static const AFTER_PROJ_HANDLE   = 'handle';
  static const AFTER_PROJ_TRANSF   = 'transfert';

  static const PLATFORM_WEB        = 'web';
  static const PLATFORM_MOBILE     = 'mobile';
  // static const PLATFORM_WEB_MOBILE = 'webmobile';

  static const AUDIENCE_SMALL      = 'small';
  static const AUDIENCE_MEDIUM     = 'medium';
  static const AUDIENCE_LARGE      = 'large';
  static const AUDIENCE_UNKNOWN    = 'unknown';

  static const PROJECT_PORTFOLIO    = 'portfolio';
  static const PROJECT_BLOG         = 'blog';
  static const PROJECT_SHOWCASE     = 'showcase';
  static const PROJECT_ECOMMERCE    = 'ecommerce';
  static const PROJECT_MULTIPLE    = 'multiple';

  static const PAYMENT_ONETIME     = 'onetime';
  static const PAYMENT_DELAYED     = 'delayed';

  static const CONTACT_EMAIL       = 'email';
  static const CONTACT_PHONE       = 'phone';

  static const PLANNING_START      = 'start';
  static const PLANNING_END        = 'end';

  String afterProject     = AFTER_PROJ_HANDLE;
  String platform         = PLATFORM_WEB;
  String audienceSize     = AUDIENCE_SMALL;
  String projectType      = PROJECT_PORTFOLIO;
  String domainNameType   = DOMAIN_NEW;
  String domainName       = '';
  String domainErrorText;

  String planningMode = PLANNING_START;

  String callingCode      = '';
  String callingCodeErrorMessage;
  String country          = '';
  String city             = '';
  String countryErrorMessage;
  String cityErrorMessage;
  String paymentMethod    = PAYMENT_ONETIME;
  String contactType      = CONTACT_EMAIL;
  String email            = '';
  String emailErrorMessage;
  String phone            = '';
  String phoneErrorMessage;

  Timer domainCheckTimer;

  VerbalExpression regexDomain;
  VerbalExpression regexLocalPhone;
  VerbalExpression regexCallingCode;

  final Map<String, String> projectHint = {
    PROJECT_PORTFOLIO : "You want to display your work and projects. For example if you're an artist.",
    PROJECT_BLOG      : 'You want to write posts and stories about your favourites subjects. Like an online journal.',
    PROJECT_SHOWCASE  : 'You want an app with a few pages to showcase a business or something else, with a contact page. This can typically be a bakery website.',
    PROJECT_ECOMMERCE : 'You want to sell or monetize content or goods. This includes taking customer payments, a contact page and an increased security.',
    PROJECT_MULTIPLE  : 'Your app has multiple purposes.',
  };

  final Map<String, String> sizeHint = {
    AUDIENCE_SMALL   : "Less than 10,000 visitors per month",
    AUDIENCE_MEDIUM  : "Between 10,000 and 100,000 visitors per month",
    AUDIENCE_LARGE   : "More than 100,000 visitors per month",
    AUDIENCE_UNKNOWN : "Don't worry, we will determine this later together",
  };

  final Map<String, String> afterProjectHint = {
    AFTER_PROJ_HANDLE : "We will upgrade you app with the most recent technology and make security checks during the year.",
    AFTER_PROJ_TRANSF : "We will tranfert the whole project to you. You will have to care of the hosting, domain name among other things.",
  };

  @override
  void initState() {
    super.initState();

    mainCost = 500.0;

    regexDomain = VerbalExpression()
      ..startOfLine()
      ..word()
      ..then('.')
      ..word();

    regexCallingCode = VerbalExpression()
      ..startOfLine()
      ..range([Range('0', '9')])
      ..count(2)
      ..endOfLine();

    regexLocalPhone = VerbalExpression()
      ..startOfLine()
      ..maybe('0')
      ..beginCapture()
      ..range([Range('0', '9')])
      ..count(3)
      ..endCapture()
      ..count(3)
      ..endOfLine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isCompleted
        ? Padding(padding: EdgeInsets.zero)
        : FloatingActionButton.extended(
          onPressed: () => sendProject(),
          icon: Icon(Icons.send),
          label: Text(
            'Send application',
          ),
        ),
      body: CustomScrollView(
        slivers: [
          HomeAppBar(
            title: isCompleted
              ? null
              : Opacity(
                  opacity: 0.6,
                  child: Text(
                    'COST: ${mainCost + additionalCost} €',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: stateColors.foreground,
                    ),
                  ),
                ),
          ),

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
                    child: pageTitle(),
                  ),
                ]),
              );
            },
          ),

          SliverLayoutBuilder(
            builder: (_, constraints) {
              final padding = constraints.crossAxisExtent < narrowWidthLimit
                ? narrowHorizPadding
                : largeHorizPadding * 2;

              return SliverPadding(
                padding: EdgeInsets.only(
                  left: padding,
                  right: padding,
                  bottom: 300.0,
                ),
                sliver: body(),
              );
            },
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
    if (isLoading) {
      return loadingView();
    }

    if (isCompleted) {
      return completedView();
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            enrollSteps(),
          ],
        ),
      ]),
    );
  }

  Widget completedView() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 40.0,
                bottom: 20.0,
              ),
              child: Icon(Icons.done_outline, size: 80,),
            ),

            Opacity(
              opacity: 0.6,
              child: Text(
                "Your project has been successfully sent.\nWe'll review it and contact you in 48h.",
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            )
          ],
        ),
      ])
    );
  }

  Widget loadingView() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 40.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Opacity(
                      opacity: 0.6,
                      child: Icon(Icons.send, size: 80.0),
                    ),
                  ),

                  Opacity(
                    opacity: 0.6,
                    child: Text(
                      "Please wait while we're pack your project information into a condensed data and send it over the wire...",
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ])
    );
  }

  StepState computeStepState({
    int stepIndex,
    Function compute,
  }) {
    if (currentStep == stepIndex) {
      return StepState.editing;
    }

    if (compute != null) {
      StepState computed = compute();
      return computed;
    }

    return StepState.indexed;
  }

  Widget enrollSteps() {
    final stepper = Stepper(
      currentStep: currentStep,
      onStepContinue: next,
      onStepCancel: cancel,
      onStepTapped: (step) => goTo(step),
      steps: [
        Step(
          isActive: currentStep == 0,
          title: Text('Project'),
          subtitle: Text('Required'),
          content: dynamicStepContent(num: 0),
          state: computeStepState(
            stepIndex: 0,
          ),
        ),

        Step(
          isActive: currentStep == 1,
          title: Text('Platform'),
          subtitle: Text('Required'),
          content: dynamicStepContent(num: 1),
          state: computeStepState(
            stepIndex: 1,
          ),
        ),

        Step(
          isActive: currentStep == 2,
          title: Text('Size'),
          subtitle: Text('Required'),
          content: dynamicStepContent(num: 2),
          state: computeStepState(
            stepIndex: 2,
          ),
        ),

        Step(
          isActive: currentStep == 3,
          title: Text('Domain name'),
          subtitle: Text('Required'),
          content: dynamicStepContent(num: 3),
          state: computeStepState(
            stepIndex: 3,
          ),
        ),

        Step(
          isActive: currentStep == 4,
          title: Text('After project'),
          subtitle: Text('Required'),
          content: dynamicStepContent(num: 4),
          state: computeStepState(
            stepIndex: 4,
          ),
        ),

        Step(
          isActive: currentStep == 5,
          title: Text('Features'),
          subtitle: Text('Optional'),
          content: dynamicStepContent(num: 5),
          state: computeStepState(
            stepIndex: 5,
          ),
        ),

        Step(
          isActive: currentStep == 6,
          title: Text('Additional features'),
          subtitle: Text('Optional'),
          content: dynamicStepContent(num: 6),
          state: computeStepState(
            stepIndex: 6,
          ),
        ),

        Step(
          isActive: currentStep == 7,
          title: Text('Planning'),
          subtitle: Text('Required'),
          content: dynamicStepContent(num: 7),
          state: computeStepState(
            stepIndex: 7,
          ),
        ),

        Step(
          isActive: currentStep == 8,
          title: Text('Payment method'),
          subtitle: Text('Required'),
          content: dynamicStepContent(num: 8),
          state: computeStepState(
            stepIndex: 8,
          ),
        ),

        Step(
          isActive: currentStep == 9,
          title: Text('Contact'),
          subtitle: Text('Required'),
          content: dynamicStepContent(num: 9),
          state: computeStepState(
            stepIndex: 9,
          ),
        ),
      ],
    );

    totalSteps = stepper.steps.length;

    return stepper;
  }

  Widget dynamicStepContent({@required num}) {
    if (currentStep != num) {
      return Padding(
        padding: EdgeInsets.zero,
      );
    }

    switch (num) {
      case 0:
        return stepProject();
      case 1:
        return stepPlatform();
      case 2:
        return stepSize();
      case 3:
        return stepDomainName();
      case 4:
        return stepAfterProject();
      case 5:
        return stepFeatures();
      case 6:
        return stepAdditionalFeatures();
      case 7:
        return stepPlanning();
      case 8:
        return stepPaymentMethod();
      case 9:
        return stepContact();
      default:
        return Padding(
          padding: EdgeInsets.zero,
        );
    }
  }

  Widget stepAfterProject() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 40.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 20.0,
              ),
              child: Text(
                'Do you want us to handle the maintenance?',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),

            Wrap(
              spacing: 20.0,
              runSpacing: 20.0,
              children: [
                OutlineToggleButton(
                  child: Text('YES, HANDLE THIS FOR ME'),
                  onPressed: () => setState(() => afterProject = AFTER_PROJ_HANDLE),
                  selected: afterProject == AFTER_PROJ_HANDLE,
                ),

                OutlineToggleButton(
                  child: Text("NO, I WANT THE PROJECT TRANSFERED TO ME"),
                  onPressed: () => setState(() => afterProject = AFTER_PROJ_TRANSF),
                  selected: afterProject == AFTER_PROJ_TRANSF,
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(
                top: 40.0,
              ),
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  afterProjectHint[afterProject],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget stepFeatures() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 20.0,
            ),
            child: Text(
              'The following features are already included in your project:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),

          WebFeatures(
            layout: FeaturesLayout.wrap,
            padding: const EdgeInsets.only(
              top: 40.0,
              bottom: 40.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget stepAdditionalFeatures() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
              bottom: 20.0,
            ),
            child: Text(
              'Choose additional features for your project:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),

          WebAdditionalFeatures(
            onSelectionChanged: (double cost, List<Map<String, Object>> allSelected) {
              additionalSelectedFeatures = allSelected;
              setState(() => additionalCost = cost);
            },
          ),
        ],
      ),
    );
  }

  Widget stepContact() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
              bottom: 20.0,
            ),
            child: Text(
              'How can we contact you?',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),

          Wrap(
            spacing: 20.0,
            runSpacing: 20.0,
            children: [
              OutlineToggleButton(
                child: Text("Email"),
                selected: contactType == CONTACT_EMAIL,
                onPressed: () => setState(() => contactType = CONTACT_EMAIL),
              ),

              OutlineToggleButton(
                child: Text("Phone"),
                selected: contactType == CONTACT_PHONE,
                onPressed: () => setState(() => contactType = CONTACT_PHONE),
              ),
            ],
          ),

          contactTypeBody(),

          Container(
            padding: const EdgeInsets.only(top: 40.0),
            width: 400.0,
            child: CheckboxListTile(
              value: meetInPerson,
              onChanged: (value) => setState(() => meetInPerson = value),
              title: Opacity(opacity: 0.8, child: Text('Meet in person')),
              subtitle: Text("We can organize a meeting in a café"),
            ),
          ),

          contactLocation(),

          Padding(
            padding: const EdgeInsets.only(bottom: 40.0,),
          ),
        ],
      ),
    );
  }

  Widget contactTypeBody() {
    if (contactType == 'EMAIL') {
      return Container(
        width: 500.0,
        padding: const EdgeInsets.only(
          top: 40.0,
          left: 18.0,
        ),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: emailErrorMessage,
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            email = value;

            final isOk = checkEmailFormat(value);

            setState(() {
              emailErrorMessage = isOk
                ? null
                : "The value entered is not a valid email";
            });
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 40.0,
        left: 18.0,
      ),
      child: Wrap(
        spacing: 40.0,
        runSpacing: 10.0,
        children: [
          SizedBox(
            width: 150.0,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Country Indicator',
                errorText: emailErrorMessage,
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                callingCode = value;

                final isOk = regexCallingCode.hasMatch(value);

                setState(() {
                  callingCodeErrorMessage = isOk
                    ? null
                    : "The value entered is not a valid phone country indicator";
                });
              },
            ),
          ),

          SizedBox(
            width: 300.0,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Phone',
                errorText: emailErrorMessage,
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                phone = value;

                final isOk = regexLocalPhone.hasMatch(value);

                setState(() {
                  phoneErrorMessage = isOk
                    ? null
                    : "The value entered is not a phone number";
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget contactLocation() {
    if (!meetInPerson) {
      return Padding(padding: EdgeInsets.zero);
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 18.0,
      ),
      child: Wrap(
        spacing: 40.0,
        runSpacing: 20.0,
        children: [
          SizedBox(
            width: 200.0,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Country',
                errorText: countryErrorMessage,
              ),
              onChanged: (value) {
                country = value;

                setState(() {
                  countryErrorMessage = country.isEmpty
                    ? "Please enter your country"
                    : null;
                });
              },
            ),
          ),

          SizedBox(
            width: 200.0,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'City',
                errorText: cityErrorMessage,
              ),
              onChanged: (value) {
                city = value;

                setState(() {
                  cityErrorMessage = city.isEmpty
                    ? "Please enter your city"
                    : null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget stepPaymentMethod() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
              bottom: 20.0,
            ),
            child: Text(
              'How do you want to pay?',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),

          Wrap(
            spacing: 20.0,
            runSpacing: 20.0,
            children: [
              OutlineToggleButton(
                child: Text("One time fee"),
                selected: paymentMethod == PAYMENT_ONETIME,
                onPressed: () => setState(() => paymentMethod = PAYMENT_ONETIME),
              ),

              OutlineToggleButton(
                child: Text("Delayed"),
                selected: paymentMethod == PAYMENT_DELAYED,
                onPressed: () => setState(() => paymentMethod = PAYMENT_DELAYED),
              ),
            ],
          ),

          paymentMethodDescription(),
        ],
      ),
    );
  }

  Widget paymentMethodDescription() {
    if (paymentMethod == 'ONETIME') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 80.0,
            ),
            child: Wrap(
              spacing: 10.0,
              runSpacing: 20.0,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 40.0,
                  ),
                  child: Opacity(
                    opacity: 0.4,
                    child: Text(
                      'STARTING',
                      style: TextStyle(
                        fontSize: 80.0,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                ),

                Opacity(
                  opacity: 0.6,
                  child: Text(
                    '${mainCost / 2}',
                    style: TextStyle(
                      fontSize: 90.0,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                    ),
                  ),
                ),

                Opacity(
                  opacity: 0.6,
                  child: Text(
                    '€',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: 0.0,
              bottom: 40.0,
            ),
            child: Wrap(
              spacing: 10.0,
              runSpacing: 20.0,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10.0,
                  ),
                  child: Opacity(
                    opacity: 0.4,
                    child: Text(
                      'ENDING',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                ),

                Opacity(
                  opacity: 0.6,
                  child: Text(
                    '${mainCost / 2}',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w400,
                      // height: 1.0,
                    ),
                  ),
                ),

                Opacity(
                  opacity: 0.6,
                  child: Text(
                    '€',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
              bottom: 60.0,
            ),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                "You will pay the 1st half when it'll be validated by our team.\nAnd the 2nd half when it'll be finished.",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 80.0,
            ),
            child: Wrap(
              spacing: 10.0,
              runSpacing: 20.0,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Text(
                    '${(mainCost / 12).truncateToDouble()}',
                    style: TextStyle(
                      fontSize: 90.0,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                    ),
                  ),
                ),

                Opacity(
                  opacity: 0.6,
                  child: Text(
                    '€ / month',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
              bottom: 60.0,
            ),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                "You will pay the recurring fee during 1 year.",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      );
  }

  Widget stepPlanning() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
              bottom: 20.0,
            ),
            child: Text(
              'What is your time frame?',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),

          Wrap(
            spacing: 20.0,
            runSpacing: 20.0,
            children: [
              OutlineToggleButton(
                child: Text("I'd like to start on..."),
                selected: planningMode == PLANNING_START,
                onPressed: () => setState(() => planningMode = PLANNING_START),
              ),

              OutlineToggleButton(
                child: Text("I'd like the result on..."),
                selected: planningMode == PLANNING_END,
                onPressed: () => setState(() => planningMode = PLANNING_END),
              ),
            ],
          ),

          dateButtonSelector(),
        ],
      ),
    );
  }

  Widget dateButtonSelector() {
    String textDate = "SELECT A DATE";

    if (planningMode == PLANNING_START && selectedStartDate != null) {
      textDate = selectedStartDate
        .toLocal()
        .toString()
        .split(' ')[0];
    }

    if (planningMode == PLANNING_END && selectedEndDate != null) {
      textDate = selectedEndDate
        .toLocal()
        .toString()
        .split(' ')[0];
    }

    DateTime initialDate;

    if (planningMode == PLANNING_START) {
      initialDate = selectedStartDate ?? DateTime.now();

    } else if (planningMode == PLANNING_END) {
      initialDate = selectedEndDate ?? DateTime.now();

    } else {
      initialDate = DateTime.now();
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 40.0,
        bottom: 40.0,
      ),
      child: FlatButton.icon(
        onPressed: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year + 4),
          );

          if (planningMode == PLANNING_START) {
            if (picked == null || picked == selectedStartDate) {
              return;
            }

            setState(() => selectedStartDate = picked);
          }

          if (planningMode == PLANNING_END) {
            if (picked == null || picked == selectedEndDate) {
              return;
            }

            setState(() => selectedEndDate = picked);
          }
        },
        icon: Icon(Icons.touch_app),
        label: Opacity(
          opacity: 1.0,
          child: Text(
            textDate,
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      ),
    );
  }

  Widget stepPlatform() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 40.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 20.0,
              ),
              child: Text(
                'On which platform you want to build your app?',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),

            Wrap(
              spacing: 20.0,
              runSpacing: 20.0,
              children: [
                OutlineToggleButton(
                  child: Text('WEB'),
                  onPressed: () => setState(() => platform = PLATFORM_WEB),
                  selected: platform == PLATFORM_WEB,
                ),

                OutlineToggleButton(
                  child: Text('OTHER PLATFORMS AVAILABLE SOON'),
                  // onTap: () => setState(() => projectType = 'WEB'),
                  selected: platform == PLATFORM_MOBILE,
                ),

                // headerButton(
                //   label: 'WEB + MOBILE',
                //   onTap: () => setState(() => projectType = 'WEB'),
                //   selected: projectType == 'WEB',
                // ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(
                top: 40.0,
              ),
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  'We will create a website globally available for you.',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget stepProject() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 40.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 20.0,
              ),
              child: Text(
                'What type of app do you want?',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),

            Wrap(
              spacing: 20.0,
              runSpacing: 20.0,
              children: [
                OutlineToggleButton(
                  child: Text('PORTFOLIO'),
                  onPressed: () => setState(() => projectType = PROJECT_PORTFOLIO),
                  selected: projectType == PROJECT_PORTFOLIO,
                ),

                OutlineToggleButton(
                  child: Text("BLOG"),
                  onPressed: () => setState(() => projectType = PROJECT_BLOG),
                  selected: projectType == PROJECT_BLOG,
                ),

                OutlineToggleButton(
                  child: Text('SHOWCASE'),
                  onPressed: () => setState(() => projectType = PROJECT_SHOWCASE),
                  selected: projectType == PROJECT_SHOWCASE,
                ),

                OutlineToggleButton(
                  child: Text('E-COMMERCE'),
                  onPressed: () => setState(() => projectType = PROJECT_ECOMMERCE),
                  selected: projectType == PROJECT_ECOMMERCE,
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(
                top: 40.0,
              ),
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  projectHint[projectType],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget stepDomainName() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 40.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10.0,
              ),
              child: Text(
                'Which domain name would you like to use?',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 40.0,
              ),
              child: Opacity(
                opacity: 0.8,
                child: Text(
                  "The domain name represents your website address. Make sure the address you want is available with the input below 👇",
                  style: TextStyle(
                    fontSize: 18.0,
                    height: 1.3,
                  ),
                ),
              ),
            ),

            Wrap(
              spacing: 20.0,
              runSpacing: 20.0,
              children: [
                OutlineToggleButton(
                  child: Text('FIND A NEW DOMAIN NAME'),
                  onPressed: () => setState(() => domainNameType = DOMAIN_NEW),
                  selected: domainNameType == DOMAIN_NEW,
                ),

                OutlineToggleButton(
                  child: Text('I ALREADY HAVE A DOMAIN NAME'),
                  onPressed: () => setState(() => domainNameType = DOMAIN_EXISTING),
                  selected: domainNameType == DOMAIN_EXISTING,
                ),

                OutlineToggleButton.icon(
                  icon: Icon(Icons.directions_off),
                  label: Text("I'M LOST!"),
                  onPressed: () => setState(() => domainNameType = DOMAIN_LOST),
                  selected: domainNameType == DOMAIN_LOST,
                ),
              ],
            ),

            domainBody(),
          ],
        ),
      ),
    );
  }

  Widget domainBody() {
    if (domainNameType == DOMAIN_NEW) {
      return domainNameInput();
    }

    if (domainNameType == DOMAIN_EXISTING) {
      return existingDomainText();
    }

    return iAmLostText();
  }

  Widget domainNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 40.0,
            bottom: 20,
          ),
          child: LayoutBuilder(
            builder: (_, constraints) {
              final width = constraints.maxWidth < 600.0
                ? 340.0
                : 600.0;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: width,
                    height: 50.0,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'ontheshells.xyz',
                        errorText: domainErrorText,
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.search),
                        suffixIcon: isDomainFree
                          ? Icon(Icons.check_circle)
                          : null,
                      ),
                      onChanged: (value) {
                        domainName = value;

                        if (domainCheckTimer != null) {
                          domainCheckTimer.cancel();
                          domainCheckTimer = null;
                        }

                        domainCheckTimer = Timer(
                          1.seconds,
                          () => checkDomainName());
                      },
                    ),
                  ),

                  if (isCheckingDomain)
                    Container(
                      height: 30.0,
                      width: 30.0,
                      child: CircularProgressIndicator(),
                    ),
                ],
              );
            }
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Opacity(
            opacity: 0.6,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.help),
                ),

                Expanded(
                  child: Text(
                    'We may need additional verifications to ensure this domain is available.'
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget existingDomainText() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40.0,
      ),
      child: Opacity(
        opacity: 0.6,
        child: Text(
          "Great! We will set your domain with you later. After the project is started.",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  Widget iAmLostText() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40.0,
      ),
      child: Opacity(
        opacity: 0.6,
        child: Text(
          "Dont worry. We'll handle this part with no additional cost. And explain everything to you later.",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  Widget stepSize() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 40.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 20.0,
              ),
              child: Text(
                'What size of audience do you aim for?',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),

            Wrap(
              spacing: 20.0,
              runSpacing: 20.0,
              children: [
                OutlineToggleButton(
                  child: Text('SMALL'),
                  onPressed: () => setState(() => audienceSize = AUDIENCE_SMALL),
                  selected: audienceSize == AUDIENCE_SMALL,
                ),

                OutlineToggleButton(
                  child: Text('MEDIUM'),
                  onPressed: () => setState(() => audienceSize = AUDIENCE_MEDIUM),
                  selected: audienceSize == AUDIENCE_MEDIUM,
                ),

                OutlineToggleButton(
                  child: Text('LARGE'),
                  onPressed: () => setState(() => audienceSize = AUDIENCE_LARGE),
                  selected: audienceSize == AUDIENCE_LARGE,
                ),

                OutlineToggleButton(
                  child: Text("I DON'T KNOW"),
                  onPressed: () => setState(() => audienceSize = AUDIENCE_UNKNOWN),
                  selected: audienceSize == AUDIENCE_UNKNOWN,
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(
                top: 40.0,
              ),
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  sizeHint[audienceSize],
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  'This will determine how the additional fees for data usage.',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pageTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 16.0,
            top: 20.0,
          ),
          child: IconButton(
            onPressed: () => FluroRouter.router.pop(context),
            icon: Icon(Icons.arrow_back),
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      'Enroll',
                      style: TextStyle(
                        fontSize: 70.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  if (isLoading)
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),

              SizedBox(
                width: 600.0,
                child: Opacity(
                  opacity: 0.6,
                  child: Text(
                    "This is the start process.\nYou won't be charged until we validate your project.",
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
      return;
    }

    Navigator.pop(context);
  }

  void goTo(int step) {
    setState(() => currentStep = step);
  }

  void next() {
    currentStep + 1 < totalSteps
      ? goTo(currentStep + 1)
      : sendProject();
  }

  void checkDomainName() async {
    if (!regexDomain.hasMatch(domainName)) {
      domainErrorText = 'The value entered is not in domain format. A valid value would be: supernova.com';
      setState(() {});
      return;
    }

    setState(() => isCheckingDomain = true);

    try {
      final callable = CloudFunctions(
        app: Firebase.app(),
        region: 'europe-west3',
      ).getHttpsCallable(
        functionName: 'enroll-domainCheck',
      );

      final resp = await callable.call({'domain': domainName});

      setState(() {
        isDomainFree = resp.data['isFree'] as bool;

        domainErrorText = isDomainFree
          ? null
          : 'This domain is already taken. Please choose another one.';
      });

      setState(() => isCheckingDomain = false);

    } catch (error) {
      debugPrint(error.toString());

      setState(() {
        isDomainFree = false;
        isCheckingDomain = false;
      });
    }
  }

  bool areRequiredFieldsFilled() {
    if (selectedStartDate == null && selectedEndDate == null) {
      showSnack(
        context: context,
        message: "Please select a start or an end date for your project.",
        type: SnackType.error,
      );

      return false;
    }

    if ((email == null || email.isEmpty) && (phone == null || phone.isEmpty)) {
      showSnack(
        context: context,
        message: "Please fill a way to contact you. Either your email or your phone number.",
        type: SnackType.error,
      );

      return false;
    }

    if (meetInPerson && (country == null || country.isEmpty || city == null || city.isEmpty)) {
      showSnack(
        context: context,
        message: "Please fill your country and your city names if you want to meet us.",
        type: SnackType.error,
      );

      return false;
    }

    return true;
  }

  void sendProject() async {
    if (!areRequiredFieldsFilled()) {
      return;
    }

    setState(() {
      isCompleted = false;
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
        .collection('missions')
        .add({
          'additionalFeatures': additionalSelectedFeatures,
          'contact': {
            'type': contactType,
            'email': email,
            'phone': phone,
            'country': country,
            'city': city,
          },
          'cost': mainCost + additionalCost,
          'createdAt': DateTime.now(),
          'domain': {
            'type': domainNameType,
            'name': domainName,
          },
          'payment': {
            'method': paymentMethod,
          },
          'planning': {
            'mode': planningMode,
            'start': selectedStartDate,
            'end': selectedEndDate,
          },
          'project': {
            'type': projectType,
            'platform': platform,
            'size': audienceSize,
            'after': afterProject,
          },
          'review': {
            'updatedAt': DateTime.now(),
            'comment': '',
            'accepted': false,
          },
          'updatedAt': DateTime.now(),
        });

      setState(() {
        isCompleted = true;
        isLoading = false;
      });

    } catch (error) {
      debugPrint(error.toString());

      setState(() {
        isCompleted = false;
        isLoading = false;
      });
    }
  }
}
