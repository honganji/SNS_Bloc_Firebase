import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_bloc_firebase/features/profile/presentation/components/user_tile.dart';
import 'package:sns_bloc_firebase/features/profile/presentation/pages/profile_page.dart';
import 'package:sns_bloc_firebase/features/responsive/constrained_scaffold.dart';
import 'package:sns_bloc_firebase/features/search/presentation/cubits/search_cubit.dart';
import 'package:sns_bloc_firebase/features/search/presentation/cubits/search_states.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() {
    final query = searchController.text;
    searchCubit.searchUsers(query);
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
              hintText: "Search users...",
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary)),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(builder: (context, state) {
        if (state is SearchLoaded) {
          if (state.users.isEmpty) {
            return const Center(
              child: Text("No user found"),
            );
          }
          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return UserTile(user: user!);
            },
          );
        }
        if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is SearchError) {
          return Center(
            child: Text(state.message),
          );
        }
        return const Center(
          child: Text("Start searching for users..."),
        );
      }),
    );
  }
}
