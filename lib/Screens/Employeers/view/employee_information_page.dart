part of '../employee_information.dart';

class EmployeeInformation extends StatefulWidget {
  const EmployeeInformation();

  @override
  State<EmployeeInformation> createState() => _EmployeeInformationState();
}

class _EmployeeInformationState extends State<EmployeeInformation> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmployeerBloc>(
      create: (context) => EmployeerBloc(),
      child: BlocBuilder<EmployeerBloc, EmployeerState>(
      buildWhen: (curr, prev) => curr is EmployeerInitial && curr.screenState != EmployerScreenState.extendedReady,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.all(10),
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
                      child: SvgPicture.asset(
                        'assets/icons/back.svg',
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      LocaleKeys.profileScreen_settings_family_consultation.tr(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                  )
                ],
              ),
            ),
            body: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              margin: const EdgeInsets.only(left: 16, right: 16),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    dynamicBody(context, state as EmployeerInitial),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget dynamicBody(BuildContext context, EmployeerInitial state) {
    switch (state.screenState) {
      case EmployerScreenState.preload:
        context.read<EmployeerBloc>().add(const LoadDataEvent());
        return waitBox(Theme.of(context).colorScheme.primary);
      case EmployerScreenState.error:
        return errorBox(Theme.of(context).colorScheme.secondary);
      case EmployerScreenState.extendedReady:
      case EmployerScreenState.ready:
        return showOurTeam(context, state);
      default:
        return Container();
    }
  }

  Widget showOurTeam(BuildContext context, EmployeerInitial state) {
    List<Widget> list = [];

    for (final items in state.employerList) {
      list.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            items.position,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 19,
              color: const Color(0xFF767676),
            ),
          ),
        ),
      );

      for (final item in items.items) {
        list.add(const SizedBox(height: 20));
        list.add(peopleCard(context, item: item));
        list.add(const SizedBox(height: 20));
        list.add(
          const Divider(
            color: Color(0xFFDCDCDC),
            thickness: 1,
            height: 20,
          ),
        );
      }
    }
    list.removeLast();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget waitBox(Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget errorBox(Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.entering_recoveryBy_error.tr(),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget peopleCard(BuildContext buildContext, {required PeopleCard item}) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 130,
                height: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: displayPhotoOrVideo(
                    buildContext,
                    item.image.toString(),
                    items: [item.image.toString()],
                    initPage: 0,
                    photoOwnerId: item.id,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    expandedPeopleCard(context, item: item),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            print('Description: ${item.description}');

                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true, 
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return FractionallySizedBox(
                                  heightFactor: 0.5, // Модальное окно занимает 50% высоты экрана
                                  child: StatefulBuilder(
                                  builder: (BuildContext context, void Function(void Function()) setState) {
                                    return Container(
                                      alignment: Alignment.topCenter,
decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(12),
                                                        topRight: Radius.circular(12),
                                                      ),
                                                    ),
                                        clipBehavior: Clip.antiAliasWithSaveLayer,

                                      child: Material(
                                        color: Colors.transparent,
                                        child: SafeArea(
                                          child: SingleChildScrollView(
                                            child:  BlocProvider(
                                                create: (context) => EmployeerBloc(),
                                                child: BlocBuilder<EmployeerBloc, EmployeerState>(
                                                builder: (context, state) {
                                                  state as EmployeerInitial;
                                                  switch(state.screenState)
                                      {
                                                      case EmployerScreenState.preload:
                                                        context.read<EmployeerBloc>().add(
                                                            LoadSelectedDataEvent(id: item.id)
                                                        );
                                                        return waitBox(Theme.of(context).colorScheme.secondary);
                                                      case EmployerScreenState.error:
                                                        return errorBox(Theme.of(context).colorScheme.secondary);
                                                      default:
                                                  return Container(
                                                    padding: const EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(12),
                                                        topRight: Radius.circular(12),
                                                      ),
                                                    ),
                                                    child: SafeArea(
                                                      child: SingleChildScrollView(
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                item.name,
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 24,
                                                                  color: Colors.black
                                                                ),
                                                              ),
                                                              const SizedBox(height: 10),
                                                              Text(
                                                                item.workPosition,
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 18,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 20),
                                                              if (item.price != null)
                                                              Text(
                                                                LocaleKeys.profileScreen_settings_price.tr() + " - ${item.price.toString()}₽",
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 18,
                                                                  color: Colors.grey,
                                                                ),
                                                              ),
                                                              const SizedBox(height: 20),
                                                              if (item.phone != null)
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    
                                                                   Clipboard.setData(ClipboardData(text: item.phone!));
                                                    showDialog(
                                                  
                                                        barrierColor: Colors.transparent,
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          Future.delayed(const Duration(seconds: 1), () {
                                                            Navigator.of(context).pop(true);
                                                          });
                                                          return AlertDialog(
                                                            surfaceTintColor: Colors.transparent,
                                                            backgroundColor: Colors.white,
                                                            shadowColor: Colors.transparent,
                                                            alignment: Alignment.center,
                                                            contentPadding: EdgeInsets.all(10),
                                                            content:  Text(LocaleKeys.profileScreen_settings_phone_copied.tr(), textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.black, height: 1),),
                                                          );
                                                        },
                                                      );
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(Icons.phone, color: Theme.of(context).colorScheme.secondary),
                                                                      const SizedBox(width: 10),
                                                                      Text(
                                                                        item.phone!,
                                                                        style: TextStyle(
                                                                          color:  Theme.of(context).colorScheme.secondary,
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              const SizedBox(height: 20),

                                                              _descriptionWidget(context, item: state.selectedPeopleItem ?? item),
                                                              const SizedBox(height: 20),
                                                              if (item.url != null)
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    _launchInBrowser(item.url!);
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                     Icon(Icons.link, color: Theme.of(context).colorScheme.secondary),
                                                                      const SizedBox(width: 10),
                                                                      Text(
                                                                        item.url!,
                                                                        style:  TextStyle(
                                                                          color: Theme.of(context).colorScheme.secondary,
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                  }
                                                }
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );}
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 140,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              LocaleKeys.user_more.tr(),
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _descriptionWidget(BuildContext context, {required PeopleCard item}){
     return Visibility(
            visible: item.description != null,
            child: Column(
              children: [
                Text(
                  item.description ?? "", //item.price.toString(),
                  textDirection: TextDirection.ltr,
                  maxLines: 50,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    height: 1.4,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            )
        );
  }

  Widget expandedPeopleCard(BuildContext context, {required PeopleCard item}) {
    return SizedBox(
      height: 150,
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: Colors.black)),
            Text(item.workPosition, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}