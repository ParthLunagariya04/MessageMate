import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hi/Models/StatusModel.dart';
import 'package:hi/feature/controller/AuthController.dart';
import 'package:hi/feature/repositery/StatusRepository.dart';

final statusControllerProvider = Provider((ref) {
  final statusRepository = ref.read(statusRepositoryProvider);
  return StatusController(statusRepository: statusRepository, ref: ref);
});

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusController({required this.statusRepository, required this.ref});

  void addStatus(File file, BuildContext context) {
    ref.watch(userDataAuthProvider).whenData((value) {
      statusRepository.uploadStatues(
        userName: value!.name,
        profilePic: value.profilePic,
        phoneNum: value.phoneNumber,
        statuesImage: file,
        context: context,
      );
    });
  }

  Future<List<StatusModel>> getStatus(BuildContext context) async {
    List<StatusModel> status = await statusRepository.getStatues(context);
    return status;
  }
}
