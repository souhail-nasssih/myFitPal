import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfitpal/auth/login_screen.dart';
import 'package:myfitpal/helpers/helpers.dart';
import 'package:myfitpal/layouts/bottom_bar.dart';
import 'package:myfitpal/screens/components/loading.dart';
import 'package:intl/intl.dart';
import 'package:myfitpal/service/client/ClientService.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late Future<Map<String, dynamic>> _clientDataFuture;
  final ClientService _clientService = ClientService();

  @override
  void initState() {
    super.initState();
    _clientDataFuture = _clientService.getClientData();
  }

  void showEditDialog(Map<String, dynamic> userData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController =
            TextEditingController(text: userData['fullName']);
        TextEditingController birthdayController = TextEditingController(
          text:
              userData['birthday'] != null && userData['birthday'] is Timestamp
                  ? formatDate(userData['birthday'])
                  : '',
        );
        TextEditingController emailController =
            TextEditingController(text: userData['email']);
        TextEditingController phoneController =
            TextEditingController(text: userData['phone']);
        TextEditingController cityController =
            TextEditingController(text: userData['city']);
        TextEditingController goalController =
            TextEditingController(text: userData['goal']);

        return AlertDialog(
          title: const Text('Edit Information'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name')),
                GestureDetector(
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: birthdayController.text.isNotEmpty
                          ? DateFormat('dd/MM/yyyy')
                              .parse(birthdayController.text)
                          : DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (selectedDate != null) {
                      birthdayController.text =
                          DateFormat('dd/MM/yyyy').format(selectedDate);
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                        controller: birthdayController,
                        decoration:
                            const InputDecoration(labelText: 'Birthday')),
                  ),
                ),
                TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email')),
                TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone')),
                TextField(
                    controller: cityController,
                    decoration: const InputDecoration(labelText: 'City')),
                TextField(
                    controller: goalController,
                    decoration: const InputDecoration(labelText: 'Goal')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await _clientService.editClientData({
                    'fullName': nameController.text,
                    'birthday': birthdayController.text.isNotEmpty
                        ? DateFormat('dd/MM/yyyy')
                            .parse(birthdayController.text)
                        : null,
                    'email': emailController.text,
                    'phone': phoneController.text,
                    'city': cityController.text,
                    'goal': goalController.text,
                  });

                  if (mounted) {
                    _scaffoldKey.currentState?.showSnackBar(
                      const SnackBar(
                          content: Text('Profile updated successfully!'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2)),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    _scaffoldKey.currentState?.showSnackBar(
                      SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          duration: const Duration(seconds: 2)),
                    );
                  }
                }

                // Rafraîchir les données
                if (mounted) {
                  setState(() {
                    _clientDataFuture = _clientService.getClientData();
                  });
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: FutureBuilder<Map<String, dynamic>>(
        future: _clientDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: FitnessLoading()));
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${snapshot.error}',
                        style:
                            const TextStyle(color: Colors.red, fontSize: 18)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _clientDataFuture = _clientService
                              .getClientData(); // Retry fetching data
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Scaffold(
                body: Center(child: Text('No user data found')));
          } else {
            final userData = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: const Text('My Profile'),
                actions: [
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'logout') {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem(
                            value: 'logout', child: Text('Logout'))
                      ];
                    },
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: ColorsHelper.colorProfil, width: 5),
                              boxShadow: const [
                                BoxShadow(
                                    color: ColorsHelper.colorProfil,
                                    blurRadius: 20,
                                    spreadRadius: 5),
                              ],
                            ),
                          ),
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('images/avatar.png'),
                            backgroundColor: Colors.transparent,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => showEditDialog(userData),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        userData['fullName'] ?? 'Unknown Name',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        userData['birthday'] != null &&
                                userData['birthday'] is Timestamp
                            ? formatDate(userData['birthday'])
                            : 'Date of birth not defined',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: const Icon(Icons.email,
                            color: ColorsHelper.colorProfil),
                        title: Text(
                          userData['email'] ?? 'Email not defined',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: const Icon(Icons.phone,
                            color: ColorsHelper.colorProfil),
                        title: Text(
                          userData['phone'] ?? 'Phone not defined',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: const Icon(Icons.location_on,
                            color: ColorsHelper.colorProfil),
                        title: Text(
                          userData['city'] ?? 'City not defined',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: const Icon(Icons.flag,
                            color: ColorsHelper.colorProfil),
                        title: Text(
                          userData['goal'] ?? 'Goal not defined',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text('Logout'),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              bottomNavigationBar: const BottomBar(
                currentIndex: 3,
              ), // Ajout de la BottomBar ici
            );
          }
        },
      ),
    );
  }
}
