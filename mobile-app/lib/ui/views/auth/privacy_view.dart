import 'package:flutter/material.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const paragraphTextStyle = TextStyle(
      fontSize: 18,
      fontFamily: 'Lato',
      height: 1.2,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.quincy_email_signup),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                context.t.quincy_email_part_one,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                context.t.quincy_email_part_two,
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                context.t.quincy_email_part_three,
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                context.t.quincy_email_part_four,
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                context.t.quincy_email_part_five,
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                context.t.quincy_email_part_six,
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                context.t.quincy_email_part_seven,
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                context.t.quincy_email_part_eight,
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                context.t.quincy_email_part_nine,
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                context.t.quincy_email_part_ten,
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                context.t.quincy_email_part_eleven,
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                context.t.quincy_email_part_twelve,
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                context.t.quincy_email_part_thirteen,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              buildDivider(),
              const SizedBox(
                height: 4,
              ),
              Text(
                context.t.quincy_email_part_fourteen,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Lato',
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                context.t.quincy_email_part_fifteen,
                style: paragraphTextStyle,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF0a0a23),
                      ),
                      child: Text(
                        context.t.quincy_email_confirm,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF0a0a23),
                      ),
                      child: Text(
                        context.t.quincy_email_no_thanks,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
