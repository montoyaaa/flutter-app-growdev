import 'package:flutter/material.dart';
import 'package:flutter_app/database/user_database.dart';
import 'package:flutter_app/repositories/user.repository.dart';
import 'package:flutter_app/widgets/bottom_appbar.widget.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_app/models/user.model.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final repository = UserRepository(UserDatabase());
  Future<List<User>>? actionGetUsers;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    setState(() {
      actionGetUsers = repository.get();
    });
  }

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
      body: FutureBuilder(
        future: actionGetUsers,
        builder: (_, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text('Ocorreu um erro ao carregar os usuários'),
            );
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final users = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: () async {
              _loadUsers();
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (_, index) {
                    final user = users[index];
                    return Dismissible(
                      key: ValueKey(user.id),
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
                      child: ListTile(
                        title: Text(user.name!),
                        subtitle: Text(user.email!),
                        enabled: true,
                        enableFeedback: true,
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.pathImage!),
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed(
            '/form',
          );

          if (result != null) {
            _loadUsers();
          }
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
