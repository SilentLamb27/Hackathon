import 'package:flutter/material.dart';
import '../models/predictive_maintenance.dart';

class PredictiveMaintenanceWidget extends StatefulWidget {
  final PredictiveMaintenanceModel data;
  const PredictiveMaintenanceWidget({Key? key, required this.data}) : super(key: key);

  @override
  State<PredictiveMaintenanceWidget> createState() => _PredictiveMaintenanceWidgetState();
}

class _PredictiveMaintenanceWidgetState extends State<PredictiveMaintenanceWidget> {
  late String prediction;

  @override
  void initState() {
    super.initState();
    prediction = widget.data.getMaintenancePrediction();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Predictive Maintenance', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(prediction, style: TextStyle(
              color: prediction.startsWith('Warning') ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            )),
            const SizedBox(height: 8),
            Divider(),
            _buildStatRow('Engine Temp', widget.data.engineTemp.toStringAsFixed(1) + ' °C'),
            _buildStatRow('Battery Health', widget.data.batteryHealth.toStringAsFixed(1) + ' %'),
            _buildStatRow('Tire Pressure', widget.data.tirePressure.toStringAsFixed(1) + ' psi'),
            _buildStatRow('Mileage', widget.data.mileage.toStringAsFixed(0) + ' km'),
            _buildStatRow('Last Service', widget.data.lastServiceDate.toLocal().toString().split(' ')[0]),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
