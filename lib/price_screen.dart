import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  Map<String, double> coinValues = {};
  bool isWaiting = false;

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = currenciesList.map((String currency) {
      return DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
    }).toList();

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Widget> pickerItems = currenciesList.map((String currency) {
      return Text(currency);
    }).toList();

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  void getData() async {
    setState(() {
      isWaiting = true;
    });
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      setState(() {
        coinValues = data;
        isWaiting = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isWaiting = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  List<Widget> makeCards() {
    return cryptoList.map((String crypto) {
      return CryptoCard(
        cryptoCurrency: crypto,
        selectedCurrency: selectedCurrency,
        value: isWaiting ? '?' : coinValues[crypto]?.toStringAsFixed(2) ?? '?',
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: makeCards(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    this.value,
    this.selectedCurrency,
    this.cryptoCurrency,
  });

  final String? value;
  final String? selectedCurrency;
  final String? cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
