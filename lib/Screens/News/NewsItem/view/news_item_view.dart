part of '../news_item.dart';


class NewsItemFullScreen extends StatefulWidget {
  NewsItemFullScreen({
    required this.id,
    this.startFromCommentaries = false,
    required this.likeAction
  });

  final int id;
  final Function likeAction;
  final bool startFromCommentaries;

  @override
  State<NewsItemFullScreen> createState() => NewsItemFullScreenState();
}

class NewsItemFullScreenState extends State<NewsItemFullScreen> {
  final dataKey = new GlobalKey();
  TextEditingController _textEditingController = TextEditingController();

  bool show = false;
  int lastBuildItemIndex = 0;
  late FocusNode myFocusNode;
  final _scrollController = ScrollController();
  int? answerId;

  @override
  void initState() {

    super.initState();

    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }

    myFocusNode = FocusNode();

    _scrollController.addListener((){
      if((_scrollController.position.pixels + MediaQuery.of(context).size.height) - 144 >= height){
        //debugPrint(_scrollController.position.pixels.toString()+ "    " + height.toString());
        if (show == false) {
          setState(() {
            show = true;
          });
        }
      }else{
        if(show == true){
          setState(() {
            show = false;
          });
        }
      }
    });

  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsItemBloc(id: widget.id),
      child: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: BackNavigateAppBar(context),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            return BlocBuilder<NewsItemBloc, NewsItemState>(
              builder: (BuildContext context, state) {
                state as NewsItemInitial;
                if (state.screenState == NewsItemStateEnum.preload) {
                  context.read<NewsItemBloc>().add(const LoadFullNews());
                  return singleNewsWaitBox(Theme.of(context).scaffoldBackgroundColor);
                }
                _scrollController.addListener(() {
                  if(_scrollController.position.pixels.toInt() >= _scrollController.position.maxScrollExtent.toInt() - 100)
                  {
                    if((context.read<NewsItemBloc>().state as NewsItemInitial).commentariesState == CommentariesState.ready)
                      {
                        debugPrint("MAX" + "   " + _scrollController.position.pixels.toString() + "   " + _scrollController.position.maxScrollExtent.toString());
                        context.read<NewsItemBloc>().add(const LoadCommenariesPage());
                      }
                  }
                });
                return bodyWidget(context, state);
              },
            );
          }
        ),
      ),
    ),
    );
  }



    late WebViewController _controller;
    double height = 1;

    Widget bodyWidget(BuildContext context, NewsItemInitial state) {
      return Stack(
        children: [
          CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            controller: _scrollController,
            slivers: [
              webViewNews(context, state),
              actionButtons(context, state),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 16, bottom: 10 ),
                  child: Row(
                    children: [
                      Text(
                        LocaleKeys.news_commentaries.tr(),//"Комментарии",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          //height: 1.4,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              ),
              messagesStub(context, state),
              SliverToBoxAdapter(
                child: (state.commentariesState != CommentariesState.noMoreItem) ? const Center(child: CircularProgressIndicator()) : null,
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 90
                ),
              ),
            ],
          ),
          inputText(context,
            show: show,
            onFocusChange: (value){
              if(value == false){
                if(answerId != null){
                  setState(() {
                    _textEditingController.text = "";
                    answerId = null;
                  });
                }
              }
            },
            focusNode: myFocusNode,
            onSubmitAction: (){
              context.read<NewsItemBloc>().add(
                  AddCommentary(
                      newsId: state.id, text: _textEditingController.text, commentId: answerId
                  )
              );
              setState(() {
                _textEditingController.text = "";
              });
              myFocusNode.unfocus();
            },
            textEditingController: _textEditingController
          )
        ],
      );
    }

    _launchURL(String url) async {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    }

    Widget webViewNews(BuildContext context, NewsItemInitial state)
    {
      return SliverToBoxAdapter(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: height,
          child: WebView(
            zoomEnabled: false,
            initialUrl: 'about:blank',
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              if (Platform.isIOS) {
                if (request.url.contains(RegExp(r'^http://')) 
                  || request.url.contains(RegExp(r'^https://'))
                ) {
                  _launchURL(request.url);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              } else {
                _launchURL(request.url);
                return NavigationDecision.prevent;
              }          
            },
            javascriptChannels: {
              JavascriptChannel(
                  name: 'Print',
                  onMessageReceived: (JavascriptMessage message) {
                    debugPrint(message.message);
                    final data = jsonDecode(message.message);

                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => ImageGalleryViewerScreen(
                          (data["images"] as List).map((e) => e.toString()).toList(),
                          startPage: data["selectedIndex"],
                          photoOwnerId: 0,
                        ),
                        transitionDuration: const Duration(seconds: 0),
                      ),
                    );
                  }
              )
            },
            onWebViewCreated: (WebViewController webViewController) async {
               print( Uri.dataFromString(
                 
                    (state.item?.description ?? "").replaceAll("\\\"", "\""),
                    mimeType: 'text/html',
                    encoding: Encoding.getByName('utf-8')).toString(),);
              _controller = webViewController;
              await _controller.loadUrl(
               
                Uri.dataFromString(
                    /*'<!DOCTYPE HTML><html lang="ru">'
                        '<head><meta name="viewport" content="width=device-width, initial-scale=1"><meta charset="UTF-8"/>'
                        '<style type="text/css">img{max-width: 100% !important;height: auto !important;}</style>'
                        '</head>'
                        '<body>'
                        '<h1>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</h1>'
                        '<p><i>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</i></p>'
                        '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>'
                        '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>'
                        '<p><img src="https://www.nikahtime.ru/storage/news/October2022/06_08 Оценка.jpg" alt="" /></p>'
                        '<p style="text-align: center;">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>'
                        '<p><img src="https://www.nikahtime.ru/storage/news/October2022/image_2022-09-30_15-27-01.png" alt="" /></p>'
                        '<p style="text-align: right;"></p>'
                        '<p style="text-align: right;"><b>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</b></p>'

                        '''<script type="text/javascript">
                      const resizeObserver = new ResizeObserver(entries => Resize.postMessage("height" + (entries[0].target.clientHeight).toString()))
                      resizeObserver.observe(document.body)
                      var theTarget = document.getElementsByTagName("img");
                      var images = [];
                      if (theTarget.length > 0) {
                        for (let i = 0; i < theTarget.length; i++) {
                          images.push(theTarget[i].src);
                        }
                        for (let i = 0; i < theTarget.length; i++) {
                          theTarget[i].addEventListener("click", (e) => {
                            Print.postMessage(JSON.stringify({ "images": images, "selectedIndex": i }));
                          });
                        }
                      }
                      </script>'''
                    //'<script type="text/javascript"> var theTarget = document.getElementsByTagName("img"); if (theTarget.length > 0) { for (let i = 0; i < theTarget.length; i++) { theTarget[i].addEventListener("click", (e) => { Print.postMessage(theTarget[i].src);});}}</script>'

                        '<script>const resizeObserver = new ResizeObserver(entries =>Resize.postMessage("height" + (entries[0].target.clientHeight).toString()) )resizeObserver.observe(document.body)</script>'
                        '</body>'
                        '</html>'.replaceAll("\\\"", "\""),*/
                    (state.item?.description ?? "").replaceAll("\\\"", "\""),
                    mimeType: 'text/html',
                    encoding: Encoding.getByName('utf-8')).toString(),
              );
            },
            onProgress: (int progress) {
              print('WebView is loading (progress : $progress%)');
            },
            onPageStarted: (String url) {
              print('Page started loading');
            },
           onPageFinished: (String url) async {
  await Future.delayed(const Duration(milliseconds: 10));

  String heightStr = await _controller.runJavascriptReturningResult(
    "document.documentElement.scrollHeight");

  double newHeight;
  try {
    newHeight = double.parse(heightStr);
  } catch (err) {
    newHeight = 256;
  }

  setState(() {
    height = newHeight;

    if (height < MediaQuery.of(context).size.height) {
      show = true;
    }

    if (widget.startFromCommentaries) {
      _scrollController.jumpTo(height);
      show = true;
    }
  });

  print('Page finished loading');
},

            gestureNavigationEnabled: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      );
    }

    Widget actionButtons(BuildContext context, NewsItemInitial state)
    {
      return SliverToBoxAdapter(
        key: dataKey,
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16, top: 8, bottom: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Container(
                            padding: const EdgeInsets.only(top: 2),
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                border: GradientBoxBorder (gradient:  LinearGradient(colors:[ Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary]), width: 2),
                borderRadius: BorderRadius.circular(10)
            
                            ),
                            child: button(
                                  iconData: MenuIcons.favorite,
                                  iconColor: (state.item?.inFavourite == true) ? Theme.of(context).colorScheme.secondary : Colors.black12,
                                  backgroundColor: (state.item?.inFavourite == true) ? const Color(0xffffe0de) : Colors.white,
                                  value: 0,
                                  action: (){
                                      widget.likeAction();
                                      context.read<NewsItemBloc>().add(ToggleLikeNewsItem(id: state.id));                              },
                                ),
                          ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      button(
                        iconData: MainPageCustomIcon.message,
                        iconColor: Theme.of(context).colorScheme.secondary,
                        value: state.item?.commentsCount ?? 0,
                        action: (){},
                        disableShadow: true,
                      ),
                      const SizedBox(width: 12,),
                      button(
                        iconData: (state.item?.inFavourite == true) ? MainPageCustomIcon.heart : MainPageCustomIcon.heart_outlined,
                        iconColor: Theme.of(context).colorScheme.secondary,
                        backgroundColor: (state.item?.inFavourite == true) ? const Color(0xffffe0de) : Colors.white,
                        value: state.item?.likesCount ?? 0,
                        disableShadow: true,
                      ),
                                        const SizedBox(width: 12,),
              
                     button(
                      iconData: Icons.remove_red_eye,
                      iconColor: Theme.of(context).colorScheme.secondary,
                      backgroundColor: Colors.white,
                      value: state.item?.viewsCount ?? 0,
                      disableShadow: true,
                      showZero: true
                  ),
                    ],
                  ),
              
                ],
              ),
              const SizedBox(height: 10,),
              const Divider(color: Color(0xffDEDEDE), indent: 3,)
            ],
          ),
        ),
      );
    }

    Widget messagesStub(BuildContext context, NewsItemInitial state)
    {
      if(state.commentariesState == CommentariesState.preload)
      {
        context.read<NewsItemBloc>().add(const LoadCommenariesPage());
        return const SliverToBoxAdapter(
          child: SizedBox(
            height: 64,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }

      if(state.commentsList == null || state.commentsList!.commentariesList.isEmpty)
      {
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 64,
            child: Center(
              child: Text(
                LocaleKeys.news_commentEmpty.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 1.4,
                  color: const Color.fromARGB(180, 33, 33, 33),
                ),
              ),
            ),
          ),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: buildCommentaryItem(
                context: context,
                item: state.commentsList!.commentariesList[index]),
            );
          },
          childCount: state.commentsList?.commentariesList.length ?? 0,
        ),
      );

    }

    Widget buildCommentaryItem({required BuildContext context, required CommentaryFullItem item, double size = 40})
    {
      Widget? answerList;
      if(item.answersCount != null && item.answersCount! > 0 && item.answers!.isNotEmpty)
        {
          List<Widget> answers = [];

          for(int i = 0; i < ((item.answersCount! > 2) ? 2 : item.answersCount!); i++)
          {
            answers.add(
              commentaryItem(
                context: context,
                item: CommentaryFullItem(
                  commentary: item.answers![i]
                ),
                size: 30,
                onTapAction: (){
                  _textEditingController.text = (item.commentary?.user?.name ?? "") + ", ";
                  answerId = item.commentary!.id!;
                  myFocusNode.requestFocus();
                }
              )
            );
          }

          if(item.answersCount! > 2)
            {
              answers.add(SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: (){
                    debugPrint("ADADAD");
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => CommentaryAnswers(
                            preloadItems: item.answers ?? [],
                            headerItem: item.commentary!,
                            itemID: item.commentary!.id!,
                            newsId: widget.id
                          ),
                          transitionDuration: const Duration(seconds: 0),
                        )
                    );
                  },
                  child: Text(
                    LocaleKeys.news_showAllCommenaries.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 2,
                      color:  Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ));
            }

          answerList = Column(
            children: answers,
          );
        }

      return commentaryItem(
        context: context,
        item: item,
        answerList: answerList,
        onTapAction: (){
          _textEditingController.text = (item.commentary?.user?.name ?? "") + ", ";
          answerId = item.commentary!.id!;
          myFocusNode.requestFocus();
        }
      );
    }



  }