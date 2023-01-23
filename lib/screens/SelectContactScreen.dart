import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hi/common/widgets/loader.dart';
import 'package:hi/feature/controller/SelectContactController.dart';
import 'package:hi/screens/ErrorScreen.dart';
import 'package:hi/utils/ColorsCustom.dart';
import 'package:lottie/lottie.dart';

class SelectContactScreen extends ConsumerStatefulWidget {
  const SelectContactScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectContactScreen> createState() =>
      _SelectContactScreenState();
}

class _SelectContactScreenState extends ConsumerState<SelectContactScreen>
    with SingleTickerProviderStateMixin {
  bool startAnimation = false;
  final List<Color> colorGradiant = [];
  final random = Random();
  bool search = true;
  final _searchController = TextEditingController();
  var onSearchList = [];
  List<Contact> cntList = [];

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
    addColorToArray();
  }

  void addColorToArray() {
    colorGradiant.add(const Color(0x33a18cd1));
    colorGradiant.add(const Color(0x33fbc2eb));
    colorGradiant.add(const Color(0x33f6d365));
    colorGradiant.add(const Color(0x33a1c4fd));
    colorGradiant.add(const Color(0x3396e6a1));
    colorGradiant.add(const Color(0x33f093fb));
    colorGradiant.add(const Color(0x33f5576c));
    colorGradiant.add(const Color(0x334facfe));
    colorGradiant.add(const Color(0x33764ba2));
    colorGradiant.add(const Color(0x336a11cb));
    colorGradiant.add(const Color(0x33c471f5));
    colorGradiant.add(const Color(0x336f86d6));
    colorGradiant.add(const Color(0x330ba360));
    colorGradiant.add(const Color(0x33f77062));
    colorGradiant.add(const Color(0x33f09819));
    colorGradiant.add(const Color(0x338ddad5));
    colorGradiant.add(const Color(0x3304befe));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorsCustom.secondaryDark,
      appBar: AppBar(
        backgroundColor: ColorsCustom.primary,
        automaticallyImplyLeading: false,
        /*leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),*/
        title: search
            ? const Text('Select contact')
            : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      onSearchList = cntList
                          .where((element) => element.name
                              .toString()
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                  controller: _searchController,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0x3396e6a1),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          search = true;
                          _searchController.text = '';
                        });
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                    ),
                    hintText: 'Search...',
                    hintStyle:
                        const TextStyle(color: Colors.white, fontSize: 20),
                    prefixIcon:
                        const Icon(Icons.search_rounded, color: Colors.white),
                  ),
                ),
              ),
        actions: [
          search
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          search = false;
                        });
                      },
                      icon: const Icon(Icons.search_rounded),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert_rounded))
                  ],
                )
              : Container()
        ],
      ),
      body: ref.watch(getContactProvider).when(
            data: (contactList) {
              cntList = contactList;
              return _searchController.text.isNotEmpty && onSearchList.isEmpty
                  ? Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40, right: 40),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/no_data_found.json'),
                              const SizedBox(height: 20),
                              Text(
                                'No Data Found',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.righteous(
                                    color: Colors.greenAccent,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _searchController.text.isNotEmpty
                          ? onSearchList.length
                          : contactList.length,
                      itemBuilder: (context, index) {
                        final contact = _searchController.text.isNotEmpty
                            ? onSearchList[index]
                            : contactList[index];
                        String? number;
                        for (int i = 0; i < contact.phones.length; i++) {
                          number = contact.phones[i]!.number;
                        }
                        return InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            selectContact(ref, contact, context);
                          },
                          child: AnimatedContainer(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  colorGradiant[random.nextInt(15)],
                                  colorGradiant[random.nextInt(15)],
                                ],
                              ),
                            ),
                            curve: Curves.easeInOutQuad,
                            duration:
                                Duration(milliseconds: 300 + (index * 100)),
                            transform: Matrix4.translationValues(
                                startAnimation ? 0 : width, 0, 0),
                            child: ListTile(
                              title: Text(contact.displayName,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              subtitle: Text(
                                _searchController.text.isNotEmpty
                                    ? number ?? 'number is empty'
                                    : number ?? 'number is empty',
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: contact.photo == null
                                  ? const CircleAvatar(
                                      backgroundImage:
                                          AssetImage('assets/avatar.jpg'),
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          MemoryImage(contact.photo!),
                                    ),
                            ),
                          ),
                        );
                      },
                    );
            },
            error: (error, stackTrace) => ErrorScreen(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
