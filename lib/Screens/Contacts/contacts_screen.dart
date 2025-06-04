import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:untitled/Screens/Contacts/cubit/fetch_unregistered_contacts/unregistered_contacts_cubit.dart';
import 'package:untitled/Screens/Contacts/models/contacts.dart';
import 'package:untitled/ServiceItems/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({super.key});

  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  int selectedCount = 0;
  List<UnRegisteredContacts> contacts = [];

  bool searchIsActive = false;

  @override
  void initState() {
    BlocProvider.of<UnregisteredContactsCubit>(context)
        .getUnRegisteredContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        title: searchIsActive
            ? TextField(
                autofocus: true,
                onChanged: (value) {
                  if (contacts.isNotEmpty) {
                    BlocProvider.of<UnregisteredContactsCubit>(context)
                        .searchUnregisteredContacts(
                      searchQuery: value,
                      unregisteredContacts: contacts,
                    );
                  }
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Введите имя...",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              )
            : SizedBox(
                width: 200,
                child: Text(
                  "Пригласить",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w700),
                ),
              ),
        centerTitle: true,
        leading: Container(
          height: 40,
          width: 40,
          margin: EdgeInsets.only(left: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            border: GradientBoxBorder(
              gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary
              ]),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: SvgPicture.asset('assets/icons/back.svg',
                color: Theme.of(context).primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: searchIsActive
            ? [
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    searchIsActive = false;
                    if (contacts.isNotEmpty) {
                      BlocProvider.of<UnregisteredContactsCubit>(context)
                          .backToFullContacts(
                        unregisteredContacts: contacts,
                      );
                    }

                    setState(() {});
                  },
                )
              ]
            : [
                Container(
                  margin: EdgeInsets.only(right: 16, top: 8, bottom: 8),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    border: GradientBoxBorder(
                      gradient: LinearGradient(colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary
                      ]),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/search.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      searchIsActive = true;
                      setState(() {});
                    },
                  ),
                ),
              ],
      ),
      body: Stack(
        children: [
          BlocConsumer<UnregisteredContactsCubit, UnregisteredContactsState>(
            bloc: BlocProvider.of<UnregisteredContactsCubit>(context),
            listener: (context, state){
              if (state is UnregisteredContactsError) {
                AppNotifications.showError(message: state.errorMessage);
              }
            },
            builder: (context, state) {
              if (state is UnregisteredContactsLoading) {
                return Center(
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state is UnregisteredContactsSuccess) {
                contacts = state.unregisteredContacts;
                List<UnRegisteredContacts> contacts2 = [];
                if (state.searchWord != null) {
                  contacts2 = state.unregisteredContacts.where((contact) {
                    final nameLower = (contact.name ?? "").toLowerCase();
                    return nameLower.contains(state.searchWord!.toLowerCase());
                  }).toList();
                }
                return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  itemCount: state.searchWord == null
                      ? contacts.length
                      : contacts2.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey[300], thickness: 1),
                  itemBuilder: (context, index) {
                    return _buildContactItem(
                      state.searchWord == null
                          ? contacts[index]
                          : contacts2[index],
                    );
                  },
                );
              }
              return TextButton(
                onPressed: () {
                  BlocProvider.of<UnregisteredContactsCubit>(context)
                      .getUnRegisteredContacts();
                },
                child: Text(
                  "Попробовать занова",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              );
            },
          ),
          if (selectedCount > 0)
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () async {
                  var contact = contacts
                      .firstWhere((element) => element.isSelected == true);
                  final phone = _normalizePhone(contact.phoneNumber!);
                  final url = Uri.parse(
                      "https://wa.me/$phone?text=${Uri.encodeComponent("")}");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    AppNotifications.showError(
                        message:
                            "WhatsApp недоступен для номера ${contact.phoneNumber}");
                  }
                },
                child: Container(
                  height: 52,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary
                      ]),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      "Пригласить - $selectedCount контакта",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _normalizePhone(String raw) {
    // 1) оставляем только цифры
    String digits = raw.replaceAll(RegExp(r'\D'), '');
    // 2) если 11 цифр и начинается с 8 → делаем 7…
    if (digits.length == 11 && digits.startsWith('8')) {
      digits = '7' + digits.substring(1);
    }
    // 3) если 10 цифр → дописываем 7 спереди
    else if (digits.length == 10) {
      digits = '7' + digits;
    }
    return digits;
  }

  Widget _buildContactItem(UnRegisteredContacts contact) {
    String initials = contact.name!.length > 2
        ? contact.name!.substring(0, 2).toUpperCase()
        : contact.name!.toUpperCase();

    return GestureDetector(
      onTap: () {
        if (selectedCount == 1 && contact.isSelected == false) {
        } else {
          setState(() {
            contact.isSelected = !contact.isSelected;
            contact.isSelected ? selectedCount++ : selectedCount--;
          });
        }
      },
      child: ListTile(
        minTileHeight: 20,
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blue.shade100,
          child: Text(
            initials,
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          contact.name!,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        trailing: Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, width: 1.5),
          ),
          child: Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: contact.isSelected
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
