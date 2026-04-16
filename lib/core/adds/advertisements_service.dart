import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdvertisementsService {
  AdvertisementsService._();
  static final AdvertisementsService _instance =
      AdvertisementsService._(); //singleton

  factory AdvertisementsService() => _instance;
  ////////////////////////////////////////////////////////////////////////////////////

  static String rewardAddTestId = "ca-app-pub-3940256099942544/5224354917";

  RewardedAd? _rewardedAd;

  Future<bool> showRewardAd({
    VoidCallback? onEarnedReward,
    VoidCallback? onAdFailedToShow,
  }) async {
    bool isShow = false;

    final completer = Completer<bool>();

    await RewardedAd.load(
      adUnitId: "ca-app-pub-1385818206803822/7117946458",
      request: AdRequest(),

      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) async {
          //set add
          _rewardedAd = ad;

          //show add
          await _rewardedAd!.show(
            onUserEarnedReward: (ad, reward) {
              onEarnedReward?.call();
            },
          );

          completer.complete(true);
        },

        onAdFailedToLoad: (error) {
          //there is not adds to show
          if (error.code == 3) {
            completer.complete(true);
            return;
          }

          onAdFailedToShow?.call();
        },
      ),
    );

    return completer.future;
  }
}

//for add
//ca-app-pub-1385818206803822/7117946458
