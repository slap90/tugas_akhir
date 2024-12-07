import 'package:flutter/material.dart';

class AgendaPage extends StatelessWidget {
  final List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: months.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(
              months[index],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildAgendaListForMonth(months[index]),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildAgendaListForMonth(String month) {
    // Contoh data agenda per bulan
    List<Map<String, String>> sampleAgendas = [
      {'date': '1', 'event': 'Upacara Hari Jadi'},
      {'date': '15', 'event': 'Rapat Kades'},
      {'date': '20', 'event': 'Gotong Royong'},
    ];

    return Column(
      children: sampleAgendas
          .map(
            (agenda) => ListTile(
              leading: CircleAvatar(
                child: Text(agenda['date']!),
              ),
              title: Text(agenda['event']!),
            ),
          )
          .toList(),
    );
  }
}
