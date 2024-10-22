import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_bloc_firebase/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:sns_bloc_firebase/features/home/presentation/components/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: MyDrawer(),
    );
  }
}
