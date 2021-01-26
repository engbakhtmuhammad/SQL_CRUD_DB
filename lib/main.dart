import 'package:flutter/material.dart';
import 'package:sqflite_demo/model/user.dart';

import './services/user_services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SQFLite Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _ageController = TextEditingController();

  final services = UserServices();

  void showBottomModal(BuildContext ctx, String id, String name, int age) {
    final TextEditingController _updateNameController = TextEditingController();

    final TextEditingController _updateAgeController = TextEditingController();
    _updateNameController.text = name;
    _updateAgeController.text = age.toString();
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return Container(
            padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 10),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 20, right: 20),
                    child: TextField(
                      controller: _updateNameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Name'),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: TextField(
                      controller: _updateAgeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Age'),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: RaisedButton.icon(
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          services.updateUser(
                              id,
                              _updateNameController.text,
                              int.parse(
                                _updateAgeController.text,
                              ));
                        });
                        Navigator.of(ctx).pop();
                      },
                      icon: Icon(Icons.add),
                      label: Text('Save User'),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQFLite Demo'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Age'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: RaisedButton.icon(
                color: Colors.orange,
                onPressed: () {
                  setState(() {
                    services.saveUser(
                        _nameController.text, int.parse(_ageController.text));
                  });
                  _nameController.clear();
                  _ageController.clear();
                },
                icon: Icon(Icons.add),
                label: Text('Add User'),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: services.fetchUsers(),
                builder: (ctx, snap) {
                  List<User> users = snap.data;
                  if (!snap.hasData) {
                    return Center(
                      child: Text('No data found'),
                    );
                  }
                  return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (ctx, idx) {
                        return Card(
                          elevation: 3,
                          child: ListTile(
                            title: Text('${users[idx].name}'),
                            subtitle: Text('${users[idx].age}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      services.deleteUser(users[idx].id);
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => showBottomModal(
                                    context,
                                    users[idx].id,
                                    users[idx].name,
                                    users[idx].age,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
