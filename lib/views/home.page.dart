import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/bottom_appbar.widget.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  final users = <Map<String, String>>[
    {
      'id': '1',
      'nome': 'Edson',
      'email': 'edson@gmail.com',
      'url': 'https://robohash.org/1.png',
    },
    {
      'id': '2',
      'nome': 'Diego',
      'email': 'diego@gmail.com',
      'url': 'https://robohash.org/2.png',
    },
    {
      'id': '3',
      'nome': 'Gabriel',
      'email': 'gabriel@gmail.com',
      'url': 'https://robohash.org/3.png',
    },
    {
      'id': '4',
      'nome': 'Thobias',
      'email': 'thobias@gmail.com',
      'url': 'https://robohash.org/4.png',
    },
    {
      'id': '5',
      'nome': 'Airton',
      'email': 'airton@gmail.com',
      'url': 'https://robohash.org/5.png',
    }
  ];

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: NeumorphicText(
          widget.title!,
          style: NeumorphicStyle(
            depth: 4, //customize depth here
            color: Theme.of(context)
                .colorScheme
                .onBackground, //customize color here
          ),
          textStyle: NeumorphicTextStyle(
            fontSize: 18, //customize size here
            // AND others usual text style properties (fontFamily, fontWeight, ...)
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
            itemCount: widget.users.length,
            itemBuilder: (_, index) {
              final user = widget.users[index];
              return Dismissible(
                key: ValueKey(user['id']),
                background: Container(
                  color: Colors.red,
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        size: 40,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Excluindo...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.archive,
                        size: 40,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Arquivando...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                // direction: DismissDirection.startToEnd,
                onDismissed: (direction) {
                  print('item foi removido');
                },
                confirmDismiss: (direction) async {
                  // if (direction == DismissDirection.startToEnd) {
                  //   if (user['id'] == '2') return true;
                  // }

                  // if (direction == DismissDirection.endToStart) {
                  //   if (user['id'] == '3') return true;
                  // }

                  return true;
                },
                child: ListTile(
                  title: Text(user['nome']!),
                  subtitle: Text(user['email']!),
                  enabled: true,
                  enableFeedback: true,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['url']!),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        '/form',
                        arguments: user,
                      );
                    },
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/form');
        },
        child: NeumorphicIcon(
          Icons.add,
          size: 30,
          style: NeumorphicStyle(
              shape: NeumorphicShape.convex,
              depth: 1,
              lightSource: LightSource.topLeft,
              color: Theme.of(context).scaffoldBackgroundColor),
        ),
        tooltip: 'Create',
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:
          DemoBottomAppBar(shape: const CircularNotchedRectangle()),
    );
  }
}
