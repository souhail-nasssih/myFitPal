import 'package:flutter/material.dart';
import 'package:myfitpal/helpers/helpers.dart';
import 'package:myfitpal/service/coach/planning_service.dart';
import 'package:table_calendar/table_calendar.dart';

class CoachPlanningPage extends StatefulWidget {
  const CoachPlanningPage({super.key});

  @override
  _CoachPlanningPageState createState() => _CoachPlanningPageState();
}

class _CoachPlanningPageState extends State<CoachPlanningPage> {
  DateTime _selectedDay = DateTime.now();
  final Map<DateTime, List<Map<String, String>>> _workHours = {};
  final PlanningService _planningService = PlanningService();

  @override
  void initState() {
    super.initState();
    _fetchPlanning(); // Charger les heures dès le départ
  }

  Future<void> _fetchPlanning() async {
    List<Map<String, String>> planning =
        await _planningService.fetchPlanning(_selectedDay);
    _workHours[_selectedDay] = planning;
    setState(
        () {}); // Mettre à jour l'interface après avoir récupéré les données
  }

  Future<void> _refresh() async {
    await _fetchPlanning(); // Action lors du glissement vers le bas
  }

  Future<void> _selectTimeRange(BuildContext context, DateTime day) async {
    TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );

    if (startTime == null) return;

    TimeOfDay? endTime = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: startTime.hour + 1, minute: startTime.minute),
    );

    if (endTime == null) return;

    String formattedTimeRange =
        'De ${startTime.format(context)} à ${endTime.format(context)}';

    await _planningService.savePlanning(day, formattedTimeRange);
    _fetchPlanning(); // Met à jour la liste après l'enregistrement
  }

  Future<void> _updatePlanning(String id) async {
    TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );

    if (startTime == null) return;

    TimeOfDay? endTime = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: startTime.hour + 1, minute: startTime.minute),
    );

    if (endTime == null) return;

    String formattedTimeRange =
        'De ${startTime.format(context)} à ${endTime.format(context)}';

    await _planningService.updatePlanning(id, formattedTimeRange);
    _fetchPlanning(); // Met à jour la liste après la modification
  }

  Future<void> _deletePlanning(String id) async {
    await _planningService.deletePlanning(id);
    _fetchPlanning(); // Met à jour la liste après la suppression
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Planning de Travail',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorsHelper.colorBlueText,
        centerTitle: true,
        iconTheme:
            const IconThemeData(color: Colors.white), // Changez la couleur ici
      ),
      body: RefreshIndicator(
        onRefresh: _refresh, // Action lors du glissement vers le bas
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
              child: TableCalendar(
                focusedDay: _selectedDay,
                firstDay: DateTime(2022),
                lastDay: DateTime(2030),
                calendarFormat: CalendarFormat.week,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _fetchPlanning(); // Récupérer les heures lorsque le jour est sélectionné
                  });
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(
                    color: ColorsHelper.colorBlueText,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: const Color.fromARGB(255, 146, 185, 249)
                        .withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Heures sélectionnées pour ${_selectedDay.toLocal().toString().split(' ')[0]} :",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _workHours[_selectedDay]?.length ?? 0,
                        itemBuilder: (context, index) {
                          final plan = _workHours[_selectedDay]![index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            elevation: 2,
                            child: ListTile(
                              title: Text(plan['hour']!),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        _updatePlanning(plan['id']!),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () =>
                                        _deletePlanning(plan['id']!),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment:
            Alignment.bottomRight, // Change la position du bouton flottant ici
        child: FloatingActionButton(
          onPressed: () => _selectTimeRange(context, _selectedDay),
          backgroundColor: ColorsHelper.colorBlueText,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
