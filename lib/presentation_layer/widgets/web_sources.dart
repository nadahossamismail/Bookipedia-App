import 'dart:developer';

import 'package:bookipedia/app/style/app_colors.dart';
import 'package:bookipedia/presentation_layer/screens/web_view.dart';
import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';

class WebSources extends StatefulWidget {
  final List<String> webSources;

  const WebSources({super.key, required this.webSources});

  @override
  State<WebSources> createState() => _WebSourcesState();
}

class _WebSourcesState extends State<WebSources> {
  var count = 0;
  var count1 = 0;
  Map<String, Favicon> b = {};

  String getDomainName(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'http://$url';
    }

    Uri uri = Uri.parse(url);
    return uri.host;
  }

  getIcon(String url, String name) async {
    if (!b.containsKey(name) && mounted) {
      await FaviconFinder.getBest(url).then((value) => value != null
          ? setState(() {
              log("count from get icon:${++count1}\nadded url:$name");
              b[name] = value;
            })
          : null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            mainAxisSpacing: 10,
            mainAxisExtent: 30),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.webSources.length,
        itemBuilder: ((context, index) {
          var name = getDomainName(widget.webSources[index]);
          // count++;
          // print("count from grid:$count");
          // Future.delayed(
          //     const Duration(
          //       seconds: 2,
          //     ),
          //     () => getIcon(widget.webSources[index], name));

          return InkWell(
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => WebView(url: widget.webSources[index])))
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  //color: const Color.fromARGB(255, 230, 236, 241),
                  color: ColorManager.cardColor,
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  Image.network(
                    "http://www.google.com/s2/favicons?domain=https://$name/",
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
