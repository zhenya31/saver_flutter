import 'package:flutter/material.dart';
import 'package:saver/services/newtwork_helper.dart';
import 'package:saver/services/user_id.dart';

class ItemAddedScreen extends StatefulWidget {
  ItemAddedScreen({Key key, this.sharedUrl}) : super(key: key);

  final String sharedUrl;
  final String title = 'Добавление страницы';

  @override
  _ItemAddedScreenState createState() => _ItemAddedScreenState();
}

class _ItemAddedScreenState extends State<ItemAddedScreen> {
  Future<dynamic> _addItem(String url) async {
    int userId = await UserId.getUserId();
    NetworkHelper networkHelper = NetworkHelper(
        'http://${NetworkHelper.apiHost}/api/pricer?userId=$userId&url=$url');
    dynamic response = await networkHelper.getData();
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: FutureBuilder<dynamic>(
                future: _addItem(widget.sharedUrl),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) print(snapshot.data);
                  if (snapshot.hasData && snapshot.data['error'] == null)
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Товар сохранен',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[900],
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Название: ' + snapshot.data['title'],
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[800]),
                        ),
                        Text(
                          'Цена: ' + snapshot.data['price'].toString(),
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[800]),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ],
                    );
                  if (snapshot.hasData && snapshot.data['error'] != null)
                    return Text(snapshot.data['error']);
                  if (snapshot.hasError)
                    return Text('Неизвестная ошибка');
                  else {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              'Обрабатываем страницу. Обычно это занимает около 30 сек'),
                          SizedBox(height: 5),
                          Text(
                            'URL: ' + widget.sharedUrl,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[800]),
                          ),
                          SizedBox(height: 40),
                          Center(child: CircularProgressIndicator()),
                        ]);
                  }
                })),
      ),
    );
  }
}
