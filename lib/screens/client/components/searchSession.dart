import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfitpal/screens/client/components/cardComponent/cardCoach.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchSession extends StatefulWidget {
  const SearchSession({super.key});

  @override
  _SearchSessionState createState() => _SearchSessionState();
}

class _SearchSessionState extends State<SearchSession> {
  DateTime _selectedDay = DateTime.now();
  TimeOfDay? _selectedTime;
  DateTime? _combinedDateTime;
  List<Map<String, dynamic>> availableCoaches = [];
  String? clientCity;

  @override
  void initState() {
    super.initState();
    _fetchClientCity(); // Récupérer la ville du client à l'initialisation
  }

  Future<void> _fetchClientCity() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(
              'clients') // Remplacez par le nom de votre collection d'utilisateurs
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          clientCity =
              userDoc['city'] ?? "rien"; // Assurez-vous que la clé existe
          print('Ville du client: $clientCity');
        });
      }
    }
  }

  void _combineDateAndTime() {
    if (_selectedTime != null) {
      _combinedDateTime = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      print('Date et heure combinées: $_combinedDateTime');
      _fetchAndPrintCoachPlanning();
    } else {
      print('Veuillez sélectionner une heure.');
    }
  }

  Future<void> _fetchAndPrintCoachPlanning() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('plannig').get();

    availableCoaches.clear();

    for (var doc in snapshot.docs) {
      String coachID = doc['coachID'];
      String date = doc['date'];

      final data = doc.data() as Map<String, dynamic>?;

      String hourRange = data != null && data.containsKey('hour')
          ? data['hour']
          : 'Heure non disponible';

      if (hourRange != 'Heure non disponible') {
        List<String> hours = hourRange.split(' à ');

        if (hours.length == 2) {
          try {
            DateTime startHour =
                DateTime.parse('${date} ${hours[0].replaceAll('De ', '')}');
            DateTime endHour = DateTime.parse('${date} ${hours[1]}');

            if (_combinedDateTime != null &&
                _combinedDateTime!.isAtOrAfter(startHour) &&
                _combinedDateTime!.isBefore(endHour)) {
              // Récupérer les détails du coach
              DocumentSnapshot coachSnapshot = await FirebaseFirestore.instance
                  .collection('coaches')
                  .doc(coachID)
                  .get();

              if (coachSnapshot.exists) {
                Map<String, dynamic> coachData =
                    coachSnapshot.data() as Map<String, dynamic>;

                // Vérifier si le coach est dans la même ville que le client
                if (coachData['city'] == clientCity) {
                  availableCoaches.add({
                    'coachID': coachID,
                    'date': date,
                    'hourRange': hourRange,
                    'fullname': coachData['fullName'] ?? 'Inconnu',
                    'pricing': coachData['pricing'] ?? 'Non spécifié',
                    'duration': coachData['duration'] ?? 'Non spécifié',
                    'certifications': coachData['certifications'] ?? 'Aucune',
                    'city': coachData['city'] ?? 'Non spécifiée',
                    'image': coachData['image'] ?? 'images/4.jpg',
                    'email': coachData['email'] ?? 'Non spécifié',
                    'birthday': coachData['birthday'] ?? 'Non spécifié',
                  });
                }
              }
            }
          } catch (e) {
            print('Erreur de format de date: $e');
          }
        }
      }
    }

    setState(() {});
  }

  void _previousWeek() {
    setState(() {
      _selectedDay = _selectedDay.subtract(Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _selectedDay = _selectedDay.add(Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchAndPrintCoachPlanning();
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TableCalendar(
                    focusedDay: _selectedDay,
                    firstDay: DateTime(2022),
                    lastDay: DateTime(2030),
                    calendarFormat: CalendarFormat.week,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                      });
                      _combineDateAndTime();
                    },
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    calendarStyle: CalendarStyle(
                      selectedDecoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    _selectedTime = pickedTime;
                  });
                  _combineDateAndTime();
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: Text(_selectedTime == null
                  ? 'Sélectionner une heure'
                  : 'Heure: ${_selectedTime!.format(context)}'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: availableCoaches.length,
                itemBuilder: (context, index) {
                  var planning = availableCoaches[index];
                  return ProfileCard(
                    fullname: planning['fullname']!,
                    pricing: planning['pricing']!,
                    duration: planning['duration']!,
                    certifications: planning['certifications']!,
                    city: planning['city']!,
                    image: planning['image']!,
                    email: planning['email']!,
                    birthday: '',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension DateTimeComparison on DateTime {
  bool isAtOrAfter(DateTime other) {
    return this.isAfter(other) || this.isAtSameMomentAs(other);
  }
}
