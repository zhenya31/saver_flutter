import 'dart:async';

import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:saver/screens/add_item.dart';
import 'package:saver/screens/one_item.dart';
import 'package:saver/services/newtwork_helper.dart';
import 'package:saver/services/user_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'item_added.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  final String title = 'Сохраненные товары';

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  StreamSubscription _intentDataStreamSubscription;
  String _sharedUrl = '';
  int userId;
  SharedPreferences prefs;

  List<dynamic> _itemsData;

  FutureBuilder<ListView> listBuilder;

  @override
  void initState() {
    super.initState();

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      _addItem(value);
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      _addItem(value);
    });

    _updateItems();
  }

  void _updateItems() {
    setState(() {
      listBuilder = FutureBuilder<ListView>(
          future: _getItemsList(),
          builder: (BuildContext context, AsyncSnapshot<ListView> snapshot) {
            if (snapshot.hasData) return snapshot.data;
            if (snapshot.hasError)
              return Text('Ошибка при загрузке данных');
            else {
              return CircularProgressIndicator();
            }
          });
    });
  }

  Future<void> _addItem(String value) async {
    setState(() => _sharedUrl = value);
    if (_sharedUrl != '' && _sharedUrl != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemAddedScreen(sharedUrl: _sharedUrl),
        ),
      );
      _updateItems();
    }
  }

  Future<void> _goToAddItem() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItemScreen(),
      ),
    );
    _updateItems();
  }

  Future<void> _goToOneItem(dynamic item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OneItemScreen(item: item),
      ),
    );
    if (result == 'OK') {
      ScaffoldMessenger.of(context)
        ..showSnackBar(
            SnackBar(content: Text("Товар удален из вашего списка")));
      _updateItems();
    } else if (result == 'Error') {
      ScaffoldMessenger.of(context)
        ..showSnackBar(
            SnackBar(content: Text("Произошла ошибка при удалении")));
      _updateItems();
    }
  }

  Future<ListView> _getItemsList() async {
    userId = await UserId.getUserId();

    NetworkHelper networkHelper = NetworkHelper(
        'http://${NetworkHelper.apiHost}/api/items?userId=$userId');

    _itemsData = await networkHelper.getData();
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _itemsData.length,
        itemBuilder: (BuildContext context, int index) {
          var item = _itemsData[index];
          Widget firstPriceWidget;
          if (item['firstPrice'] != item['lastPrice'])
            firstPriceWidget = Text(
              item['firstPrice'].toString() + " руб.",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.lineThrough),
            );
          else
            firstPriceWidget = SizedBox(height: 0);

          return InkWell(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 100.0,
                      width: 100.0,
                      alignment: Alignment.topCenter,
                      child:
                          Image.network(item['imageUrl'], fit: BoxFit.contain),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              item['name'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(item['site']),
                            SizedBox(height: 8),
                            firstPriceWidget,
                            Text(
                              item['lastPrice'].toString() + " руб.",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue[800]),
                            ),
                          ]),
                    )
                  ],
                ),
              ),
            ),
            onTap: () => _goToOneItem(item),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //  _updateItems();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.autorenew),
            tooltip: 'Обновить список',
            onPressed: () => _updateItems(),
          ),
        ],
      ),
      body: Center(
        child: listBuilder,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddItem,
        tooltip: 'Добавить Товар',
        child: Icon(Icons.add),
      ),
    );
  }
}
