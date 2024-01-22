import 'package:flutter/material.dart';
import 'package:surf_widget_test_composer_example/src/localization/localizations_x.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  const SampleItemDetailsView(this.company, {super.key});

  static const routeName = '/sample_item';

  final String company;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.sampleFeatureItemDetailsViewTitle),
      ),
      body: Center(
        child: Text(context.l10n.sampleFeatureItemDetailsViewInfo(company)),
      ),
    );
  }
}
