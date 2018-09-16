import 'package:event_bus/event_bus.dart';

class Constant {
  static final top_bar_height = 30;

  static final List tabs_name = ['发现', '推荐'];

  static final dir_image = 'asset/images/';

  static final pic_url =
      "https://upload.jianshu.io/collections/images/16/computer_guy.jpg";


  static final String REDIRECT_URL = "http://yubo725.top/osc/osc.php";

  static final String LOGIN_URL = "https://www.oschina.net/action/oauth2/authorize?client_id=4rWcDXCNTV5gMWxtagxI&response_type=code&redirect_uri=" + REDIRECT_URL;

  static final String OSC_CLIENT_ID = "4rWcDXCNTV5gMWxtagxI";

  static final String END_LINE_TAG = "COMPLETE";

  static EventBus eventBus = new EventBus();
}