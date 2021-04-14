import 'package:flutter/material.dart';
import 'mybgscroller.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  FriendsPageState createState() => FriendsPageState();
}

class FriendsPageState extends State<FriendsPage>{
  @override
  Widget build(BuildContext context)
  {
    TextStyle name_textStyle = TextStyle(fontSize: 15);
    TextStyle badgeCount_textStyle = TextStyle(fontSize: 20);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(30),
            child: Text(
              'Friends',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                
              ),
            ),
          ),
          Expanded( 
            
            
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: ListView.builder(
                
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'boiboi ' + index.toString(),
                              style: name_textStyle,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  index.toString(),
                                  style: badgeCount_textStyle
                                ),
                                
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Icon(Icons.celebration),
                                ),
                                
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(height: 30,)
        
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}