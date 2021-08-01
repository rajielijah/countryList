import 'package:flutter/material.dart';
import 'package:flutterassignment/ui/countryList.dart';
import 'package:flutterassignment/utils/connectivity_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(CountryList());
}


class CountryList extends StatelessWidget {
  // const Country({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
          child: ListCountry(),
        ),
      ],
          child: MaterialApp(
        title: 'List of Countries',
        theme: ThemeData(
          primaryColor: Colors.white
        ),
        home: ListCountry(),
      ),
    );
  }
}

