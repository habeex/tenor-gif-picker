import 'package:flutter/material.dart';
import 'package:giphy_picker/tenor_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giphy Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TenorGif _gif;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_gif?.title ?? 'Tenor Giph Picker Demo'),
        ),
        body: SafeArea(child: Center(child: _gif == null ? Text('Pick a gif..') : TenorImage.original(gif: _gif))),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: () async {
              // request your Giphy API key at https://developers.giphy.com/
              final gif = await TenorPicker.pickGif(context: context, apiKey: 'QC6YOK1CYPX0');

              if (gif != null) {
                setState(() => _gif = gif);
              }
            }));
  }
}
