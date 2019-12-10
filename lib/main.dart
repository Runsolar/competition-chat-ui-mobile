import 'package:flutter/material.dart';
import 'models/message_model.dart';
import 'globals/globals.dart';
import 'apis/coco-sdk-dart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Message> _messages;
  TextEditingController textEditingController;
  ScrollController scrollController;

  bool enableIconButton = false;

  ComponentSession conv;  


  @override
  void initState() {
    _messages = new List<Message>();

    textEditingController = new TextEditingController();
    scrollController = new ScrollController();
    _messages.add(chats[0]);
    conv = new ComponentSession("register_vp3", "", onSetStateClbk);
    super.initState();
  }

  void onSetStateClbk() {
    setState(() {
      _messages.add(
        Message(
          sender: bot,
          time: '00:00 PM',
          text: newMsgFromBot,
          isLiked: false,
          unread: true,
        )
      );
      Future.delayed(Duration(milliseconds: 100), () {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent, 
            curve: Curves.ease, 
            duration: Duration(milliseconds: 500));
      });  
    }); 
  }

  void handleSendMessage() {
        var text = textEditingController.value.text;
        textEditingController.clear();
        setState(() {
          _messages.add(
            Message(
              sender: currentUser,
              time: '00:00 PM',
              text: text,
              isLiked: false,
              unread: true,  
            )            
          );
          conv.call(text);
          enableIconButton = false;
        });
        Future.delayed(Duration(milliseconds: 100), () {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent, 
            curve: Curves.ease, 
            duration: Duration(milliseconds: 500));
        });                     
  }

  @override
  Widget build(BuildContext context) {

    bool enableIconButton = textEditingController.value.text.isNotEmpty;

    var textInput = 
          Row(children: <Widget>[
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      onChanged: (text) {
                        setState(() {
                          enableIconButton = text.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration.collapsed(
                        hintText: "Type a message"
                      ),
                      controller: textEditingController,
                    ),
                ),
              ),
              enableIconButton ? IconButton(
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).primaryColor,
                ),
                disabledColor: Colors.grey,
                onPressed: handleSendMessage,
              ) :
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.grey,
                ),
                disabledColor: Colors.grey,
                onPressed: null,
              ),
            ],
          );

    return MaterialApp(
      title: 'CoCo Chat',
      home: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text("CoCo Competition 2019"),
        ),
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            
            Expanded(            
                child: Container(
                  child: ListView.builder(
                  controller: scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    bool reverse = false;

                    if (index % 2 == 0) {
                      reverse = true;
                    }

                    var avatar = 
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
                      child: CircleAvatar(
                        backgroundColor: _messages[index].sender.isBot? Colors.white : Colors.blue[200],
                        child: _messages[index].sender.isBot? Image.asset('assets/images/bot.png') : Image.asset('assets/images/person.png'),
                      ),
                    );

                    var triangle = CustomPaint(
                      painter: Triangle(),
                    );

                    var messagebody =
                    Container(
                      //width: 200,
                      //width: MediaQuery.of(context).size.width * 0.7,
                      width: this._messages[index].text.length < 36 ? null : MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.blue[200], 
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0)
                        )),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(_messages[index].text, ),
                            ],
                          ),
                        ),
                      )
                    );

                    Widget message;

                    if(reverse) {
                      message = 
                      Stack(
                        children: <Widget>[
                          messagebody,
                          new Positioned(right: 0, bottom: 0, child: triangle),
                        ], 
                      );
                    } else {
                      message = 
                      Stack(
                        children: <Widget>[
                          new Positioned(left: 0, bottom: 0, child: triangle),
                          messagebody,
                        ], 
                      );
                    }

                    if(reverse) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          //CustomPaint(painter: Triangle()),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: message,
                          ),
                          avatar
                        ],
                      );
                    } else {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          avatar,
                          //CustomPaint(painter: Triangle()),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: message,
                          ),
                        ],
                      );
                    }
                  },
              ),
                ),
            ),
            textInput
          ],
        ),
      ),
    );
  }
}

class Triangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.blue[200];

    var path = Path();
    path.lineTo(10, 0);
    path.lineTo(0, -10);
    path.lineTo(-10, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}