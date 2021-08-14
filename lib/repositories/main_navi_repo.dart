import 'package:lafhub/lafhub_models.dart';

abstract class MainNavigationRepoExpected {
  MainNavigationModel getNavModel();
}

class MainNavigationRepository implements MainNavigationRepoExpected {
  @override
  MainNavigationModel getNavModel() {
    return MainNavigationModel(
      initialIndex: 0,
      pageTypes: [
        NavigationPageType.feed,
        NavigationPageType.explore,
        NavigationPageType.profile
      ],
    );
  }
}
