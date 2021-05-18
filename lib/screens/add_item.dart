import 'package:flutter/material.dart';

import 'homepage.dart';
import 'item_added.dart';

class AddItemScreen extends StatefulWidget {
  AddItemScreen({Key key}) : super(key: key);

  final String title = 'Новый товар';
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  TextEditingController urlInput = TextEditingController();

  Future<void> _addItem() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemAddedScreen(sharedUrl: urlInput.text),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Укажите URL адрес страницы с товаром',
                style: TextStyle(fontSize: 15, color: Colors.grey[900]),
              ),
              SizedBox(
                height: 14,
              ),
              TextField(
                controller: urlInput,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: _addItem,
                child: Text('Добавить', style: TextStyle(fontSize: 16)),
              ),
              SizedBox(
                height: 36,
              ),
              Text(
                  'Для добавления товаров также удобно использовать кнопку "Поделиться" в браузере или в приложении магазина.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[800])),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
