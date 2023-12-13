import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline_mode/graphql/queries.dart';
import 'package:flutter_offline_mode/storage/shared_pref.dart';
import 'package:flutter_offline_mode/utils/dialog_utils.dart';
import 'package:flutter_offline_mode/widgets/main_textfield_widget.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_offline_mode/models/models_export.dart' as models;
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _loadKey = GlobalKey<State>();

  late TextEditingController titleController;
  late TextEditingController addressController;

  bool isLinkLoading = false;
  List<models.Link> links = [];

  static final _httpLink = HttpLink(
    'http://diyo-api-load-balancer-576848411.ap-southeast-1.elb.amazonaws.com:8080/query',
  );

  static final _authLink = AuthLink(
    getToken: () async => SharedPref().token,
  );

  static Link link = _authLink.concat(_httpLink);

  Future<GraphQLClient> getClient() async {
    final dir = await getApplicationDocumentsDirectory();

    /// initialize Hive and wrap the default box in a HiveStore
    final store = await HiveStore.open(path: '${dir.path}/cache/');
    return GraphQLClient(
      /// pass the store to the cache for persistence
      cache: GraphQLCache(store: store),
      link: link,
    );
  }

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    addressController = TextEditingController();

    getAllLinks();
  }

  @override
  void dispose() {
    super.dispose();

    titleController.dispose();
    addressController.dispose();
  }

  void getAllLinks() async {
    setState(() => isLinkLoading = true);

    final QueryOptions options = QueryOptions(
      fetchPolicy: FetchPolicy.cacheAndNetwork,
      document: gql(Queries.fetchAllLinks),
    );

    final QueryResult result = await (await getClient()).query(options);

    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }

    setState(() {
      isLinkLoading = false;
      links = (result.data?["links"] as List)
          .map((e) => models.Link.fromJson(e))
          .toList();
    });
  }

  void onAddLink() async {
    if (!_formKey.currentState!.validate()) return;

    DialogUtils.showLoadingDialog(context, _loadKey);

    final MutationOptions options = MutationOptions(
      document: gql(Queries.createLink),
      variables: <String, dynamic>{
        'title': titleController.text,
        'address': addressController.text,
      },
    );

    final QueryResult result = await (await getClient()).mutate(options);

    Navigator.of(_loadKey.currentContext!, rootNavigator: true).pop();

    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
    }

    if (result.data != null) {
      titleController.clear();
      addressController.clear();
      getAllLinks();
    }
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
                        onPressed: () {
                          onAddLink();
                        },
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
                child: Builder(builder: (context) {
                  if (isLinkLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      getAllLinks();
                    },
                    child: ListView.builder(
                      // shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: links.length,
                      itemBuilder: (context, index) {
                        final link = links[index];

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
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
