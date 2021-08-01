import 'package:flutter/material.dart';
import 'package:flutterassignment/model/core/countryMode.dart';
import 'package:flutterassignment/utils/connectivity_provider.dart';
import 'package:flutterassignment/utils/convertJson.dart';
import 'package:flutterassignment/utils/no_internet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';


List data;
List<Country> countrylist = [];
List<Country> countrysavedlist = List();
int index;

class ListCountry extends StatefulWidget {
  // const ListCountry({ Key? key }) : super(key: key);

  @override
  _ListCountryState createState() => _ListCountryState();
}

class _ListCountryState extends State<ListCountry> {
   @override
  void initState() {
    super.initState();
     Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    fetchanotherdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of  Countries'),
        actions: [IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)],
      ),
      body: listView(),
    );
  }
  //  Future<String> fetchData() async {
  //   final url =
  //       'https://api.first.org/data/v1/countries';
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     print('succesfull parse');
  //     print(response.body);
  //     List<Country> country = convertJsonToCountryModelList(response.body);
  //     print('Thus is the $country');
  //     // this.setState(() {
  //     //   Map<String, dynamic> map = json.decode(response.body);
  //     //   List<dynamic> data = map["data"];
  //     //   // data = json.decode(response.body);
  //     //   data.forEach((element) => countrylist.add(Country.fromJson(element)));
  //     // });}
  //   return "Success!";
  // }
Future<List<Country>> fetchanotherdata() async{
   final url =
        'https://api.first.org/data/v1/countries';
    final response = await http.get(url);
    print(response.body);
     if (response.statusCode == 200) {
      Map data = json.decode(response.body);
      print('let see  $data["data"]');
      final country = (data as List).map((e) => Country.fromJson(e));
      return country.toList();
      } else {
        return [];
      }
}
 
   Widget listView() {    
    return ListView.builder(
      itemCount: countrylist == null ? 0 : countrylist.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[_buildRow(index, countrylist), const Divider()],
        );
      },
    );
  }
    Widget _buildRow(index, countrylist) {
    final bool alreadySaved = countrysavedlist.contains(countrylist[index]);
    return Consumer<ConnectivityProvider>(builder: (consumerContext, model, child){
       if (model.isOnline != null) {
          return model.isOnline
              ? Center(
                  child: Text(
                    "Home Page",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                )
              : NoInternet();
        }
    return ListTile(
      leading: Text(countrylist[index].code),
      title: Text(
        countrylist[index].country),
      subtitle: Text(countrylist[index].region),
      trailing: Icon(
        alreadySaved ? Icons.star : Icons.star_border,
        color: alreadySaved ? Colors.yellow : Colors.blue,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            countrysavedlist.remove(countrylist[index]);
          } else {
            countrysavedlist.add(countrylist[index]);
          }
        });
      },
    );
    });
  }
  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = countrysavedlist.map(
            (Country pair) {
              return ListTile(
                leading: Text(pair.data.aM.region),
                title: Text(
                  pair.data.aF.country,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return Scaffold(
            appBar: AppBar(
              title: const Text('Favourites'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}