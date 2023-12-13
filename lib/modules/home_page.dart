import 'package:flutter/material.dart';
import 'package:flutter_offline_mode/graphql/queries.dart';
import 'package:flutter_offline_mode/widgets/main_textfield_widget.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_offline_mode/models/models_export.dart' as models;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController addressController;

  GraphQLClient? client;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    titleController.dispose();
    addressController.dispose();
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
                        onPressed: () {},
                        child: const Text("Add"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Query(
                  options: QueryOptions(
                    document: gql(
                      Queries.fetchAllLinks,
                    ), // this is the query string you just created
                    pollInterval: null,
                  ),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }

                    if (result.isLoading) {
                      return const Text('Loading');
                    }

                    final links = result.data?["links"];

                    if (links == null) {
                      return const Text('No Links');
                    }

                    return ListView.builder(
                      // shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      itemCount: links.length,
                      itemBuilder: (context, index) {
                        final link = models.Link.fromJson(links[index]);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Id : ${link.id}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  "Title : ${link.title}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  "Address : ${link.address}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  "User name : ${link.user?.name}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
