import 'package:crud_flutter/components/user_tile.dart';
import 'package:crud_flutter/data/dummy_users.dart';
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final users = {...DUMMY_USERS};

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuários'),
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (ctx, indice) =>
              UserTile(users.values.elementAt(indice))),
    );
  }
}
