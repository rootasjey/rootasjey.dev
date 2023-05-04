import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/components/buttons/dark_elevated_button.dart';
import 'package:rootasjey/components/fade_in_y.dart';
import 'package:rootasjey/components/icons/app_icon.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:unicons/unicons.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({
    super.key,
    this.onCancel,
    this.onSubmit,
  });

  /// Called to dismiss this create view.
  final void Function()? onCancel;

  /// Try to create a new project with the desired values.
  final void Function(String name, String summary)? onSubmit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateProjectPageState();
}

class _CreateProjectPageState extends ConsumerState<CreatePostPage> {
  /// Follow the user text input for project's name.
  final TextEditingController _nameController = TextEditingController();

  /// Follow the user text input for project's summary.
  final TextEditingController _summaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final int randomInt = Random().nextInt(5);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            top: 60.0,
            left: 60.0,
            child: AppIcon(),
          ),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    width: 600.0,
                    padding: const EdgeInsets.only(
                      top: 160.0,
                      left: 12.0,
                      right: 12.0,
                      bottom: 200.0,
                    ),
                    child: Column(
                      children: [
                        header(),
                        nameInput(randomHint: randomInt),
                        summaryInput(randomHint: randomInt),
                        footerButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Column(
      children: [
        FadeInY(
          beginY: Utilities.ui.getBeginY(),
          child: Icon(
            UniconsLine.edit_alt,
            size: 42.0,
            color: Constants.colors.palette.first,
          ),
        ),
        FadeInY(
          beginY: Utilities.ui.getBeginY(),
          delay: Duration(
            milliseconds: Utilities.ui.getNextAnimationDelay(reset: true),
          ),
          child: Text(
            "post_create_new".tr(),
            style: Utilities.fonts.body(
              textStyle: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        FadeInY(
          beginY: Utilities.ui.getBeginY(),
          delay: Duration(milliseconds: Utilities.ui.getNextAnimationDelay()),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Opacity(
              opacity: 0.4,
              child: Text(
                "post_create_new_subtitle".tr(),
                textAlign: TextAlign.center,
                style: Utilities.fonts.body2(
                  textStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget nameInput({int randomHint = 0}) {
    return Column(
      children: [
        FadeInY(
          beginY: Utilities.ui.getBeginY(),
          delay: Duration(milliseconds: Utilities.ui.getNextAnimationDelay()),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 54.0,
              bottom: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "post_name".tr(),
                  style: Utilities.fonts.body(
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        FadeInY(
          beginY: Utilities.ui.getBeginY(),
          delay: Duration(milliseconds: Utilities.ui.getNextAnimationDelay()),
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 12.0,
            ),
            child: TextField(
              autofocus: true,
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "post_create_new_names.$randomHint".tr(),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.colors.palette.first,
                    width: 4.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.4) ??
                        Colors.white12,
                    width: 4.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.colors.palette.first,
                    width: 4.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget summaryInput({int randomHint = 0}) {
    return Column(
      children: [
        FadeInY(
          beginY: Utilities.ui.getBeginY(),
          delay: Duration(milliseconds: Utilities.ui.getNextAnimationDelay()),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "post_summary".tr(),
                  style: Utilities.fonts.body(
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        FadeInY(
          beginY: Utilities.ui.getBeginY(),
          delay: Duration(milliseconds: Utilities.ui.getNextAnimationDelay()),
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 12.0,
            ),
            child: TextField(
              autofocus: false,
              controller: _summaryController,
              textInputAction: TextInputAction.go,
              onSubmitted: (String summary) {
                widget.onSubmit?.call(_nameController.text, summary);
              },
              decoration: InputDecoration(
                hintText: "post_create_new_summaries.$randomHint".tr(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.colors.palette.elementAt(1),
                    width: 4.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.4) ??
                        Colors.white12,
                    width: 4.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget footerButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Wrap(
        spacing: 24.0,
        runSpacing: 24.0,
        children: [
          FadeInY(
            beginY: Utilities.ui.getBeginY(),
            delay: Duration(milliseconds: Utilities.ui.getNextAnimationDelay()),
            child: DarkElevatedButton.icon(
              iconData: UniconsLine.times,
              labelValue: "cancel".tr(),
              background: Colors.black,
              onPressed: () => widget.onCancel?.call(),
            ),
          ),
          FadeInY(
            beginY: Utilities.ui.getBeginY(),
            delay: Duration(milliseconds: Utilities.ui.getNextAnimationDelay()),
            child: DarkElevatedButton.large(
              onPressed: () {
                widget.onSubmit?.call(
                  _nameController.text,
                  _summaryController.text,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "create".tr(),
                      style: Utilities.fonts.body(
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        UniconsLine.arrow_right,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
