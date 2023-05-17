import 'package:charter_appli_travaux_mro/view/services/user_service.dart';
import 'package:charter_appli_travaux_mro/web_admin/screens/offres_list_page.dart';
import 'package:charter_appli_travaux_mro/web_admin/screens/reservations_list_page.dart';
import 'package:charter_appli_travaux_mro/web_admin/screens/review_list_page.dart';
import 'package:charter_appli_travaux_mro/web_admin/screens/user_list_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:charter_appli_travaux_mro/web_admin/screens/admin_conversations_screen.dart';

import '../../utils/appStrings.dart';
import '../../view/login_screen.dart';
import '../../view/services/admin_dashboard_service.dart';

enum ReservationType { all, offer, standard }

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  ReservationType _reservationType = ReservationType.all;
  final AdminDashboardService _adminDashboardService = AdminDashboardService();
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BF853),
        title: const Text('Tableau de bord',
            style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: _deconnexionEtRedirection,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 50.0),
                    child: Image(
                      image: AssetImage(AppStrings.cheminLogo),
                    ),
                  ),
                ),
                const Text(
                  'Statistiques',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  child: const Text("Conversations avec les clients"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const AdminConversationsScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                FutureBuilder(
                  future: Future.wait([
                    _adminDashboardService.getNombreTotalUtilisateurs(),
                    _adminDashboardService.getNombreTotalAvis(),
                    _adminDashboardService.getNombreTotalReservations(),
                    _adminDashboardService.getNombreTotalOffres(),
                  ]),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<int>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    int totalUtilisateurs = snapshot.data![0];
                    int totalAvis = snapshot.data![1];
                    int totalReservations = snapshot.data![2];
                    int totalOffres = snapshot.data![3];

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard(context, 'Utilisateurs',
                            totalUtilisateurs, Colors.blue, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserListPage()),
                          );
                        }),
                        _buildStatCard(context, 'Avis', totalAvis, Colors.red,
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ReviewsListPage()),
                          );
                        }),
                        _buildStatCard(context, 'Réservations',
                            totalReservations, Colors.green, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ReservationsListPage()),
                          );
                        }),
                        _buildStatCard(context, 'Offres Charter', totalOffres,
                            const Color.fromARGB(255, 200, 54, 244), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OffresListPage()),
                          );
                        }),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Réservations par mois',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Text('Type de réservation : '),
                    Radio(
                      value: ReservationType.all,
                      groupValue: _reservationType,
                      onChanged: (ReservationType? value) {
                        setState(() {
                          _reservationType = value!;
                        });
                      },
                    ),
                    Text('Toutes'),
                    Radio(
                      value: ReservationType.offer,
                      groupValue: _reservationType,
                      onChanged: (ReservationType? value) {
                        setState(() {
                          _reservationType = value!;
                        });
                      },
                    ),
                    Text('Avec offre'),
                    Radio(
                      value: ReservationType.standard,
                      groupValue: _reservationType,
                      onChanged: (ReservationType? value) {
                        setState(() {
                          _reservationType = value!;
                        });
                      },
                    ),
                    Text('Standard'),
                  ],
                ),
                SizedBox(
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
      child: SizedBox(
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
                            builder: (context) => const UserListPage()));
                    break;
                  case 'Avis':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReviewsListPage()));
                    break;
                  case 'Réservations':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ReservationsListPage()));
                    break;
                  case 'Offres Charter':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OffresListPage()));
                    break;
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    value.toString(),
                    style: const TextStyle(
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
    Future<List<int>> Function()? getReservations;
    switch (_reservationType) {
      case ReservationType.all:
        getReservations = _adminDashboardService.getReservationsParMois;
        break;
      case ReservationType.offer:
        getReservations =
            _adminDashboardService.getReservationsAvecOffreParMois;
        break;
      case ReservationType.standard:
        getReservations = _adminDashboardService.getReservationsStandardParMois;
        break;
    }

    return FutureBuilder(
      future: getReservations!(),
      builder: (context, snapshot) {
        // Si les données sont en train de charger
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        // Si une erreur s'est produite
        if (snapshot.hasError) {
          return Text(
            'Une erreur est survenue lors du chargement des données',
            style: TextStyle(color: Colors.red),
          );
        }

        // Si les données sont chargées
        List<int>? reservationsParMois = snapshot.data;
        List<FlSpot> spots = [];
        for (int i = 0; i < reservationsParMois!.length; i++) {
          spots.add(FlSpot(i.toDouble(), reservationsParMois[i].toDouble()));
        }

        return LineChart(
          LineChartData(
            minX: 0,
            maxX: 11,
            minY: 0,
            maxY: reservationsParMois
                .reduce((curr, next) => curr > next ? curr : next)
                .toDouble(), // Mettre à jour maxY avec le nombre de réservations le plus élevé
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                colors: [
                  const Color(0xFF7BF853),
                ],
                dotData: FlDotData(show: false),
                belowBarData:
                    BarAreaData(show: true, colors: [const Color(0x227BF853)]),
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
      },
    );
  }

  Future<void> _deconnexionEtRedirection() async {
    await userService.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) =>
          false, // Cette condition permet de supprimer toutes les routes en dessous de la nouvelle route
    );
  }
}
