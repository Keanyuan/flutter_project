import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:kaiyan_client/widget/type_text.dart';

class DissertationController extends StatefulWidget {
  DissertationController({Key key}):super(key: key);

  @override
  _DissertationController createState() => _DissertationController();
}
class _DissertationController extends State<DissertationController> {
  dynamic _data;
  List widgets = [];
  @override
  void initState() {
    super.initState();
    reqData();
  }

  @override
  Widget build(BuildContext context) {

    return new Container(
      color: Colors.grey[200],
      child: new Scaffold(
        appBar: new AppBar(
          title: new Center(
            child: new Text(
              '列表',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 26.0)
            ),
          ),
          backgroundColor: Colors.red[200],
          actions: <Widget>[
            new IconButton(
                icon: new Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: (){
                  setState(() {
                    reqData();
                  });
                }),
          ],
        ),
        body: getBody(),
      )

    );
  }
  
  showLoadingDialog(){
    if(widgets.length == 0){
      return true;
    } 
    return false;
  }
  getProgressDialog(){
    return Center(child: CircularProgressIndicator(backgroundColor: Colors.red,),);
  }
  
  getBody(){
    if(showLoadingDialog()) {
      return getProgressDialog();
    }
    
    return getListView();
  }
  
  ListView getListView() => ListView.builder( 
      itemCount: widgets.length,
      itemBuilder: (BuildContext context, int index){
        return getRow(index);
      });
  
 Widget getRow(int index){
   return GestureDetector(
     onTap: (){
       print(widgets[index]['description']);
     },
     child: Stack(
       children: [
         Container(
           color: Colors.white,
           margin: EdgeInsets.only(bottom: 1.0),
//           width: double.infinity,
           height: 254.0,
           child: Image.network(
             widgets[index]['cover']['feed'],
             fit: BoxFit.cover,
           ),
         ),
         Container(
           margin: EdgeInsets.symmetric(horizontal: 10.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               Text(
                 widgets[index]['title'],
                 style: TextStyle(
                   fontSize: 18.0,
                   fontFamily: 'FZLanTing',
                   color: Colors.white,
                   letterSpacing: 2.0
                 ),
               ),
               Container(
                 color: Colors.transparent,
                 height: 10.0,
                 width: double.infinity,
               ),
               Text(
                 widgets[index]['description'],
                 style: TextStyle(
                     fontSize: 14.0,
                     fontFamily: 'FZLanTing',
                     color: Colors.white,
                     letterSpacing: 2.0
                 ),
               ),
             ],
           ),
         )
       ],
     ),
   );
 } 

  void reqData(){
    Dio()
        .get("http://www.wanandroid.com/tools/mockapi/8977/kanyan")
        .then((res){
          widgets = [];
          _data = res;
          final items = _data.data['itemList'];
          items.forEach((it){
            final item = it['data'];
            widgets.add(item);
            //刷新一定要加setState
            setState(() {});
          });
    });
  }
}