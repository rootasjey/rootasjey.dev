import 'package:flutter/material.dart';
import 'package:rootasjey/components/footer.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/rooter/router.dart';
import 'package:rootasjey/state/colors.dart';

class Pricing extends StatefulWidget {
  @override
  _PricingState createState() => _PricingState();
}

class _PricingState extends State<Pricing> {
  bool isLoading = false;
  final orangeColor = Color(0xFFF39C12);
  int projectIndex = 0;

  int expandedIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          enroll();
        },
        backgroundColor: stateColors.primary,
        foregroundColor: Colors.white,
        icon: Icon(Icons.payment),
        label: Text(
          'Enroll',
        ),
      ),
      body: CustomScrollView(
        slivers: [
          HomeAppBar(),

          SliverList(
            delegate: SliverChildListDelegate([
              headerTitle(),
            ]),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 90.0,
            ),
            sliver: body(),
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
        Padding(
          padding: const EdgeInsets.only(
            left: 90.0,
            bottom: 300.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerButtonsRow(),
              priceTag(),
              priceDescription(),
              features(),
              faq(),
            ],
          ),
        ),
      ]),
    );
  }

  Widget faq() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 88.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 20.0,
            ),
            child: Text(
              'FAQ',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          ExpansionPanelList(
            expansionCallback: (index, isExpanded) {
              setState(() {
                expandedIndex = expandedIndex != index
                  ? index
                  : -1;
              });
            },
            children: [
              faqExpPanel(
                index: 0,
                title: 'Why is the price so high?',
                description: "This is a personalized service where we'll craft the exact website you need. Also making an efficient website takes time and can be painful.",
              ),

              faqExpPanel(
                index: 1,
                title: 'I can get more from Wix or X service...',
                description: "Yes but with these platforms you'll pay a higher price per month. So, if you want a website for a short period of time, these platforms are okay. But if you plan to keep your website for a long time (>6 months), you'll pay less using our service.",
              ),

              faqExpPanel(
                index: 2,
                title: 'Why do I have to pay annual fees?',
                description: "We'll charge you 45€ for the domain name which is usually between 10 ~ 50€. We'll proceed to annual security checks and patch vunerabilities. Your website will be upgraded to the latest technologies. And you'll get one 30% cut for an additional annual feature.",
              ),

              faqExpPanel(
                index: 3,
                title: 'How do you charge for data plan?',
                description: "We only charge for what you use, and it depends of the services you choose, but you'll get a generous free plan. We use Firebase to host your website and your data which offers granular data plans. A detailed table will be available soon. In the meantime, you can contact us for more information.",
              ),

              faqExpPanel(
                index: 4,
                title: 'Is my data plan unlimited?',
                description: "No, it's not unlimited but you've got a fairly good data plan for a small to medium website. We will contact and may charge you if you exceed your data plan by more than 20€. Unless you've millions of customers, you should be fine.",
              ),

              faqExpPanel(
                index: 5,
                title: "I don't want to pay annual fees. Just the one time fee please.",
                description: "You don't need to. We can transfert the website to you, so you pay no additional fee. Keep in mind that you'll have to pay for your domain name (e.g. GoDaddy). Plus you may pay for Firebase usage if your website attract a lot of customers.",
              ),

              faqExpPanel(
                index: 6,
                title: "Can I ask for modifications during the development?",
                description: "Yes, you can. At the start, we agree of all the features you need. If you need more features, we may charge you additional cost.",
              ),

              faqExpPanel(
                index: 7,
                title: "Can I have a refund?",
                description: "When we take a mission, we charge 50% upfront. Then you'll have 5 days to cancel the project but we'll retain 25% fees. After those 5 days, you cannot retrieve the 50% fees. However, you can decide to stop the project and not pay the last 50%.",
              ),

              faqExpPanel(
                index: 8,
                title: "Which payment do you take?",
                description: "You can use your credit card, Visa, Mastercard or Paypal.",
              ),

              faqExpPanel(
                index: 9,
                title: "Do you do a discount for schools, students or non-profit?",
                description: "Yes. We do up to 50% discount. Contact us for more information.",
              ),

              faqExpPanel(
                index: 10,
                title: "What if I can't pay the whole fee at once?",
                description: "We can exceptionally allow you to pay each month. Contact us for more information.",
              ),

              faqExpPanel(
                index: 11,
                title: "What if there's a bug?",
                description: "We will fix any bug in your website for free.",
              ),

              faqExpPanel(
                index: 12,
                title: "What if I don't have a design yet?",
                description: "We'll charge 1000€ for the design if we've to create it ourserlves. To avoid additional fees, you can choose a design beforehand. You don't have to buy a Wordpress theme or from another provider, but you should at least have sketches showing your layout, colors, and content.",
              ),
            ],
          ),
        ],
      ),
    );
  }

  ExpansionPanel faqExpPanel({int index, String title, String description}) {
    return ExpansionPanel(
      isExpanded: expandedIndex == index,
      canTapOnHeader: true,
      headerBuilder: (context, isExpanded) {
        return ListTile(
          title: Text(title),
          leading: Icon(Icons.help_outline),
          // onTap: () {
          //   setState(() {
          //     expandedIndex = expandedIndex != index
          //       ? index
          //       : -1;
          //   });
          // },
        );
      },
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          bottom: 20.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget features() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 60.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 40.0,
            ),
            child: Text(
              'What do you get for this price?',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),

          DataTable(
            columns: const [
              DataColumn(
                label: Text(
                  'Features',
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
              ),
            ],
            rows: [
              featureRow(
                label: 'Domain name',
                description: 'Your website address (e.g. https://myawesomesite.com) will be bought for you, if available.',
              ),

              featureRow(
                label: 'Website development',
                description: 'Your website will be handfully crafted to meet your requirements.',
              ),

              featureRow(
                label: 'Design integration',
                description: 'If you already have a design template or specifications, they will perfectly be integrated.',
              ),

              featureRow(
                label: 'Responsive layout',
                description: 'Your website will be beautiful on desktop, tablet and mobile. We will make sure the presentation is perfect.',
              ),

              featureRow(
                label: 'Deployment',
                description: "Your site will be globally accessible through a robust & fast pipeline. Also upgrades will be done with no downtime and your website won't experience cold start.",
              ),

              featureRow(
                label: 'Security checks',
                description: 'Delivered with full HTTPS encryption & vulnerabilities checks.',
              ),

              featureRow(
                label: 'Auto-scaling',
                description: "Your site is robust and doesn't crash when you've connection spike.",
              ),

              featureRow(
                label: 'Auto-upgrade',
                description: "Whenever a bug is detected or a more recent dependency is available, we'll upgrade your website.",
              ),

              featureRow(
                label: 'Personalized advices',
                description: "We're avaiable for any question or asistance. You can contact us by email, phone or direct message.",
              ),
            ],
          ),
        ],
      ),
    );
  }

  DataRow featureRow({String label, String description}) {
    return DataRow(
      cells: [
        DataCell(
          Tooltip(
            message: description,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.check),
                ),

                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Opacity(
                    opacity: 0.8,
                    child: Text(
                      label,
                      style: TextStyle(
                        // fontSize: 15.0,
                      ),
                    ),
                  ),
                  children: <Widget>[
                    Container(
                      width: 400.0,
                      padding: const EdgeInsets.only(
                        left: 25.0,
                        right: 25.0,
                      ),
                      child: Opacity(
                        opacity: 0.6,
                        child: Text(
                          description,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        ),
      ]
    );
  }

  Widget headerButtonsRow() {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        headerButton(
          label: 'WEB',
          onTap: () => setState(() => projectIndex = 0),
          selected: projectIndex == 0,
        ),

        headerButton(
          label: 'OTHER PLATFORMS AVAILABLE SOON',
          // onTap: () => setState(() => projectIndex = 1),
          selected: projectIndex == 1,
        ),

        // headerButton(
        //   label: 'WEB + MOBILE',
        //   onTap: () => setState(() => projectIndex = 2),
        //   selected: projectIndex == 2,
        // ),
      ],
    );
  }

  Widget headerButton({String label, Function onTap, bool selected = false}) {
    if (selected) {
      return RaisedButton(
        onPressed: onTap,
        color: orangeColor,
        textColor: Colors.white,
        child: Text(
          label,
        ),
      );
    }

    return OutlineButton(
      onPressed: onTap,
      textColor: orangeColor,
      borderSide: BorderSide(
        color: orangeColor,
        width: 2.0,
      ),
      child: Text(
        label,
        style: TextStyle(
          // color: orangeColor,
        ),
      ),
    );
  }

  Widget headerTitle() {
    return Padding(
      padding: const EdgeInsets.all(
        90.0,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () => FluroRouter.router.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
          ),

          Column(
            children: [
              Text(
                'Pricing',
                style: TextStyle(
                  fontSize: 70.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 25.0,
                  top: 10.0,
                ),
                child: Opacity(
                  opacity: 0.6,
                  child: Text(
                    'Do you have a project in mind?',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget priceDescription() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'For your website. Then 45€/year *',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w200,
                ),
              ),

              FlatButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Opacity(
                          opacity: 0.8,
                          child: Text(
                            'Why I have to pay a 45€ annual fee?',
                            style: TextStyle(
                              // fontSize: 15.0,
                            ),
                          ),
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 25.0,
                              right: 25.0,
                            ),
                            child: Opacity(
                              opacity: 0.6,
                              child: Text(
                                "We'll charge you the domain name, the maintenance and additional data cost.",
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  );
                },
                textColor: orangeColor,
                child: Text(
                  'Why?'
                ),
              ),
            ],
          ),

          Opacity(
            opacity: 0.6,
            child: Text(
              '* or we transfert the project to you',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget priceTag() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Opacity(
                opacity: 0.6,
                child: Text(
                  '1200€',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                ),
                child: Opacity(
                  opacity: 0.6,
                  child: Text(
                    'For the first 4 customers.',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Text(
            '500€',
            style: TextStyle(
              fontSize: 120.0,
              fontWeight: FontWeight.w600,
              color: stateColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  void enroll() {}
}
