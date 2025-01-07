import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iotproject/util/smart_devices_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  // List smart devices
  List mySmartDevices = [
    // [ smartDeviceName, iconPath, powerStatus]
    ["Lampu", "lib/images/light.png", true],
    ["AC", "lib/images/air-conditioner.png", false],
    ["Kipas", "lib/images/fan.png", false],
    ["TV", "lib/images/tv.png", false],
  ];

  final databaseReference = FirebaseDatabase.instance.ref();
  bool lampuStatus = false; // Status lampu dari Firebase

  @override
  void initState() {
    super.initState();
    _fetchLampuStatus();
  }

  // Fetch lampu status from Firebase
  void _fetchLampuStatus() {
    databaseReference.child('devices/Lampu/status').onValue.listen((event) {
      final bool status = event.snapshot.value as bool;
      setState(() {
        lampuStatus = status;
      });
    });
  }

  void powerSwitchChanged(bool value, int index) {
    setState(() {
      mySmartDevices[index][2] = value;
    });

    databaseReference.child("devices/${mySmartDevices[index][0]}").set({
      'status': value,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom app bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu icon
                  Image.asset(
                    'lib/images/app.png',
                    height: 45,
                    color: Colors.grey[800],
                  ),
                  // Account icon
                  Icon(
                    Icons.person,
                    size: 45,
                    color: Colors.grey[800],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Welcome home with Lampu status
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat Datang,",
                        style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                      ),
                      Text(
                        "RAGET",
                        style: GoogleFonts.bebasNeue(
                          fontSize: 72,
                        ),
                      ),
                    ],
                  ),
                  // Lampu status
                  Column(
                    children: [
                      Text(
                        "Lampu",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        lampuStatus ? "Hidup" : "Mati",
                        style: TextStyle(
                          fontSize: 18,
                          color: lampuStatus ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Divider(
                color: Colors.grey[800],
                thickness: 1,
              ),
            ),
            const SizedBox(height: 25),
            // Smart devices
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                "Smart Devices",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: mySmartDevices.length,
                padding: EdgeInsets.all(25),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.3,
                ),
                itemBuilder: (context, index) {
                  return SmartDevicesBox(
                    smartDeviceName: mySmartDevices[index][0],
                    iconPath: mySmartDevices[index][1],
                    powerOn: mySmartDevices[index][2],
                    onChanged: (value) => powerSwitchChanged(value, index),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
