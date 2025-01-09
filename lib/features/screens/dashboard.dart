import 'package:admin_project/features/core/theme/colors.dart';
import 'package:admin_project/features/screens/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _selectedFilter = 'Last 7 Days';
  final List<String> _filterOptions = ['Last 7 Days', 'Last Month'];

  /// // Method to calculate revenue by month or last 7 days
  Stream<Map<String, Map<String, double>>> _calculateRevenueByMonth() {
    return FirebaseFirestore.instance
        .collection('bookings')
        .snapshots()
        .map((querySnapshot) {
      final Map<String, Map<String, double>> revenueData = {};
      final DateTime now = DateTime.now();

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final timestamp = (data['bookeDate'] as Timestamp?)?.toDate();
        final packageName = data['packageName'] ?? 'Unknown Package';
        final totalPrice = (data['totalPrice'] ?? 0.0) as double;

        if (timestamp != null) {
          String key;
          if (_selectedFilter == 'Last 7 Days' &&
              timestamp.isAfter(now.subtract(const Duration(days: 7)))) {
            key = DateFormat('MMM dd').format(timestamp); // Display by day
          } else if (_selectedFilter == 'Last Month' &&
              timestamp.year == now.year &&
              timestamp.month == now.month) {
            key =
                DateFormat('MMM yyyy').format(timestamp); //// Display by month
          } else {
            continue; // //Skip if the timestamp doesn't match the filter
          }

          //// Initialize the map if it doesn't exist
          revenueData.putIfAbsent(key, () => {});
          // // Add the revenue by package name for this date
          revenueData[key]![packageName] =
              (revenueData[key]?[packageName] ?? 0) + totalPrice;
        }
      }
      return revenueData;
    });
  }

  ///// Method to calculate total revenue based on the selected filter
  double _calculateTotalRevenue(Map<String, Map<String, double>> revenueData) {
    double totalRevenue = 0;
    revenueData.forEach((_, packageData) {
      packageData.forEach((_, revenue) {
        totalRevenue += revenue;
      });
    });
    return totalRevenue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homebg,
      drawer: Menu(),
      appBar: AppBar(
        title: const Text('Revenue Chart'),
        backgroundColor: homebg,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: _filterOptions
                      .map((filter) => DropdownMenuItem<String>(
                          value: filter, child: Text(filter)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                  },
                ),
                StreamBuilder<Map<String, Map<String, double>>>(
                  stream: _calculateRevenueByMonth(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No revenue data available');
                    }

                    final revenueData = snapshot.data!;
                    final totalRevenue = _calculateTotalRevenue(revenueData);

                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: lightPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Total: \$${totalRevenue.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: whitecolor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<Map<String, Map<String, double>>>(
              stream: _calculateRevenueByMonth(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No revenue data available'));
                }

                final revenueData = snapshot.data!;
                final List<String> labels = revenueData.keys.toList();
                final allPackageNames = revenueData.values
                    .expand((packageData) => packageData.keys)
                    .toSet()
                    .toList();

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BarChart(
                    BarChartData(
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toStringAsFixed(1),
                                style: const TextStyle(
                                    color: lightPrimary, fontSize: 10),
                              );
                            },
                            reservedSize: 40,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < labels.length) {
                                final label = labels[index];
                                final packageData = revenueData[label]!;
                                return Transform.translate(
                                  offset: const Offset(0, 8),
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                        color: lightPrimary, fontSize: 10),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                            reservedSize: 60,
                          ),
                        ),
                      ),
                      barGroups: labels.map((label) {
                        final packageData = revenueData[label]!;
                        return BarChartGroupData(
                          x: labels.indexOf(label),
                          barRods: allPackageNames.map((packageName) {
                            final value = packageData[packageName] ?? 0;
                            return BarChartRodData(
                              toY: value,
                              color: lightPrimary,
                              width: 16,
                              borderSide:
                                  BorderSide(color: whitecolor, width: 0.5),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
