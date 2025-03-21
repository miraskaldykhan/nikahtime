import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:flutter_svg/svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
//import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Screens/Anketes/anketes.dart';
import 'package:untitled/Screens/Favorites/iLiked.dart';
import 'package:untitled/Screens/Payment/payment.dart';
import 'package:untitled/Screens/Profile/bloc/profile_bloc.dart';
import 'package:untitled/components/widgets/image_viewer.dart';
import 'package:untitled/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Screens/Favorites/favorites_visited_me.dart';
import 'package:untitled/components/widgets/create_chat.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/menu_icons_icons.dart';

import '../../components/widgets/likeAnimation.dart';

class FavoriteMainPageScreen extends StatefulWidget {
  const FavoriteMainPageScreen(this.userProfileData, {super.key});

  final UserProfileData userProfileData;

  @override
  State<FavoriteMainPageScreen> createState() => _FavoriteMainPageScreenState();
}

class _FavoriteMainPageScreenState extends State<FavoriteMainPageScreen> {
  bool show = false;
  int _currentPage = 1; // Added to track current page in carousel

  @override
  void initState() {
    sendAnketesRequest();
    super.initState();
    _scrollController.addListener(_onScroll);
    //MyTracker.trackEvent("Watch Favourites page", {});
  }

  final _scrollController = ScrollController();
  int lastBuildItemIndex = 0;

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (anketas.length > 10) {
      if (lastBuildItemIndex + 2 >= anketas.length) {
        sendAnketesRequest();
        lastBuildItemIndex = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ProfileInitial state = context.read<ProfileBloc>().state as ProfileInitial;
    bool needPay = state.userProfileData?.userTariff == null;

    if (needPay) {
      return Center(child: paymentStub(context));
    }

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 70,
          ),
          Builder(builder: (context) {
            if (show) {
              show = false;
              return LikeAnimationWidget(true);
            } else {
              return const SizedBox.shrink();
            }
          }),
          CustomHeader(widget.userProfileData, onPageChange: _onPageChange, currentPage: _currentPage,), // Pass a function to change page

          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              child: _buildPageContent()),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent() {
    if (_currentPage == 0) {
      return isLoadingComplete
          ? gridViewWithPhotos(context)
          : Center(
              child: waitBox(Theme.of(context).colorScheme.primary),
            );
    } else if (_currentPage == 1) {
      return ILikedScreen(widget.userProfileData);
    } else if (_currentPage == 2) {
      return PeopleWhoVizitedMeScreen(widget.userProfileData);
    } else {
      return const SizedBox.shrink();
    }
  }

  void _onPageChange(int pageIndex) {
    setState(() {
      _currentPage = pageIndex; 
    });
  }

  Widget gridViewWithPhotos(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (BuildContext context, int index) {
        lastBuildItemIndex = index;
        debugPrint(index.toString());
        return itemWithBottomNavigationBar(anketas[index]);
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1.28,
        crossAxisCount: 1,
        mainAxisSpacing: 20,
        crossAxisSpacing: 4,
      ),
      controller: _scrollController,
      itemCount: anketas.length,
    );
  }

    Widget itemWithBottomNavigationBar(UserProfileData item) {
      return  Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingleUser(anketa: item),
                    )).then((_) => {setState(() {})});
              },
              child: Container(
                  margin: EdgeInsets.only(top:10),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    color: Color.fromARGB(255, 236, 235, 235),
                  ),
                  child: (item.images == null || item.images!.isEmpty)
                      ? const Icon(Icons.photo_camera,
                          color: Color.fromRGBO(230, 230, 230, 1), size: 60)
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: displayMedia(
                          context,
                          item.images![0].main.toString(),
                          items: item.images!.map((e) => e.main).toList().cast<String>(),
                          initPage: 0,
                          photoOwnerId: item.id,
                        ),
                      
                        )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Container(
                  height: 96,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff12121200),
                        Color(0xff12121280)
                      ],
                      stops: [0.0, 1.0],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      tileMode: TileMode.clamp
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(right: 20, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            CreateChat(
                                    context,
                                    widget.userProfileData.gender ?? "",
                                    widget.userProfileData.id ?? 0)
                                .createChatWithUser(item.id!);
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                                       border:  GradientBoxBorder (gradient:  LinearGradient(colors:[ Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]), width: 2),),
                            child: Icon(MenuIcons.chat,
                                color: Colors.white, size: 22),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                              anketas.remove(item);
                              NetworkService().FavoritesDeleteUserID(
                                  widget.userProfileData.accessToken!, item.id!);
                              setState(() {});
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:  GradientBoxBorder (gradient:  LinearGradient(colors:[ Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]), width: 2),
                        
                            ),
                            child: Icon( MenuIcons.favorite,
                              color: item.inFavourite ? Theme.of(context).colorScheme.primary : Colors.white, ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: SizedBox(
                width: 180,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${item.firstName ?? ""}, ${localized.plural(LocaleKeys.user_yearsCount, item.age ?? 0)}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item.city != null 
                             ? item.city!.split(',')[0] 
                             : '',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: const Color(0xffFFFFFF).withOpacity(0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
          ],
      );
    }

  bool isLoadingComplete = false;
  int page = 1;
  List<UserProfileData> anketas = [];

  Widget waitBox(Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
         CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          LocaleKeys.usersScreen_loading.tr(),
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

  sendAnketesRequest() async {
    try {
      var response = await NetworkService().getFavoriteUsers(
          accessToken: widget.userProfileData.accessToken!, page: page);
      page++;
      anketas.addAll(response.users as Iterable<UserProfileData>);

      setState(() {
        isLoadingComplete = true;
      });
    } catch (e) {
      return;
    }
  }
}




class CustomHeader extends StatefulWidget {
  final UserProfileData _userProfileData;
  final Function(int) onPageChange;
  final int currentPage;

  const CustomHeader(this._userProfileData,
      {Key? key, required this.onPageChange, required this.currentPage})
      : super(key: key);

  @override
  _CustomHeaderState createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
  _pageController = PageController(
  initialPage: widget.currentPage,
  viewportFraction: 0.6, 
);  }

  @override
  void didUpdateWidget(covariant CustomHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPage != widget.currentPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _pageController.jumpToPage(widget.currentPage);
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40, 
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          widget.onPageChange(index);
        },
        physics: const ClampingScrollPhysics(),
        children: [
          _buildButton(
            text: LocaleKeys.usersScreen_favorites.tr(),
            isSelected: widget.currentPage == 0,
            onTap: () => _onButtonTap(0),
          ),
          _buildButton(
            text: LocaleKeys.usersScreen_youFavorite.tr(),
            isSelected: widget.currentPage == 1,
            onTap: () => _onButtonTap(1),
          ),
          _buildButton(
            text: LocaleKeys.common_vizited_q.tr(),
            isSelected: widget.currentPage == 2,
            onTap: () => _onButtonTap(2),
          ),
        ],
      ),
    );
  }

void _onButtonTap(int index) {
  _pageController.animateToPage(
    index,
    duration: const Duration(milliseconds: 200),  
    curve: Curves.easeInOutCubic,  
  );
  widget.onPageChange(index);
}


  Widget _buildButton({
  required String text,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: 200,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeInOut, 
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ])
              : null,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    ),
  );
}

}

