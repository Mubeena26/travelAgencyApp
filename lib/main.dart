import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_project/features/screens/dashboard.dart';
import 'package:admin_project/features/bloc/tour_bloc.dart'; // Import your Bloc
import 'package:admin_project/features/tour/services/firestore_services.dart'; // Import your FirestoreServices
import 'features/tour/services/firebase_options.dart';

var cloudinary = Cloudinary.fromStringUrl(
    'cloudinary://351541992828455:SZZPcZ5-iV2hqaoNalu1lcDyFTk@dbgvn6kup');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreServices = FirestoreServices();

    return BlocProvider(
      create: (context) => TourBloc(firestoreServices),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Dashboard(),
      ),
    );
  }
}
