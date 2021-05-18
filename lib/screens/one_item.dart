import 'package:flutter/material.dart';
import 'package:saver/services/newtwork_helper.dart';
import 'package:saver/services/user_id.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class OneItemScreen extends StatefulWidget {
  OneItemScreen({Key key, this.item}) : super(key: key);

  final dynamic item;

  @override
  _OneItemScreenState createState() => _OneItemScreenState();
}

class _OneItemScreenState extends State<OneItemScreen> {
  dynamic item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  Future<void> _deleteItem(int id) async {
    http.Response response = await http.delete(Uri.parse(
        'http://${NetworkHelper.apiHost}/api/items/' + id.toString()));

    if (response.statusCode == 200 && response.body == '1')
      Navigator.pop(context, 'OK');
    else
      Navigator.pop(context, 'Error');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name'] ?? 'Нет названия'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Image.network(item['imageUrl'], fit: BoxFit.contain),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Text(
                        item['site'],
                        style: TextStyle(fontSize: 13, color: Colors.black45),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      onTap: () => _launchURL(item['url']),
                    ),
                    SizedBox(height: 8),
                    Text(
                      item['name'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      item['lastPrice'].toString() + ' руб.',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Изначальная цена: ' + item['firstPrice'].toString(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey[800]),
                    ),
                    Text(
                      'Разница: ' +
                          (item['lastPrice'] - item['lastPrice']).toString(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey[800]),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _launchURL(item['url']),
                        child: Text('На сайт'),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _deleteItem(item['id']),
                        child: Text('Удалить'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red[400],
                          onPrimary: Colors.black,
                        ),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
