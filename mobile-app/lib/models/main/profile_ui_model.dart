class ProfileUI {
  final bool isLocked;
  final bool showAbout;
  final bool showCerts;
  final bool showDonation;
  final bool showHeatMap;
  final bool showLocation;
  final bool showName;
  final bool showPoints;
  final bool showPortfolio;
  final bool showTimeLine;

  ProfileUI(
      {required this.isLocked,
      required this.showAbout,
      required this.showCerts,
      required this.showDonation,
      required this.showHeatMap,
      required this.showLocation,
      required this.showName,
      required this.showPoints,
      required this.showPortfolio,
      required this.showTimeLine});

  factory ProfileUI.fromJson(Map<String, dynamic> data) {
    return ProfileUI(
        isLocked: data['isLocked'],
        showAbout: data['showAbout'],
        showCerts: data['showCerts'],
        showDonation: data['showDonation'],
        showHeatMap: data['showHeatMap'],
        showLocation: data['showLocation'],
        showName: data['showName'],
        showPoints: data['showPoints'],
        showPortfolio: data['showPortfolio'],
        showTimeLine: data['showTimeLine']);
  }

  static Map<String, dynamic> toMap(ProfileUI data) {
    return {
      'isLocked': data.isLocked,
      'showAbout': data.showAbout,
      'showCerts': data.showCerts,
      'showDonation': data.showDonation,
      'showHeatMap': data.showHeatMap,
      'showLocation': data.showLocation,
      'showName': data.showName,
      'showPoints': data.showPoints,
      'showPortfolio': data.showPortfolio,
      'showTimeLine': data.showTimeLine,
    };
  }
}
