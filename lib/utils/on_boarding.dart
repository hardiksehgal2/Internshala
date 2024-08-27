class OnBoardingModel {
  final String asset;
  final String titel;
  final String subtitle;

  OnBoardingModel({
    required this.asset,
    required this.titel,
    required this.subtitle,
  });
}
List<OnBoardingModel> onBoardingItems = [
  OnBoardingModel(
    asset: 'assets/images/study.png',
    titel: 'Discover Opportunities',
    subtitle: 'Find internships that match your skills and interests, available in cities across the globe. Start your career journey with ease.',
  ),
  OnBoardingModel(
    asset: 'assets/images/study2.png',
    titel: 'Tailored to You',
    subtitle: 'Filter internships by domain, location, and more to find the perfect fit. Our platform is designed to match you with opportunities that suit your goals.',
  ),
  OnBoardingModel(
    asset: 'assets/images/study3.png',
    titel: 'Apply with Confidence',
    subtitle: 'Easily apply to internships directly through our platform. Track your applications and get updates on your progress all in one place.',
  ),
];
