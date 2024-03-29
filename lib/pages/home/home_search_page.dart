import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jeogongtong_front/pages/home/search_result_page.dart';

class HomeSearchPage extends StatefulWidget {
  const HomeSearchPage({super.key});

  @override
  State<HomeSearchPage> createState() => _HomeSearchPageState();
}

class _HomeSearchPageState extends State<HomeSearchPage> {
  bool _showIcon = false;
  Color _buttonColor = const Color(0xff131214);
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: AppBar(
            automaticallyImplyLeading: _showIcon,
            centerTitle: false,
            leadingWidth: 30,
            leading: _showIcon
                ? GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _buttonColor = const Color(0xffFC9AB8);
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _buttonColor = const Color(0xff131214);
                      });
                    },
                    child: Transform.translate(
                      offset: const Offset(7, 0),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: SvgPicture.asset(
                          "assets/images/chevron-left.svg",
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            _buttonColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                : null,
            backgroundColor: Colors.white,
            title: Container(
              width: double.infinity,
              height: 36,
              decoration: BoxDecoration(
                  color: const Color(0xffF2F4F5),
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (text) {
                    if (text.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SearchResultPage(searchQuery: text),
                        ),
                      );
                    }
                  },
                  onChanged: (text) {
                    setState(() {
                      _showIcon = text.isNotEmpty;
                    });
                  },
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 10.0, 12.0, 10.0),
                      child: SvgPicture.asset(
                        "assets/images/search.svg",
                        width: 16,
                        height: 16,
                      ),
                    ),
                    suffixIcon: _showIcon
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: SvgPicture.asset(
                              "assets/images/x.svg",
                              width: 16,
                              height: 16,
                            ),
                            onPressed: () {
                              _controller.clear();
                            },
                          )
                        : null,
                    hintText: 'Search',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 80),
            SvgPicture.asset(
              'assets/images/search.svg',
              width: 75,
              height: 75,
              colorFilter:
                  const ColorFilter.mode(Color(0xffE3E5E5), BlendMode.srcIn),
            ),
            const Text(
              "Search for a study room",
              style: TextStyle(fontSize: 30, color: Color(0xffE3E5E5)),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
