import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_bloc_firebase/features/auth/presentation/components/my_text_field.dart';
import 'package:sns_bloc_firebase/features/profile/domain/entities/profile_user.dart';
import 'package:sns_bloc_firebase/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:sns_bloc_firebase/features/profile/presentation/cubits/profile_states.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser profileUser;
  const EditProfilePage({super.key, required this.profileUser});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  PlatformFile? imagePickedFile;
  Uint8List? webImage;
  final bioTextController = TextEditingController();
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  void uploadProfile() async {
    final profileCubit = context.read<ProfileCubit>();
    final String uid = widget.profileUser.uid;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;
    final String? newBio =
        bioTextController.text.isNotEmpty ? bioTextController.text : null;
    if (imagePickedFile != null || newBio != null) {
      profileCubit.updateProfile(
        uid: uid,
        bio: newBio,
        imageMobilePath: imageMobilePath,
        imageWebBytes: imageWebBytes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(builder: (context, state) {
      if (state is ProfileLoading) {
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text("Uploading..."),
              ],
            ),
          ),
        );
      } else {
        return buildEditPage();
      }
    }, listener: (context, state) {
      if (state is ProfileLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Widget buildEditPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: uploadProfile, icon: const Icon(Icons.upload))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.hardEdge,
                child: (!kIsWeb && imagePickedFile != null)
                  ? Image.file(
                      File(imagePickedFile!.path!),
                      fit: BoxFit.cover
                    )
                  :
                  (kIsWeb && webImage != null)
                    ? Image.memory(webImage!)
                    :
                    CachedNetworkImage(
                      imageUrl: widget.profileUser.profileImageUrl,
                      placeholder: (context, url) => 
                        const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary
                      ),
                      imageBuilder: (context, imageProvider) => 
                        Image(
                          image: imageProvider,
                          fit: BoxFit.cover,),
                    )
              ),
            ),
            const SizedBox(height: 24,),
            Center(
              child: MaterialButton(
                onPressed: pickImage,
                color: Colors.blue,
                child: const Text("Pick Image"),
              ),
            ),
            const Text("Bio"),
            const SizedBox(
              height: 24,
            ),
            MyTextField(
                controller: bioTextController,
                hintText: widget.profileUser.bio,
                obscureText: false)
          ],
        ),
      ),
    );
  }
}
