import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/features/web.dart';
import 'package:rootasjey/components/footer.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

class PricingPage extends StatefulWidget {
  @override
  _PricingPageState createState() => _PricingPageState();
}

class _PricingPageState extends State<PricingPage> {
  final orangeColor = Color(0xFFF39C12);
  final largeHorizPadding = 90.0;
  final narrowHorizPadding = 20.0;
  final narrowWidthLimit = 800.0;

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
          context.router.push(EnrollPageRoute());
        },
        backgroundColor: stateColors.primary,
        foregroundColor: Colors.white,
        icon: Icon(Icons.payment),
        label: Text("enroll".tr()),
      ),
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
              "faq.title".tr().toUpperCase(),
              style: FontsUtils.mainStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ExpansionPanelList(
            expansionCallback: (index, isExpanded) {
              setState(() {
                expandedIndex = expandedIndex != index ? index : -1;
              });
            },
            children: [
              faqExpPanel(
                index: 0,
                title: "faq.price.question".tr(),
                description: "faq.price.answer".tr(),
              ),
              faqExpPanel(
                index: 1,
                title: "faq.service.question".tr(),
                description: "faq.service.answer".tr(),
              ),
              faqExpPanel(
                index: 2,
                title: "faq.annual_fee.question".tr(),
                description: "faq.annual_fee.answer".tr(),
              ),
              faqExpPanel(
                index: 3,
                title: "faq.data_plan.question".tr(),
                description: "faq.data_plan.answer".tr(),
              ),
              faqExpPanel(
                index: 4,
                title: "faq.data_plan_unlimited.question".tr(),
                description: "faq.data_plan_unlimited.answer".tr(),
              ),
              faqExpPanel(
                index: 5,
                title: "faq.one_time_fee.question".tr(),
                description: "faq.one_time_fee.answer".tr(),
              ),
              faqExpPanel(
                index: 6,
                title: "faq.modifications.question",
                description: "faq.modifications.answer".tr(),
              ),
              faqExpPanel(
                index: 7,
                title: "faq.refund.question".tr(),
                description: "faq.refund.answer".tr(),
              ),
              faqExpPanel(
                index: 8,
                title: "faq.payment_types.question".tr(),
                description: "faq.payment_types.answer".tr(),
              ),
              faqExpPanel(
                index: 9,
                title: "faq.discount.question".tr(),
                description: "faq.discount.answer".tr(),
              ),
              faqExpPanel(
                index: 10,
                title: "faq.pay_fee_once.question".tr(),
                description: "faq.pay_fee_once.answer".tr(),
              ),
              faqExpPanel(
                index: 11,
                title: "faq.bug.question".tr(),
                description: "faq.bug.answer".tr(),
              ),
              faqExpPanel(
                index: 12,
                title: "faq.design.question".tr(),
                description: "faq.design.answer".tr(),
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
          leading: Icon(UniconsLine.question),
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
                  style: FontsUtils.mainStyle(
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
        top: 100.0,
      ),
      child: WebFeatures(),
    );
  }

  Widget headerButtonsRow() {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        headerButton(
          label: "web".tr(),
          onTap: () => setState(() => projectIndex = 0),
          selected: projectIndex == 0,
        ),

        headerButton(
          label: "platforms_soon_availale".tr().toUpperCase(),
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

  Widget headerButton({
    String label,
    Function onTap,
    bool selected = false,
  }) {
    if (selected) {
      return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          primary: orangeColor,
          textStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        child: Text(label),
      );
    }

    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        textStyle: TextStyle(
          color: orangeColor,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: orangeColor,
            width: 2.0,
          ),
        ),
      ),
      child: Text(label),
    );
  }

  Widget headerTitle() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            onPressed: context.router.pop,
            icon: Icon(UniconsLine.arrow_left),
          ),
        ),
        Column(
          children: [
            Text(
              "pricing".tr(),
              style: FontsUtils.mainStyle(
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
                  "project_in_mind_question".tr(),
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
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
                "app_annual_fee".tr(),
                style: FontsUtils.mainStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Opacity(
                          opacity: 0.8,
                          child: Text("app_annual_fee_why".tr()),
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 25.0,
                              right: 25.0,
                            ),
                            child: Opacity(
                              opacity: 0.6,
                              child: Text("app_annual_fee_reasons".tr()),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: TextButton.styleFrom(
                  textStyle: TextStyle(
                    color: orangeColor,
                  ),
                ),
                child: Text("why".tr()),
              ),
            ],
          ),
          Opacity(
            opacity: 0.6,
            child: Text(
              "project_transfert_asterisk".tr(),
              style: FontsUtils.mainStyle(
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
                  style: FontsUtils.mainStyle(
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
                    "discount_first_customers".tr(),
                    style: FontsUtils.mainStyle(
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
            style: FontsUtils.mainStyle(
              fontSize: 120.0,
              fontWeight: FontWeight.w600,
              color: stateColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
