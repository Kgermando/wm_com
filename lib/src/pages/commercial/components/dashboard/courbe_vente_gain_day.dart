import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wm_commercial/src/constants/app_theme.dart';
import 'package:wm_commercial/src/constants/responsive.dart';
import 'package:wm_commercial/src/helpers/monnaire_storage.dart';
import 'package:wm_commercial/src/models/commercial/courbe_vente_gain_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wm_commercial/src/pages/commercial/controller/dashboard/dashboard_com_controller.dart';

class CourbeVenteGainDay extends StatefulWidget {
  const CourbeVenteGainDay(
      {Key? key, required this.controller, required this.monnaieStorage})
      : super(key: key);
  final DashboardComController controller;
  final MonnaieStorage monnaieStorage;

  @override
  State<CourbeVenteGainDay> createState() => _CourbeVenteGainDayState();
}

class _CourbeVenteGainDayState extends State<CourbeVenteGainDay> {
  TooltipBehavior? _tooltipBehavior;

  bool? isCardView;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(p8),
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            // Chart title
            title: ChartTitle(
                text: 'Courbe de Ventes journalières',
                textStyle: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
            // Enable legend
            legend: Legend(
                position: Responsive.isDesktop(context)
                    ? LegendPosition.right
                    : LegendPosition.bottom,
                isVisible: true),
            // Enable tooltip
            palette: const [
              Color.fromRGBO(73, 76, 162, 1),
              Color.fromRGBO(51, 173, 127, 1),
              Color.fromRGBO(244, 67, 54, 1)
            ],
            tooltipBehavior: _tooltipBehavior,
            primaryYAxis: NumericAxis(
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              title: AxisTitle(
                  text: DateFormat("dd-MM-yyyy").format(DateTime.now())),
              numberFormat: NumberFormat.currency(
                  symbol: '${widget.monnaieStorage.monney} ', decimalDigits: 1),
            ),
            series: <LineSeries>[
              LineSeries<CourbeVenteModel, String>(
                name: 'Ventes',
                dataSource: widget.controller.venteDayList,
                sortingOrder: SortingOrder.ascending,
                markerSettings: const MarkerSettings(isVisible: true),
                xValueMapper: (CourbeVenteModel ventes, _) =>
                    "${ventes.created}:00",
                yValueMapper: (CourbeVenteModel ventes, _) =>
                    double.parse(ventes.sum.toStringAsFixed(2)),
                // Enable data label
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
              LineSeries<CourbeGainModel, String>(
                name: 'Gains',
                dataSource: widget.controller.gainDayList,
                sortingOrder: SortingOrder.ascending,
                markerSettings: const MarkerSettings(isVisible: true),
                xValueMapper: (CourbeGainModel ventes, _) =>
                    "${ventes.created}:00",
                yValueMapper: (CourbeGainModel ventes, _) =>
                    double.parse(ventes.sum.toStringAsFixed(2)),
                // Enable data label
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ]),
      ),
    );
  }
}
