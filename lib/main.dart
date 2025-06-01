import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(SimRepairProfitApp());
}

class SimRepairProfitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIM & Repair Profit Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ProfitTrackerPage(),
    );
  }
}

class ProfitTrackerPage extends StatefulWidget {
  @override
  _ProfitTrackerPageState createState() => _ProfitTrackerPageState();
}

class _ProfitTrackerPageState extends State<ProfitTrackerPage> {
  final List<Sale> simSales = [];
  final List<Repair> repairs = [];

  final simCostController = TextEditingController(text: '1.0');
  final simPriceController = TextEditingController();
  final repairIncomeController = TextEditingController();
  final repairCostController = TextEditingController();

  double get totalSimProfit {
    double cost = double.tryParse(simCostController.text) ?? 0;
    double profit = 0;
    for (var sale in simSales) {
      profit += (sale.sellingPrice - cost);
    }
    return profit;
  }

  double get totalRepairProfit {
    double profit = 0;
    for (var r in repairs) {
      profit += (r.income - r.cost);
    }
    return profit;
  }

  double get totalProfit => totalSimProfit + totalRepairProfit;

  @override
  void dispose() {
    simCostController.dispose();
    simPriceController.dispose();
    repairIncomeController.dispose();
    repairCostController.dispose();
    super.dispose();
  }

  void addSimSale() {
    double price = double.tryParse(simPriceController.text) ?? 0;
    if (price > 0) {
      setState(() {
        simSales.add(Sale(price, DateTime.now()));
        simPriceController.clear();
      });
    }
  }

  void addRepair() {
    double income = double.tryParse(repairIncomeController.text) ?? 0;
    double cost = double.tryParse(repairCostController.text) ?? 0;
    if (income > 0 && cost >= 0) {
      setState(() {
        repairs.add(Repair(income, cost, DateTime.now()));
        repairIncomeController.clear();
        repairCostController.clear();
      });
    }
  }

  String formatKD(double amount) {
    return "KD ${amount.toStringAsFixed(2)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SIM & Repair Profit Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("SIM Sales", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: simCostController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Cost per SIM (KD)")),
            TextField(controller: simPriceController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Selling Price (KD)")),
            ElevatedButton(onPressed: addSimSale, child: Text("Add SIM Sale")),
            Divider(),
            Text("Mobile Repairs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: repairIncomeController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Repair Income (KD)")),
            TextField(controller: repairCostController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Repair Cost (KD)")),
            ElevatedButton(onPressed: addRepair, child: Text("Add Repair")),
            Divider(),
            Text("Total SIM Profit: ${formatKD(totalSimProfit)}"),
            Text("Total Repair Profit: ${formatKD(totalRepairProfit)}"),
            Text("Total Profit: ${formatKD(totalProfit)}", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class Sale {
  final double sellingPrice;
  final DateTime date;

  Sale(this.sellingPrice, this.date);
}

class Repair {
  final double income;
  final double cost;
  final DateTime date;

  Repair(this.income, this.cost, this.date);
}