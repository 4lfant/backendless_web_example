import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue,     //  <-- dark color
          textTheme: ButtonTextTheme.primary, //  <-- this auto selects the right color
        )
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dataText = 'The saved object will appear here';
  String messageText = 'Press the button above to subscribe to the message channel.';

  @override
  void initState() {
    super.initState();
    initBackendless();
  }

  void initBackendless() {
    Backendless.initApp("6B96D42A-58F4-5AC6-FFA4-BDE0AA0E3200", 
    "72DF4D5A-B87A-4758-8FE7-745E02805A02", "89AD1B88-C414-4EE4-9E89-40AFD1F9D285");
    Backendless.initWebApp("6B96D42A-58F4-5AC6-FFA4-BDE0AA0E3200", "0CB08A50-66E9-431A-89F6-B7A7AC90CD32");
  }

  void saveObject() async {
    Map object = {
      'foo': 'bar',
    };
    Backendless.data.of('TestTable').save(object).then((response) {
      setState(() {
        dataText = response.toString();
      });
    });
  }

  void addMessageListener() async {
    Function(String) listener = (String message) {
      setState(() {
        messageText = message;
      });
    };

    Channel channel = await Backendless.messaging.subscribe('default');

    channel.addMessageListener(listener).then((value) {
      setState(() {
        messageText = 'Now open the Console and send the message to the "default" message channel. The message will appear here';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Save object"),
              onPressed: saveObject,
            ),
            Text(
              dataText,
            ),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              child: Text("Subscribe"), 
              onPressed: addMessageListener,
            ),
            Text(
              messageText,
            ),
          ],
        ),
      ),
    );
  }
}
