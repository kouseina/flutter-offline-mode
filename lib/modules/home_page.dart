import 'package:flutter/foundation.dart';
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

  void onAddLink(
      MultiSourceResult<Object?> Function(Map<String, dynamic>,
              {Object? optimisticResult})
          runMutation) {
    if (!_formKey.currentState!.validate()) return;

    runMutation({
      'title': titleController.text,
      'address': addressController.text,
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
                    Mutation(
                      options: MutationOptions(
                        document: gql(Queries
                            .createLink), // this is the mutation string you just created
                        // you can update the cache based on results
                        update: (cache, result) {},
                        // or do something with the result.data on completion
                        onCompleted: (resultData) {
                          if (resultData != null) {
                            titleController.clear();
                            addressController.clear();
                          }

                          if (kDebugMode) {
                            print("result data create link : $resultData");
                          }
                        },
                      ),
                      builder: (runMutation, result) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              onAddLink(runMutation);
                            },
                            child: const Text("Add"),
                          ),
                        );
                      },
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
                    fetchPolicy: FetchPolicy.cacheAndNetwork,
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

                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: refetch,
                          child: Text("Refetch"),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Expanded(
                          child: ListView.builder(
                            // shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Title : ${link.title}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Address : ${link.address}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "User name : ${link.user?.name}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
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
