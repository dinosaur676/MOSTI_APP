import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:travel_hour/manager/api_manager.dart';
import 'package:travel_hour/models/notice.dart';
import 'package:travel_hour/utils/empty.dart';
import 'package:travel_hour/utils/loading_cards.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:travel_hour/pages/notice_detail.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Notices(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Notices extends StatefulWidget {
  const Notices({Key? key}) : super(key: key);

  @override
  _NoticesState createState() => _NoticesState();
}

class _NoticesState extends State<Notices>
    with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: FutureBuilder(
        future: GetIt.instance.get<APIManager>().GET(APIManager.URL_NOTICE),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return EmptyPage(
                icon: Feather.bookmark,
                message: 'no blogs found'.tr(),
                message1: 'save your favourite blogs here'.tr(),
              );
            } else {
              //print(snapshot.data);
              return ListView.separated(
                padding: EdgeInsets.all(15),
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index) =>
                    SizedBox(
                      height: 15,
                    ),
                itemBuilder: (BuildContext context, int index) {
                  return _NoticeList(notice: getNotice(snapshot.data[index]));
                },
              );
            }
          }
          return ListView.separated(
            padding: EdgeInsets.all(15),
            itemCount: 5,
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(
                  height: 10,
                ),
            itemBuilder: (BuildContext context, int index) {
              return LoadingCard(height: 120);
            },
          );
        },
      ),
    );
  }

  Notice getNotice(Map respData) {
    print(respData);
    return Notice(respData["writer"], respData["title"], respData["content"],
        respData["createdOn"]);
  }

  @override
  bool get wantKeepAlive => true;
}

class _NoticeList extends StatelessWidget {
  final Notice notice;

  const _NoticeList({Key? key, required this.notice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(3)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Hero(
                  tag: 'bookmark${notice!.timestamp}',
                  child: Container(
                      width: 140,
                      child: Container()
                  )),
            ),
            Flexible(
              child: Container(
                margin:
                EdgeInsets.only(left: 15, top: 15, right: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notice.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(CupertinoIcons.time,
                                size: 16, color: Colors.grey),
                            SizedBox(
                              width: 3,
                            ),
                            Text(notice.timestamp,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey)),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        showDialog(context: context, builder: (_) {
          return Container(
            child: NoticeDetailPage(notice: notice,),
          );
        });
      },
    );
  }


}
