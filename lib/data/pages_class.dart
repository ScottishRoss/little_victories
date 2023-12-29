class Pages {
  Pages({
    required this.index,
    required this.name,
    required this.route,
  });
  int index;
  String name;
  String route;

  static List<Pages> pages = <Pages>[
    Pages(index: 0, name: 'Home', route: '/home'),
    Pages(index: 1, name: 'Preferences', route: '/preferences'),
    Pages(index: 2, name: 'Your Victories', route: '/view_victories'),
  ];
}
