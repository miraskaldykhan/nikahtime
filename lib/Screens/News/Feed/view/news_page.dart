part of '../news.dart';



class NewsScreen extends StatefulWidget {
  NewsScreen();


  @override
  State<NewsScreen> createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen>
    with TickerProviderStateMixin {

  TextEditingController _textEditingController = TextEditingController();

  bool showSimpleAppBar = true;
  bool show = false;
  int lastBuildItemIndex = 0;

  final _scrollController = ScrollController();

  @override
  void initState()
  {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose()
  {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll()
  {
    if((context.read<NewsBloc>().state as NewsInitial).items.length > 10){ ///TODO: костыль
      if(lastBuildItemIndex + 2 == (context.read<NewsBloc>().state as NewsInitial).items.length)
      {
        context.read<NewsBloc>().add(const LoadNews());
        lastBuildItemIndex = 0;
      }
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: showSimpleAppBar ? simpleAppBarWithSearch(
        context,
        onSearchAction: (){
          setState(() {
            showSimpleAppBar = false;
          });
        }
      ) : searchAppBar(
        context,
        textEditingController: _textEditingController,
        onBackAction: (){
          context.read<NewsBloc>().add(const SetNewSearchValue());
          setState(() {
            showSimpleAppBar = true;
          });
        },
        onClearAction: (){
          setState(() {
            _textEditingController.text = "";
          });
        },
        onSubmitAction: (value){
          context.read<NewsBloc>().add(SetNewSearchValue(searchValue: value));
        }
      ),
      body: Center(
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (BuildContext context, state) {
            state as NewsInitial;
            if(state.screenState == NewsScreenStateEnum.preload)
            {
              context.read<NewsBloc>().add(const LoadNews());

              return newsListWaitBox(Theme.of(context).primaryColor);
            }

            return bodyWidget(context, state);
          },
        ),
      ),
    );
  }




  Widget bodyWidget(BuildContext context, NewsInitial state){
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {

        lastBuildItemIndex = index;

        if(index == state.items.length - 1)
        {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              newsItems(context, item: state.items[index]),
              const SizedBox(height: 12,),
              (state.screenState == NewsScreenStateEnum.noMoreItem) ? Container() : const CircularProgressIndicator()
            ],
          );
        }

        return newsItems(context, item: state.items[index]);
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 16),
      itemCount: state.items.length,
      padding: const EdgeInsets.only( top: 16, bottom: 16),
      controller: _scrollController,
    );
  }

  Widget newsItems(BuildContext context, {required NewsItem item})
  {
    return Container(
       padding: const EdgeInsets.only(top:10, bottom: 10, right: 16, left: 16),
              width: double.infinity,
              decoration:  BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.rectangle,
                boxShadow:[
          BoxShadow(
                color: Color.fromRGBO(99, 99, 99, 0.2),
                blurRadius: 8,
                spreadRadius: 0,
                offset: Offset(
                   0,
                   2,
                ),
             ),
             
                ],
              ),
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => NewsItemFullScreen(
                    id: item.id ?? 0,
                    likeAction: (){
                      context.read<NewsBloc>().add(ToggleLike(id: item.id ?? 0));
                    }
                  ),
                  transitionDuration: const Duration(seconds: 0),
                )
              ).then((value) => context.read<NewsBloc>().add(MakeSeen(id: item.id ?? 0)));
            },
            child: Container(
             
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (item.title ?? ""),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: const Color.fromRGBO(0, 0, 0, 0.87),
                              ),
                            ),
                            const SizedBox(height: 2,),
                            Text(
                              formatDate(item.publishDate ?? ""),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: const Color.fromRGBO(0, 0, 0, 0.38),
                              ),
                            )
                            
                          ],
                        )
                      ),
                      /*Flexible(
                        flex: 1,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: IconDecoration(),
                          child: IconButton(
                            splashRadius: 1,
                            iconSize: 20.0,
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(
                              Icons.more_vert,
                              color: Color.fromARGB(255, 117, 116, 115),
                            ),
                            onPressed: () {
          
                            }),
                        ),
                      )*/
          
                      Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       const SizedBox(width: 15,),
                      // Row(
                      //   children: [
                      //     button(
                      //       iconData: MainPageCustomIcon.message,
                      //       iconColor: const Color(0xff1dc3a5),
                      //       value: item.commentsCount ?? 0,
                      //       action: (){
                      //         Navigator.push(
                      //             context,
                      //             PageRouteBuilder(
                      //               pageBuilder: (_, __, ___) => NewsItemFullScreen(
                      //                 id: item.id ?? 0,
                      //                 startFromCommentaries: true,
                      //                 likeAction: (){
                      //                   context.read<NewsBloc>().add(ToggleLike(id: item.id ?? 0));
                      //                 }
                      //               ),
                      //               transitionDuration: const Duration(seconds: 0),
                      //             )
                      //         ).then((value) => context.read<NewsBloc>().add(MakeSeen(id: item.id ?? 0)));
                      //       }
                      //     ),

                      //   ],
                      // ),
                      //  const SizedBox(width: 12,),

                     
                      
                    ],
                  )
                    ],
                  ),
                  const SizedBox(height: 8,),
                  Flexible(
                    flex: 1,
                    child: Text(
                      (item.shortDescription ?? ""),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.5,
                        color: const Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                  ),
                  (item.image == null) ? Container() : Column(
                    children: [
                      const SizedBox(height: 16,),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius:
                          BorderRadius.all(Radius.circular(12)),
                          color: Color.fromARGB(255, 236, 235, 235),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 350,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: displayPhotoOrVideo(this.context,
                            item.image!,
                            items: [item.image!],
                            initPage: 0,
                            photoOwnerId: item.id
                          ),
                        )
                      ),
                      
                      const SizedBox(height: 10,),
                    ],
                  ),
                  
                  // SizedBox(
                  //   width: double.infinity,
                  //   height: 40,
                  //   child: Stack(
                  //     children: [
                  //       Positioned.fill(
                  //         child: Image.asset(
                  //           "assets/icons/pattern.png",
                  //           repeat: ImageRepeat.repeat,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              
              Expanded(
                child: SizedBox(
                          width: double.infinity,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: GradientBoxBorder (gradient:  LinearGradient(colors:[ Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]), width: 2)
                            ),
                            child: GestureDetector(
                              child: Center(
                                child: Text(
                                  LocaleKeys.news_read.tr(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => NewsItemFullScreen(
                                        id: item.id ?? 0,
                                        likeAction: (){
                                          context.read<NewsBloc>().add(ToggleLike(id: item.id ?? 0));
                                        }
                                      ),
                                      transitionDuration: const Duration(seconds: 0),
                                    )
                                ).then((value) => context.read<NewsBloc>().add(MakeSeen(id: item.id ?? 0)));
                              }
                            ),
                          ),
                        ),
              ),
              SizedBox(width: 10,),
                      Container(
                        width: 40,
                        height: 40,
                        padding: EdgeInsets.only(top: 2),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(12.0),
                           border: GradientBoxBorder (gradient:  LinearGradient(colors:[ Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]), width: 2),
                        ),
                        child: button(
                              iconData: MenuIcons.favorite,
                              iconColor: (item.inFavourite == true) ? Theme.of(context).colorScheme.secondary : Colors.black12,
                              backgroundColor: (item.inFavourite == true) ? const Color(0xffffe0de) : Colors.white,
                              value: 0,
                              action: (){
                                context.read<NewsBloc>().add(ToggleLike(id: item.id ?? 0));
                              },
                            ),
                      ),
                      
            ],
          ),
          SizedBox(height: 14,),
            Row( 
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                  button(
                              iconData: MenuIcons.chat ,
                              iconColor: Theme.of(context).colorScheme.secondary,
                              backgroundColor: (item.inFavourite == true) ? const Color(0xffffe0de) : Colors.white,
                              value: item.commentsCount ?? 0,
                            ),
                       const SizedBox(width: 12,),
                 button(
                              iconData: MenuIcons.favorite ,
                              iconColor: Theme.of(context).colorScheme.secondary,
                              backgroundColor: (item.inFavourite == true) ? const Color(0xffffe0de) : Colors.white,
                              value: item.likesCount ?? 0,
                            ),
                       const SizedBox(width: 12,),
          
                      button(
                        iconData: Icons.remove_red_eye,
                        iconColor: Theme.of(context).colorScheme.secondary,
                        backgroundColor: Colors.white,
                        value: item.viewsCount ?? 0,
                        disableShadow: true,
                        showZero: true
                      ), 
              ],
            )      
        ],

      ),
    );
  }



}