
import 'package:kaiyan_client/gsd/common/redux/EventRedux.dart';
import 'package:redux/redux.dart';

class EventDao {
  static clearEvent(Store store) {
    store.state.eventList.clear();
    store.dispatch(new RefreshEventAction([]));
  }
}