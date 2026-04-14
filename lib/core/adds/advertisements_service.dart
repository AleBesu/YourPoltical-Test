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

  static String intersticialAddTestId =
      "ca-app-pub-3940256099942544/1033173712";

  static String bannerAddTestId = "ca-app-pub-3940256099942544/6300978111";

  static String rewardAddTestId = "ca-app-pub-3940256099942544/5224354917";

  final Queue<InterstitialAd> _interstitialAdsPool = Queue();

  RewardedAd? _rewardedAd;

  Future<void> _loadInterstitialAd() async {
    final futureCompleter = Completer<void>();

    await InterstitialAd.load(
      adUnitId: intersticialAddTestId,
      request: AdRequest(),

      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) async {
          //set immersive mode
          ad.setImmersiveMode(true);
          _interstitialAdsPool.add(ad);

          futureCompleter.complete();
        },
        onAdFailedToLoad: (error) {
          futureCompleter.completeError(error);
        },
      ),
    );

    return futureCompleter.future;
  }

  Future<void> _showInterstitialAd() async {
    final futureCompleter = Completer<void>();
    final add = _interstitialAdsPool.removeFirst();
    //show add
    add.show();

    //callback
    add.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        futureCompleter.complete();
      },
      onAdClicked: (ad) {
        futureCompleter.complete();
      },
    );

    return futureCompleter.future;
  }

  Future<void> showMultipleAdds(
    int quantity, {
    VoidCallback? onLoadedAdds,
    VoidCallback? afterShowAllAdds,
  }) async {
    //
    if (quantity <= 0) {
      throw Exception("Invalid quantity quantity should be > 0");
    }

    try {
      for (int i = 0; i < quantity; i++) {
        //first load all the adds

        await _loadInterstitialAd();
      }
      //
      onLoadedAdds?.call();
      while (_interstitialAdsPool.isNotEmpty) {
        //then show all the adds
        await _showInterstitialAd();
      }

      afterShowAllAdds?.call();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> showRewardAd({
    VoidCallback? onEarnedReward,
    VoidCallback? onAdFailedToShow,
  }) async {
    await RewardedAd.load(
      adUnitId: rewardAddTestId,
      request: AdRequest(),

      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) async {
          //set add
          _rewardedAd = ad;

          //show add
          await _rewardedAd!.show(
            onUserEarnedReward: (ad, reward) {
              onEarnedReward?.call();
              ad.dispose();
            },
          );
        },

        onAdFailedToLoad: (error) {
          onAdFailedToShow?.call();
        },
      ),
    );
  }
}
//for app
//ca-app-pub-1385818206803822~3354570077

//for add
//ca-app-pub-1385818206803822/7117946458
