import 'package:charter_appli_travaux_mro/web_admin/screens/offres_list_page.dart';
import 'package:charter_appli_travaux_mro/web_admin/screens/reservations_list_page.dart';
import 'package:charter_appli_travaux_mro/web_admin/screens/review_list_page.dart';
import 'package:charter_appli_travaux_mro/web_admin/screens/user_list_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../utils/appStrings.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  Future<int> _getNombreTotalUtilisateurs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('utilisateurs').get();
    return querySnapshot.size;
  }

  Future<int> _getNombreTotalAvis() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('avis').get();
    return querySnapshot.size;
  }

  Future<int> _getNombreTotalReservations() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('reservations').get();
    return querySnapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7BF853),
        title: Text('Tableau de bord', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 50.0),
                    child: Image(
                      image: AssetImage(AppStrings.cheminLogo),
                    ),
                  ),
                ),
                Text(
                  'Statistiques',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                FutureBuilder(
                  future: Future.wait([
                    _getNombreTotalUtilisateurs(),
                    _getNombreTotalAvis(),
                    _getNombreTotalReservations(),
                  ]),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<int>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    int totalUtilisateurs = snapshot.data![0];
                    int totalAvis = snapshot.data![1];
                    int totalReservations = snapshot.data![2];

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard(context, 'Utilisateurs',
                            totalUtilisateurs, Colors.blue, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserListPage()),
                          );
                        }),
                        _buildStatCard(context, 'Avis', totalAvis, Colors.red,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewsListPage()),
                          );
                        }),
                        _buildStatCard(context, 'Réservations',
                            totalReservations, Colors.green, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReservationsListPage()),
                          );
                        }),
                        _buildStatCard(context, 'Offres Charter', totalAvis,
                            Color.fromARGB(255, 200, 54, 244), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OffresListPage()),
                          );
                        }),
                      ],
                    );
                  },
                ),
                SizedBox(height: 24),
                Text(
                  'Réservations par mois',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Container(
                  height: 200,
                  child: _buildReservationsChart(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, int value,
      Color color, Null Function() param4) {
    return Expanded(
      child: Container(
        width: double.infinity,
        child: Card(
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                switch (title) {
                  case 'Utilisateurs':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserListPage()));
                    break;
                  case 'Avis':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReviewsListPage()));
                    break;
                  case 'Réservations':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReservationsListPage()));
                    break;
                  case 'Offres Charter':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OffresListPage()));
                    break;
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    value.toString(),
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReservationsChart() {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY:
            100, // Vous pouvez ajuster cette valeur en fonction de vos besoins
        lineBarsData: [
          LineChartBarData(
            spots: [
// Remplacer ces valeurs par les données réelles de réservations par mois
              FlSpot(0, 20),
              FlSpot(1, 30),
              FlSpot(2, 50),
              FlSpot(3, 40),
              FlSpot(4, 60),
              FlSpot(5, 70),
              FlSpot(6, 80),
              FlSpot(7, 90),
              FlSpot(8, 100),
              FlSpot(9, 50),
              FlSpot(10, 60),
              FlSpot(11, 40),
            ],
            isCurved: true,
            colors: [
              Color(0xFF7BF853),
            ],
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: true, colors: [Color(0x227BF853)]),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              switch (value.toInt()) {
                case 0:
                  return 'Jan';
                case 1:
                  return 'Fév';
                case 2:
                  return 'Mar';
                case 3:
                  return 'Avr';
                case 4:
                  return 'Mai';
                case 5:
                  return 'Jun';
                case 6:
                  return 'Jul';
                case 7:
                  return 'Aoû';
                case 8:
                  return 'Sep';
                case 9:
                  return 'Oct';
                case 10:
                  return 'Nov';
                case 11:
                  return 'Déc';
                default:
                  return '';
              }
            },
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
