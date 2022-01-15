import 'dart:convert';
import 'package:covigenix/helper.dart';
import 'package:covigenix/ui/custom_widgets/dialog.dart';
import 'package:covigenix/ui/custom_widgets/icons.dart';
import 'package:covigenix/ui/custom_widgets/progress.dart';
import 'package:covigenix/ui/custom_widgets/row_widget.dart';
import 'package:covigenix/ui/model/community_post_model.dart';
import 'package:covigenix/ui/model/generic_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Page extends StatefulWidget {
  final int type;

  Page(this.type);

  @override
  _PageState createState() => _PageState(type);
}

class _PageState extends State<Page> {
  int type;

  _PageState(this.type);

  //Set isLoading true during assignment setstate, not inside fetcher function.
  Future<List<CommunityPost>>? _futureList;
  bool isLoading = false;

  //API calls
  Future<List<CommunityPost>> fetchList() async {
    /*setState(() {
      isLoading = true;
    });*/

    final response = await http.post(
      Uri.https(Helper.BASE_URL, "community/$type/nearby"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'coordinates': [Helper.getLongitude(), Helper.getLatitude()]
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      return ListResponse.fromJson(jsonDecode(response.body)).posts;
    } else {
      Helper.goodToast('There was an error');
      throw Exception("Failed to fetch list");
    }
  }

  Future<void> _showMyDialog(String reqId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomDialog(
          title: "Confirm Delete",
          body: "Are you sure you want to delete this request?",
          yesTitle: "Delete",
          yesFunction: () => _deleteRequest(reqId),
        );
      },
    );
  }

  void _deleteRequest(String reqId) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.delete(
      Uri.https(Helper.BASE_URL, "community/$reqId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      GenericResponse res = GenericResponse.fromJson(jsonDecode(response.body));
      Helper.goodToast(res.message);

      setState(() {
        isLoading = true;
        _futureList = fetchList();
      });
    } else {
      Helper.goodToast('There was an error');
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _futureList = fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Opacity(
              opacity: 0.2,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Image.asset("assets/images/back3.png", fit: BoxFit.cover,)),
              )),
        ),
        RefreshIndicator(
          onRefresh: () {
            setState(() {
              _futureList = fetchList();
            });
            return _futureList!;
          },
          child: FutureBuilder<List<CommunityPost>>(
            future: _futureList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: [
                    ListScreen(
                      list: Helper.sortCommunityPosts(snapshot.data!),
                      deletePost: _showMyDialog,
                    ),
                    (isLoading ? CustomProgressIndicator() : Container()),
                  ],
                );
              }
              return CustomProgressIndicator();
            },
          ),
        ),
      ],
    );
  }
}

class ListScreen extends StatelessWidget {
  final List<CommunityPost> list;
  final Function deletePost;
  final String ownId = Helper.getId();

  ListScreen({required this.list, required this.deletePost});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RowWidget(
                          Icons.account_circle, "Name: ${list[index].name}"),
                      RowWidget(Icons.eco, "Item: ${list[index].item}"),
                      RowWidget(Icons.business, "Area: ${list[index].area}"),
                      RowWidget(Icons.description, list[index].details),
                      //RowWidget(Icons.phone, "Phone: ${list[index].phone}"),
                    ],
                  ),
                ),
                (list[index].personId == ownId
                    ? DeleteIcon(() => deletePost(list[index].postId))
                    : CallIcon(list[index].phone))
              ],
            ),
          );
        },
      ),
    );
  }
}

class ListResponse {
  int code;
  String message;
  List<CommunityPost> posts;

  ListResponse(
      {required this.code, required this.message, required this.posts});

  factory ListResponse.fromJson(Map<String, dynamic> json) {
    Iterable posts = json["posts"];
    return ListResponse(
      code: json["code"],
      message: json["message"],
      posts: posts
          .map<CommunityPost>((modelJson) => CommunityPost.fromJson(modelJson))
          .toList(),
    );
  }
}
