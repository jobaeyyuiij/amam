import 'package:flutter/material.dart';

void main() {
  runApp(const FilterApp());
}

class FilterApp extends StatelessWidget {
  const FilterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق الفلاتر',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const FilterHomePage(),
    );
  }
}

class FilterHomePage extends StatefulWidget {
  const FilterHomePage({super.key});

  @override
  State<FilterHomePage> createState() => _FilterHomePageState();
}

class _FilterHomePageState extends State<FilterHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق الفلاتر'),
        centerTitle: true,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_alt_outlined,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'مشروع الفلتر الجاهز',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'ابدأ بتطوير تطبيقك هنا',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
