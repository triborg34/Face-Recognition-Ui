import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 500,
        height: 500,
        child: InkWell(
          onTap: () async {
            await getData();
          },
          child: Image.network(
              'http://127.0.0.1:8090/api/files/pbc_50156962/voz31f4be4y2164/ssrv2ednqh8_igawrh00mo.unknown_186.jpg'),
        ),
      ),
    );
  }

  getData() async {
    String src =
        'http://127.0.0.1:8090/api/files/pbc_50156962/voz31f4be4y2164/ssrv2ednqh8_igawrh00mo.unknown_186.jpg';

        final response = await http.get(Uri.parse(src));
        if (response.statusCode==200){
          return response.bodyBytes;
        }

  }
}
