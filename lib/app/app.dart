import 'package:flutter/material.dart';
import 'package:flutter_offline_mode/modules/login_page.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      'http://diyo-api-load-balancer-576848411.ap-southeast-1.elb.amazonaws.com:8080/query',
    );

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(store: HiveStore()),
      ),
    );

    return GraphQLProvider(
      client: client,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
