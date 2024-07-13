import 'package:flutter/material.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(
          0xff767676,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 50,
                ),
                child: Image.asset('assets/icons/Frame 738002106.png'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 30,
                right: 30,
                top: MediaQuery.of(context).size.height / 12,
                bottom: 10,
              ),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(
                      25,
                    ),
                    value: controller.value,
                    semanticsLabel: 'Linear progress indicator',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/icons/Frame 10.png',
                            width: 46,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Adddd',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              Text(
                                '6 часов назад',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Image.asset(
                          'assets/icons/Vector 8.png',
                          width: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.topCenter,
                color: Color(0xff181818),
                height: 112,
                child: Padding(
                  padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
                  child: Row(
                    children: [
                      Expanded(
                        
                        child: 
                      
                      SizedBox(
                        height: 44,
                        child: Stack(
                          children: [
                            TextField(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              
                                hintText: 'Отправить сообщением...',
                                hintStyle: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.5,),),
                                focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.white,
                                                
                                              ),
                                              borderRadius: BorderRadius.circular(10,)
                                              ),
                                    enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.white,
                                                
                                              ),
                                              borderRadius: BorderRadius.circular(10,),
                                              ),
                               
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8,),
                                fillColor: Color(0xff181818),
                            ),
                                        ),
                                        Align(alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 15,),
                                          child: Image.asset('assets/icons/bxs_paper-plane.png', width: 20,),
                                        ),
                                        
                                        ),
                          ],
                        ),
                      ),),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Image.asset('assets/icons/haeart.png', width: 24, height: 22,),
                      ),
                  
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
