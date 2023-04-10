import 'package:flutter/material.dart';


class Search extends StatelessWidget {
  
  Search({
    super.key,
  });
TextStyle myTextStyle = TextStyle(
  fontSize: 15, // Set font size
  fontWeight: FontWeight.bold, // Set font weight
);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF0B3954),
        title: Text('Explorar'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              hintText: 'Buscar',
              suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: (){},),
              prefixIcon: IconButton(icon: Icon(Icons.search), onPressed: (){},)),
          )
        ],
      ),
    );
  }
}