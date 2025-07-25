// lib/pages/home/widgets/grafico_visitas.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoVisitas extends StatelessWidget {
  final List<int> visitas;

  const GraficoVisitas({required this.visitas, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Visitas na semana",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12),
        Container(
          height: 200,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: BarChart(
            BarChartData(
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final dias = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(dias[value.toInt()]),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              barGroups: List.generate(7, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: visitas[index].toDouble(),
                      color: Colors.orange,
                      width: 18,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
