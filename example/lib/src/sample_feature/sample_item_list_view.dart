import 'package:flutter/material.dart';
import 'package:surf_widget_test_composer_example/src/localization/localizations_x.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends StatelessWidget {
  const SampleItemListView({
    super.key,
    this.items = const [
      SampleItem(1, 'Apple'),
      SampleItem(2, 'Google'),
      SampleItem(3, 'Surf'),
    ],
  });

  static const routeName = '/';

  final List<SampleItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.sampleFeatureTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: ListView.builder(
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
              title:
                  Text('${context.l10n.sampleFeatureSampleItemTitle(item.id)} - ${item.company}'),
              leading: const CircleAvatar(
                foregroundImage: AssetImage('assets/images/surf_flutter_team_logo.jpg'),
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  SampleItemDetailsView.routeName,
                  arguments: item,
                );
              });
        },
      ),
    );
  }
}
