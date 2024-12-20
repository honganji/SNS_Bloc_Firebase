import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_bloc_firebase/features/auth/data/firebase_auth_repo.dart';
import 'package:sns_bloc_firebase/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:sns_bloc_firebase/features/auth/presentation/cubits/auth_states.dart';
import 'package:sns_bloc_firebase/features/auth/presentation/pages/auth_page.dart';
import 'package:sns_bloc_firebase/features/home/presentation/pages/home_page.dart';
import 'package:sns_bloc_firebase/features/post/data/firebase_post_repo.dart';
import 'package:sns_bloc_firebase/features/post/presentation/cubits/post_cubit.dart';
import 'package:sns_bloc_firebase/features/profile/data/firebase_profile_repo.dart';
import 'package:sns_bloc_firebase/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:sns_bloc_firebase/features/search/firebase_search_repo.dart';
import 'package:sns_bloc_firebase/features/search/presentation/cubits/search_cubit.dart';
import 'package:sns_bloc_firebase/features/storage/data/firebase_storage_repo.dart';
import 'package:sns_bloc_firebase/themes/dark_mode.dart';
import 'package:sns_bloc_firebase/themes/light_mode.dart';
import 'package:sns_bloc_firebase/themes/theme_cubit.dart';

/*
  APP - Root Level

  Repositories: For the database
    - firebase
  
  Bloc Providers: For state management
    - auth
    - profile
    - post
    - search
    - theme
  
  Check Auth State
    - unauthenticated -> auth page (login/register)
    - authenticated -> home page
*/

class MainApp extends StatelessWidget {
  final firebaseAuthRepo = FirebaseAuthRepo();
  final firebaseProfileRepo = FirebaseProfileRepo();
  final firebaseStorageRepo = FirebaseStorageRepo();
  final firebasePostRepo = FirebasePostRepo();
  final firebaseSearchRepo = FirebaseSearchRepo();
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return BlocProvider(
    //     create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
    //     child: );
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: firebaseProfileRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepo: firebasePostRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(searchRepo: firebaseSearchRepo),
        ),
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: currentTheme,
          home:
              BlocConsumer<AuthCubit, AuthState>(builder: (context, authState) {
            // TODO remove
            print(authState);
            if (authState is Unauthenticated) {
              return const AuthPage();
            }

            if (authState is Authenticated) {
              return const HomePage();
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }, listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          }),
        ),
      ),
    );
  }
}
