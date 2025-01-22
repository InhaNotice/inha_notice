import 'package:flutter/material.dart';
import 'package:inha_notice/main.dart';
import 'package:inha_notice/screens/bottom_navigation/search/search_result_page.dart';
import 'package:inha_notice/services/trending_topics_api.dart';
import 'package:inha_notice/screens/bottom_navigation/search/topics_item.dart';
import 'package:inha_notice/fonts/font.dart';
import 'package:inha_notice/themes/theme.dart';

typedef TopicsList = List<Map<String, dynamic>>;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final TrendingTopicsAPI _trendingTopicsApi = TrendingTopicsAPI();

  late final List<AnimationController> _controllers = [];
  late final List<Animation<double>> _animations = [];

  TopicsList _topicsList = [];
  String _warning = Font.kEmptyString;
  String _makeTimes = Font.kEmptyString;

  @override
  void initState() {
    super.initState();
    _fetchTrendingTopics();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
    super.dispose();
  }

  Future<void> _fetchTrendingTopics() async {
    try {
      final response = await _trendingTopicsApi.fetchTrendingTopics();
      setState(() {
        _topicsList = response;
        if (response.isNotEmpty) {
          _makeTimes = response.first['makeTimes'] ?? '';
        }
      });
      _initializeAnimations();
      _triggerAnimations();
    } catch (error) {
      setState(() {
        _topicsList = [];
        _warning = '인기검색어를 불러오지 못하였습니다.';
      });
    }
  }

  void _initializeAnimations() {
    if (_topicsList.isEmpty) {
      return;
    }
    try {
      for (int i = 0; i < _topicsList.length; i++) {
        final controller = AnimationController(
          duration: const Duration(seconds: 1),
          vsync: this,
        );
        _controllers.add(controller);
        final animation = Tween(begin: 0.0, end: 1.0).animate(controller);
        _animations.add(animation);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _triggerAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      // 순차적으로 지연
      await Future.delayed(Duration(milliseconds: 300 * i));

      // mounted 확인
      if (!mounted) {
        print('Widget disposed, stopping animations');
        return;
      }

      try {
        await _controllers[i].forward();
      } catch (e) {
        print('Error during animation: $e');
      }
    }
  }

  void _search() {
    if (_searchController.text.length < 2) {
      setState(() {
        _warning = '검색어는 두 글자 이상 입력해주세요.';
      });
      return;
    }
    setState(() {
      _warning = Font.kEmptyString;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultPage(query: _searchController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: false,
          title: Text(
            '검색',
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontFamily: Font.kDefaultFont,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Theme.of(context).iconTheme.color),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                            fontFamily: Font.kDefaultFont,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).textTheme.bodyMedium?.color ?? Theme.of(context).defaultColor,
                          ),
                          decoration: const InputDecoration(
                            hintText: '검색어를 입력하세요',
                            hintStyle: TextStyle(
                              fontFamily: Font.kDefaultFont,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFFC4C4C4),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey, // 비활성 상태 경계선 색상
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey, // 포커스 상태 경계선 색상
                                width: 2.0,
                              ),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey, // 에러 상태 경계선 색상
                                width: 2.0,
                              ),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey, // 비활성화 상태 경계선 색상
                                width: 2.0,
                              ),
                            ),
                          ),
                          onSubmitted: (_) => _search(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '최근 검색 기록',
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    Text(
                      '전체 삭제',
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '실시간 인기 검색어',
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    Text(
                      _makeTimes,
                      style: TextStyle(
                        fontFamily: Font.kDefaultFont,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _topicsList.isEmpty
                      ? Center(
                      child: Text(
                        '실시간 인기 검색어를 불러오고 있습니다...',
                        style: TextStyle(
                          fontFamily: Font.kDefaultFont,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ))
                      : ListView.builder(
                    itemCount: _topicsList.length,
                    itemBuilder: (context, index) {
                      final topics = _topicsList[index];
                      return TopicsItem(
                          topic: topics, rank: index + 1, animation: _animations[index]);
                    },
                  ),
                ),
              ],
            )));
  }
}

Widget _buildTag(BuildContext context, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    decoration: BoxDecoration(
      color: const Color(0xFF424242),
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Text(
      text,
      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color,),
    ),
  );
}