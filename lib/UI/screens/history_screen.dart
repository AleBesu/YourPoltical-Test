import 'package:flutter/material.dart';
import 'package:your_political_test/UI/screens/results_screen.dart';
import 'package:your_political_test/UI/screens/widget/custom_scaffold.dart';
import 'package:your_political_test/app/theme/app_colors.dart';
import 'package:your_political_test/core/entities/political_result.dart';
import 'package:your_political_test/core/local_database_service/local_database_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(title: Text("Historial")),
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

                  Text('No hay resultados en el historial'),
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
                      "Ver Resultado",
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
                    text: "Economía:",
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
                    text: "Libertad:",
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
      return 'Ultra-Derecha';
    } else if (value >= 3) {
      return 'Derecha';
    } else if (value > 0.51) {
      return 'Centro-Derecha';
    } else if (value >= 0 || value < 0 && value >= -0.51) {
      return 'Centro';
    } else if (value <= -5) {
      return 'Ultra-Izquierda';
    } else if (value <= -3) {
      return 'Izquierda';
    } else if (value <= -0.51) {
      return 'Centro-Izquierda';
    } else {
      throw Exception('Invalid economic position');
    }
  }

  String getAuthorityResult(double value) {
    if (value >= 5) {
      return 'Liberal';
    } else if (value >= 3) {
      return 'Liberal-Moderado';
    } else if (value >= 0 || value < 0 && value >= -3) {
      return 'Centro';
    } else if (value <= -5) {
      return 'Totalitario';
    } else if (value < 0 && value <= -3) {
      return 'Totalitario-Moderado';
    } else {
      throw Exception('Invalid economic position');
    }
  }
}
