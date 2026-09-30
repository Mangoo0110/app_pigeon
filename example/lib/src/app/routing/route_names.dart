enum RouteNames {
  splash('/splash', 'splash'),
  onboarding('/onboarding', 'onboarding'),
  login('/login', 'login'),
  signup('/signup', 'signup'),
  app('/app', 'app'),
  profile('/profile', 'profile');

  final String path;
  final String name;
  const RouteNames(this.path, this.name);
}
