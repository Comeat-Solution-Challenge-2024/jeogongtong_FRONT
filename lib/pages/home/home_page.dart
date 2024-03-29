import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jeogongtong_front/constants/api.dart';
import 'package:jeogongtong_front/models/user.dart';

import 'package:jeogongtong_front/pages/home/home_add_page.dart';
import 'package:jeogongtong_front/pages/home/home_my_page.dart';
import 'package:jeogongtong_front/pages/home/home_search_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jeogongtong_front/pages/home/room_page.dart';
import 'package:jeogongtong_front/widgets/bottom_navigator.dart';
import 'package:provider/provider.dart';

final user = FirebaseAuth.instance.currentUser;
//Get
Future<List<dynamic>> _fetchData() async {
  final Uri uri = Uri(
    scheme: 'http',
    port: apiPort,
    host: apiHost,
    path: '/',
  );

  final String? idToken = await user?.getIdToken();
  final response = await http.get(uri, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${idToken!}'
  });
  //print(idToken);
  print(response.statusCode);
  if (response.statusCode == 200) {
    String responseBody = utf8.decode(response.bodyBytes);
    print(responseBody);
    Map<String, dynamic> studyroom = jsonDecode(responseBody);
    List<dynamic> mt = studyroom['myStudy'];
    print(mt);
    return mt;
  } else {
    throw Exception('Failed!');
  }
}

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key}); //const HomePage({Key? key, this.name}) : super(key: key);
  static const routeName = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color _buttonColor1 = const Color(0xff131214);
  Color _buttonColor2 = const Color(0xff131214);
  Color _buttonColor3 = const Color(0xff131214);
  int id = 0;
  late Map<String, dynamic> useer;

  @override
  void initState() {
    super.initState();
    _id();
  }

  Future<void> _id() async {
    final Uri uri = Uri(
      scheme: 'http',
      port: apiPort,
      host: apiHost,
      path: '/',
    );

    final String? idToken = await user?.getIdToken();
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${idToken!}'
    });
    //print(idToken);
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      print(responseBody);
      Map<String, dynamic> studyroom = jsonDecode(responseBody);
      Map<String, dynamic> mu = studyroom['user'];
      int i = mu['userId'];
      String e = mu['email'];
      String n = mu['nickname'];
      int p = mu['point'];
      Map<String, dynamic> ef = {
        'id': i,
        'email': e,
        'nickname': n,
        'point': p,
      };
      print(mu);
      setState(() {
        id = mu['userId'];
        useer = ef;
      });
    } else {
      throw Exception('Failed!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                "Home",
                style: TextStyle(fontSize: 18),
              ),
            ),
            titleSpacing: 0,
            actions: <Widget>[
              GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    _buttonColor1 = const Color(0xffFC9AB8);
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    _buttonColor1 = const Color(0xff131214);
                  });
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HomeSearchPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 10),
                  constraints: const BoxConstraints(),
                  child: SvgPicture.asset(
                    "assets/images/search.svg",
                    colorFilter:
                        ColorFilter.mode(_buttonColor1, BlendMode.srcIn),
                  ),
                ),
              ),
              GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    _buttonColor2 = const Color(0xffFC9AB8);
                  });
                },
                onTapUp: (_) async {
                  setState(() {
                    _buttonColor2 = const Color(0xff131214);
                  });
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => HomeAddPage(user: useer)),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 10),
                  constraints: const BoxConstraints(),
                  child: SvgPicture.asset(
                    "assets/images/plus.svg",
                    colorFilter:
                        ColorFilter.mode(_buttonColor2, BlendMode.srcIn),
                  ),
                ),
              ),
              GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    _buttonColor3 = const Color(0xffFC9AB8);
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    _buttonColor3 = const Color(0xff131214);
                  });
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => HomeMyPage(userId: id)),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 15),
                  constraints: const BoxConstraints(),
                  child: SvgPicture.asset(
                    "assets/images/emoji.svg",
                    colorFilter:
                        ColorFilter.mode(_buttonColor3, BlendMode.srcIn),
                  ),
                ),
              )
            ],
          ),
        ),
        body: FutureBuilder(
          future: _fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Center(
                  child: Text(
                    'An error occurred while loading the study room.',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              );
            } else if ((snapshot.data)!.isEmpty) {
              return const Center(
                child: Text(
                  'There are currently no study rooms to participate in.',
                  style: TextStyle(fontSize: 20),
                ),
              );
            } else {
              List<dynamic> room = snapshot.data!;
              //List<String> names = ["알고리즘", "Java", "토익 700점 목표"];
              return Column(
                children: [
                  const SizedBox(height: 13),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: room.length,
                      itemBuilder: (context, index) {
                        final result = room[index];
                        final name = result.containsKey('name')
                            ? result['name']
                            : 'Name not available';
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 24),
                          title: Text(
                            name,
                            style: TextStyle(fontSize: 16),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RoomPage(),
                            ));
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
