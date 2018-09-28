import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kaiyan_client/widget/common_widget.dart';

class Found extends StatefulWidget {
  Found({Key key}) : super(key: key);

  @override
  _FoundState createState() => _FoundState();
}

class _FoundState extends State<Found> with AutomaticKeepAliveClientMixin{


  dynamic _data;
  List<Widget> widet_List = <Widget>[];

  ScrollController scrollController = ScrollController();


  @override
  void initState() {
    super.initState();

    Dio()
        .get('http://www.wanandroid.com/tools/mockapi/8977/kanyan')
        .then((res){
          _data = res;
          updateData();
    });
  }

  void updateData(){
    final items = _data.data['itemList'];
    String img1 = items[1]['data']['cover']['feed'];
    String img2 = items[2]['data']['cover']['feed'];
    String img3 = items[3]['data']['cover']['feed'];

    widet_List = [
      TitleItem(
        text: '本周排行',
      ),
      ImageItem(
        imgUrl: img2,
      ),
      PicTextItem(
        imgUrl: img3,
        text1: items[3]['data']['title'],
        text2: '#' + items[3]['data']['category'] + '/ 开眼精选',
      ),
      PicTextItem(
        imgUrl: img1,
        text1: items[1]['data']['title'],
        text2: '#' + items[1]['data']['category'] + '/ 开眼精选',
      ),
      TitleItem(
        text: '热门分类',
      ),
      RoundRectItem(
        imgUrl: items[3]['data']['author']['icon'],
        text1: items[3]['data']['author']['name'],
        text2: items[3]['data']['author']['description'],
      ),
      RoundRectItem(
        imgUrl: items[2]['data']['author']['icon'],
        text1: items[2]['data']['author']['name'],
        text2: items[2]['data']['author']['description'],
      ),
      RoundRectItem(
        imgUrl: items[1]['data']['author']['icon'],
        text1: items[1]['data']['author']['name'],
        text2: items[1]['data']['author']['description'],
      ),
      TitleItem(
        text: '近期专题',
      ),
      buildPageView(),
      TitleItem(
        text: '热门评论',
      ),
    ];

    addComments();
    /// It is an error to call [setState] unless [mounted] is true.
    if (this.mounted){setState((){});}
  }


  @override
  Widget build(BuildContext context) {
    return _data == null
        ? Center(child: CircularProgressIndicator(),)
        : ListView.builder(
        controller: scrollController,
        itemCount: widet_List.length,
        itemBuilder: (c, i){
          return widet_List[i];
        }
    );
  }


  Widget buildPageView(){
    final items = _data.data['itemList'];
    return Container(
      height: 200.0,
      width: double.infinity,
      child: PageView.builder(
          controller: PageController(viewportFraction: 0.85),
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (c, i){
            final item = items[i]['data'];
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: Image.network(
                item['cover']['feed'],
                fit: BoxFit.cover,
              ),
            );
          }
      ),
    );
  }


  Widget buildItem(
      String imgUrl, String imgAvatar, String name, String itemText1) {
    return Column(
      children: <Widget>[
        AvatarItem(
          imgUrl: imgAvatar,
          text1: name,
        ),
        Container(
          padding: EdgeInsets.only(left: 50.0),
          height: 120.0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.grey[200],
                shape: BoxShape.rectangle),
            padding: EdgeInsets.all(10.0),
            child: PicTextItem(
              imgUrl: imgUrl,
            ),
          ),
        )
      ],
    );
  }




  void addComments(){
    _data.data['itemList'].forEach((it){
      final item = it['data'];
      widet_List.add(buildItem(item['cover']['feed'],  item['author']['icon'], item['author']['name'], item['title']));
    });
  }

  @override
  bool get wantKeepAlive => true;
}