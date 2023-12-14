import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_offline_mode/models/link.dart';
import 'package:flutter_offline_mode/models/user.dart';
import 'package:flutter_offline_mode/provider/link_notifier.dart';
import 'package:flutter_offline_mode/widgets/main_textfield_widget.dart';
import 'package:flutter_offline_mode/models/models_export.dart' as models;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _loadKey = GlobalKey<State>();
  Box? linksBox;

  late TextEditingController titleController;
  late TextEditingController addressController;

  bool connected = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    addressController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await openBox();

      if (!mounted) return;
      Provider.of<LinkNotifier>(context, listen: false).getAllLinks(
        connected: connected,
        linksBox: linksBox,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();

    titleController.dispose();
    addressController.dispose();
  }

  Future<void> openBox() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.registerAdapter(LinkAdapter());
    Hive.registerAdapter(UserAdapter());
    await Hive.openBox("links", path: '${dir.path}/data/links/');

    linksBox = Hive.box('links');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Links"),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          print("offline builder is called");

          connected = connectivity != ConnectivityResult.none;

          Provider.of<LinkNotifier>(context, listen: false)
              .compareLinkLocalAndServer(
            connected: connected,
            linksBox: linksBox,
            context: context,
            loadKey: _loadKey,
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                height: 24.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  color:
                      connected ? Colors.green.shade500 : Colors.red.shade400,
                  child: Center(
                    child: Text(connected ? 'ONLINE' : 'OFFLINE'),
                  ),
                ),
              ),
              child,
            ],
          );
        },
        child: SafeArea(
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
                        height: 50,
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
                            Provider.of<LinkNotifier>(context, listen: false)
                                .onAddLink(
                              connected: connected,
                              context: context,
                              loadKey: _loadKey,
                              formKey: _formKey,
                              linksBox: linksBox,
                              title: titleController,
                              address: addressController,
                            );
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
                  child: Consumer<LinkNotifier>(
                    builder: (context, notifier, child) {
                      if (notifier.isLinkLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          notifier.getAllLinks(
                            connected: connected,
                            linksBox: linksBox,
                          );
                        },
                        child: ListView.builder(
                          // shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: notifier.links.length,
                          itemBuilder: (context, index) {
                            final link = notifier.links[index];

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
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
