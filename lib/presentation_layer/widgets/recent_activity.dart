import 'package:bookipedia/data_layer/Api_requests/recent_activity.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class RecentActivityUi extends StatelessWidget {
  final List<Datum> recentActivity;
  const RecentActivityUi({super.key, required this.recentActivity});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 8,
      width: double.infinity,
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.only(right: 15),
        separatorBuilder: (context, index) => const SizedBox(
          width: 10,
        ),
        itemBuilder: (context, index) {
          Datum item = recentActivity[index];
          var isBook = item.type == "book" ? true : false;

          return SizedBox(
            width: MediaQuery.sizeOf(context).width / 1.4,
            child: Card(
              // elevation: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    width: 50,
                    height: 65,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(3)),
                    margin: const EdgeInsets.only(left: 10),
                    child: isBook
                        ? FadeInImage(
                            placeholder: MemoryImage(kTransparentImage),
                            image: NetworkImage(item.book!.imageUrl),
                            width: MediaQuery.sizeOf(context).width / 5.7,
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.medium,
                          )
                        : Image.asset(
                            "assets/images/PDF_file_icon.png",
                            width: MediaQuery.sizeOf(context).width / 5.7,
                            height: MediaQuery.sizeOf(context).width / 5,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2.8,
                        child: Text(
                          item.title ?? item.book!.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        isBook ? item.book!.author : "PDF",
                      ),
                      isBook
                          ? Text("${(item.progressPercentage! * 100).toInt()}%")
                          : const SizedBox.shrink()
                    ],
                  ),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.more_horiz))
                ],
              ),
            ),
          );
        },
        itemCount: recentActivity.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
