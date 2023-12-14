import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline_mode/graphql/queries.dart';
import 'package:flutter_offline_mode/models/models_export.dart' as models;
import 'package:flutter_offline_mode/storage/shared_pref.dart';
import 'package:flutter_offline_mode/utils/dialog_utils.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class LinkNotifier extends ChangeNotifier {
  bool _isLinkLoading = false;
  bool get isLinkLoading => _isLinkLoading;

  List<models.Link> _links = [];
  List<models.Link> get links => _links;

  bool _isAppSync = false;

  static final _httpLink = HttpLink(
    'http://diyo-api-load-balancer-576848411.ap-southeast-1.elb.amazonaws.com:8080/query',
  );

  static final _authLink = AuthLink(
    getToken: () async => SharedPref().token,
  );

  static final link = _authLink.concat(_httpLink);

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

  Future<List<models.Link>> getAllLinksFromServer() async {
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

    try {
      return (result.data?["links"] as List)
          .map((e) => models.Link.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<QueryResult> addLinkToServer({
    required String title,
    required String address,
  }) async {
    final MutationOptions options = MutationOptions(
      document: gql(Queries.createLink),
      variables: <String, dynamic>{
        'title': title,
        'address': address,
      },
    );

    final QueryResult result = await (await getClient()).mutate(options);

    return result;
  }

  void getAllLinks({required bool connected, Box? linksBox}) async {
    if (!connected) {
      _links = (linksBox?.get('data') as List?)
              ?.map((e) => e as models.Link)
              .toList() ??
          [];
      notifyListeners();
      return;
    }

    _isLinkLoading = true;
    notifyListeners();

    final response = await getAllLinksFromServer();

    linksBox?.put('data', response);

    _isLinkLoading = false;
    _links = response;
    notifyListeners();

    print("links box : ${linksBox?.get('data')}");
  }

  void onAddLink({
    required bool connected,
    Box? linksBox,
    required TextEditingController title,
    required TextEditingController address,
    required GlobalKey<FormState> formKey,
    required GlobalKey<State> loadKey,
    required BuildContext context,
  }) async {
    if (!formKey.currentState!.validate()) return;

    if (!connected) {
      final link = models.Link(
        id: const Uuid().v1(),
        title: title.text,
        address: address.text,
        user: const models.User(
          id: "2",
          name: "daffa",
        ),
      );

      _links.add(link);
      linksBox?.put("data", _links);
      notifyListeners();

      title.clear();
      address.clear();

      return;
    }

    DialogUtils.showLoadingDialog(context, loadKey);

    final response = await addLinkToServer(
      title: title.text,
      address: address.text,
    );

    Navigator.of(loadKey.currentContext!, rootNavigator: true).pop();

    if (response.hasException) {
      if (kDebugMode) {
        print(response.exception.toString());
      }
    }

    if (response.data != null) {
      title.clear();
      address.clear();
      getAllLinks(
        connected: connected,
        linksBox: linksBox,
      );
    }
  }

  void compareLinkLocalAndServer({
    required bool connected,
    Box? linksBox,
    required GlobalKey<State> loadKey,
    required BuildContext context,
  }) async {
    if (!connected) {
      _isAppSync = false;
      return;
    }

    if (kDebugMode) {
      print("is compare and app sync : ${_isAppSync}");
      print("connected : ${connected}");
    }

    if (_isAppSync) return;

    try {
      _isAppSync = true;

      // print("is called 1");

      final local = (linksBox?.get('data') as List?)
              ?.map((e) => e as models.Link)
              .toList() ??
          [];

      // print("is called 2");

      final server = (await getAllLinksFromServer()).map((e) => e.id).toList();

      // print("is called 3");

      final diff =
          local.where((element) => !server.contains(element.id)).toList();

      // print("local : ${local.last}");
      // print("server : $server");
      // print("diff : $diff");

      int index = 0;
      for (var element in diff) {
        DialogUtils.showLoadingDialog(context, loadKey);

        // print("is add to server $index");

        await addLinkToServer(
            title: element.title ?? "", address: element.address ?? "");
        index++;

        Navigator.of(loadKey.currentContext!, rootNavigator: true).pop();
      }

      if (diff.isNotEmpty && index >= diff.length - 1) {
        _isAppSync = false;
        linksBox?.put("data", []);
      }
    } catch (e) {
      print("error sync app : $e");
      _isAppSync = false;
    }
  }
}
