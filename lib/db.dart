import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';
import 'globals.dart' as G;

class SaintsModel {
  final _newSaintSubject = new BehaviorSubject<List<Saint>>();

  Observable<List<Saint>> get saints => _newSaintSubject.observable;

  update({@required DateTime date}) {
    final day = date.day.toString();
    final month = date.month.toString();

    final query = G.db.query('app_saint',
        columns: ['id', 'name', 'zhitie', 'has_icon'],
        where: 'day=$day AND month=$month');

    var dbStream = new Observable.fromFuture(query);

    _newSaintSubject.addStream(dbStream.map((List<Map> data) =>
            new List<Saint>.from(data.map((s) => new Saint(
                id: s['id'],
                name: s['name'],
                day: date.day,
                month: date.month,
                zhitie: s['zhitie'],
                hasIcon: s['has_icon'])))

        ));
  }
}

class Saint {
  int id;
  String name;
  int day;
  int month;
  String zhitie;
  int hasIcon;

  Saint(
      {@required this.id,
      @required this.name,
      @required this.day,
      @required this.month,
      @required this.zhitie,
      @required this.hasIcon});
}
