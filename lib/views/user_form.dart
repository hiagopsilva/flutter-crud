import 'package:crud_flutter/models/user.dart';
import 'package:crud_flutter/provider/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;

  final Map<String, String> _formData = {};

  void _loadFormData(User user) {
    if (user != null) {
      _formData['id'] = user.id;
      _formData['name'] = user.name;
      _formData['email'] = user.email;
      _formData['avatarUrl'] = user.avatarUrl;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final User user = ModalRoute.of(context).settings.arguments;

    _loadFormData(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Usuário'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              final isValid = _form.currentState.validate();

              if (isValid) {
                _form.currentState.save();

                setState(() {
                  _isLoading = true;
                });

                await Provider.of<Users>(context, listen: false).put(
                  User(
                    id: _formData['id'],
                    name: _formData['name'],
                    email: _formData['email'],
                    avatarUrl: _formData['avatarUrl'],
                  ),
                );

                setState(() {
                  _isLoading = false;
                });

                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _formData['name'],
                        decoration: InputDecoration(labelText: 'Nome'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nome inválido';
                          }

                          return null;
                        },
                        onSaved: (value) => _formData['name'] = value,
                      ),
                      TextFormField(
                        initialValue: _formData['email'],
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value.trim().length < 3) {
                            return 'Email inválido';
                          }

                          return null;
                        },
                        onSaved: (value) => _formData['email'] = value,
                      ),
                      TextFormField(
                        initialValue: _formData['avatarUrl'],
                        decoration: InputDecoration(labelText: 'URL do avatar'),
                        onSaved: (value) => {
                          if (value == 'pinguim')
                            {
                              value =
                                  'https://cdn.pixabay.com/photo/2016/03/31/19/58/avatar-1295429_960_720.png',
                            },
                          _formData['avatarUrl'] = value,
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 0, right: 65.0, top: 10.0),
                        child: Text(
                          'Está sem avatar? Escreva "pinguim" na URL do avatar.',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.blueGrey[400]),
                        ),
                      )
                    ],
                  )),
            ),
    );
  }
}
