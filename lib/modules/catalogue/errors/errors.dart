abstract class FailedPostCatch implements Exception {}

abstract class NoPage implements Exception {}

class FailedGithubCatch extends FailedPostCatch {}

class NoGithubPages extends NoPage {}
