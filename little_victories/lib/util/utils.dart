import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import '../api/twitter_api.dart';

class TwitterLoginCred {
  TwitterLogin twitterLogin = TwitterLogin(
    consumerKey: TwitterApi.apiKey,
    consumerSecret: TwitterApi.apiKeySecret,
  );
}
