// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'package:flutter_realm/models/schema.dart' as Schema;
import 'package:flutter_realm/widgets/main_textfield_widget.dart';
import 'package:realm/realm.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final config = Configuration.local([Schema.Links.schema, Schema.User.schema]);
  late Realm realm;

  RealmResults<Schema.Links>? links;

  late TextEditingController titleController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();

    realm = Realm(config);
    queryObject();

    titleController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    realm.close();
    titleController.dispose();
    addressController.dispose();
  }

  void addObject() {
    if (!_formKey.currentState!.validate()) return;

    final link = Schema.Links(
      ObjectId.fromTimestamp(DateTime.now()),
      title: titleController.text,
      address: addressController.text,
      user: Schema.User(
        id: "1",
        name: "daffa",
      )
    );

    realm.write(() {
      realm.add(link);
    });

    titleController.clear();
    addressController.clear();

    queryObject();
  }

  void updateObject(Schema.Links link) {}

  void queryObject() {
    setState(() {
      links = realm.all<Schema.Links>();
    });
  }

  void deleteCar(Schema.Links car) {
    realm.write(() {
      realm.delete(car);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Links"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    MainTextFieldWidget(
                      controller: titleController,
                      labelText: "Title",
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    MainTextFieldWidget(
                      controller: addressController,
                      labelText: "Address",
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: addObject,
                        child: const Text("Add"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: links?.length ?? 0,
                itemBuilder: (context, index) {
                  final link = links?[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Id : ${link?.id}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            "Title : ${link?.title}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            "Address : ${link?.address}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            "User name : ${link?.user?.name}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
