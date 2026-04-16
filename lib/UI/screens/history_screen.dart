import 'package:flutter/material.dart';
import 'package:your_political_test/UI/screens/results_screen.dart';
import 'package:your_political_test/UI/screens/widget/custom_scaffold.dart';
import 'package:your_political_test/app/theme/app_colors.dart';
import 'package:your_political_test/core/entities/political_result.dart';
import 'package:your_political_test/core/local_database_service/local_database_service.dart';
import 'package:your_political_test/l10n/app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  AppLocalizations get appLocalizations => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(title: Text(appLocalizations.history)),
      body: FutureBuilder(
        future: LocalDatabaseService.getTestListHistorial(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final historial = snapshot.data as List<PoliticalResult>;

          if (historial.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.layers_clear),
                  SizedBox(height: 4),

                  Text(appLocalizations.noHistory),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: historial.length,

            itemBuilder: (context, index) {
              final currentResult = historial[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _buildUserCard(currentResult),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildUserCard(PoliticalResult userResult) {
    return Card(
      color: AppColors.backgroundDark,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    userResult.userName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultsScreen(
                            result: userResult,
                            showActionsButtons: false,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      appLocalizations.viewResult,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${appLocalizations.economy} ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white30,
                    ),
                  ),
                  TextSpan(
                    text: getEconomicResult(userResult.economicPosition),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${appLocalizations.freedom} ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white30,
                    ),
                  ),
                  TextSpan(
                    text: getAuthorityResult(userResult.authorityPosition),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getEconomicResult(double value) {
    if (value >= 5) {
      return appLocalizations.ultraright;
    } else if (value >= 3) {
      return appLocalizations.right;
    } else if (value > 0.51) {
      return appLocalizations.centerright;
    } else if (value >= 0 || value < 0 && value >= -0.51) {
      return appLocalizations.center;
    } else if (value <= -5) {
      return appLocalizations.ultraleft;
    } else if (value <= -3) {
      return appLocalizations.left;
    } else if (value <= -0.51) {
      return appLocalizations.centerleft;
    } else {
      throw Exception('Invalid economic position');
    }
  }

  String getAuthorityResult(double value) {
    if (value >= 5) {
      return appLocalizations.liberal;
    } else if (value >= 3) {
      return appLocalizations.liberal;
    } else if (value >= 0 || value < 0 && value >= -3) {
      return appLocalizations.center;
    } else if (value <= -5) {
      return appLocalizations.authoritarian;
    } else if (value < 0 && value <= -3) {
      return appLocalizations.moderateauthoritarian;
    } else {
      throw Exception('Invalid economic position');
    }
  }
}
