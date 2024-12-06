import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_project/dashboard.dart';
import 'package:admin_project/bloc/tour_bloc.dart'; // Import your Bloc
import 'package:admin_project/firestore_services.dart'; // Import your FirestoreServices
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options:
          DefaultFirebaseOptions.currentPlatform); 
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
