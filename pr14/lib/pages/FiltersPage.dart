import 'package:flutter/material.dart';

class Filters extends StatefulWidget {
  const Filters({super.key});

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  double? minPrice;
  double? maxPrice;
  bool showDishwasherSafe = false;
  List<String> materials = [];

  final List<String> availableMaterials = [
    'Керамика',
    'Силикон',
    'Сталь',
    'Стекло',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 246, 218),
      appBar: AppBar(
        title: Text('Фильтр товаров'),
        backgroundColor: Colors.amber[200],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    right: 25.0, left: 25.0, top: 60.0, bottom: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Цена от ',
                      style: TextStyle(fontSize: 14),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 40,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          minPrice = double.tryParse(value);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(
                              right: 10, left: 10, bottom: 0, top: 0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(255, 160, 0, 1),
                                width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(255, 160, 0, 1),
                                width: 2),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        cursorHeight: 20.0,
                      ),
                    ),
                    const Text(
                      ' до ',
                      style: TextStyle(fontSize: 14),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 40,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          maxPrice = double.tryParse(value);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(
                              right: 10, left: 10, bottom: 0, top: 0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(255, 160, 0, 1),
                                width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(255, 160, 0, 1),
                                width: 2),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        cursorHeight: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 25.0, left: 25.0, bottom: 40.0),
                child: Row(
                  children: [
                    Checkbox(
                        value: showDishwasherSafe,
                        onChanged: (value) {
                          setState(() {
                            setState(() {
                              showDishwasherSafe = !showDishwasherSafe;
                            });
                          });
                        },
                        activeColor: Colors.amber[700]),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: const Text('Можно мыть в посудомоечной машине',
                            softWrap: true, style: TextStyle(fontSize: 14))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 25.0, left: 25.0, bottom: 40.0),
                child: Column(
                  children: [
                    const Text(
                      'Материалы',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Wrap(
                        spacing: 10.0,
                        runSpacing: -15.0,
                        children: availableMaterials.map((material) {
                          return Row(children: [
                            Checkbox(
                                value: materials.contains(material),
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked == true) {
                                      materials.add(material);
                                    } else {
                                      materials.remove(material);
                                    }
                                  });
                                },
                                activeColor: Colors.amber[700]),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * .3,
                                child: Text(material,
                                    style: const TextStyle(fontSize: 14))),
                          ]);
                        }).toList()),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[200],
                      padding: const EdgeInsets.only(
                          bottom: 13.0, top: 13.0, right: 30.0, left: 30.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  onPressed: () {
                    Navigator.pop(context, {
                      'minPrice': minPrice,
                      'maxPrice': maxPrice,
                      'showDishwasherSafe': showDishwasherSafe,
                      'materials': materials
                    });
                  },
                  child: const Text('Применить',
                      style: TextStyle(fontSize: 16, color: Colors.black))),
            ],
          ),
        ),
      ),
    );
  }
}
