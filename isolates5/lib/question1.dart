import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp(data: '',));
}


bool isLoading = true;

class MyApp extends StatefulWidget {

  final String data;

  MyApp({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState(data: '');
}

class _MyAppState extends State<MyApp> {

  GamesApiService gas = GamesApiService();
  DBHelper dbhelper = DBHelper();

  bool isFirebaseEmpty = true;
  String category;
  String data;

  /* Not Important */
  _MyAppState({
    @required this.data,
  });


  /* not that important */
  void refresh() {
    print('== REFRESH ==');
    isLoading = true;
    getCategory().then((value) {
      isLoading = false;
      setState(() { });
    });
  }

  ///***************************************************************/
  /* INIT STATE*/
  @override
  void initState(){
    super.initState();

    dbhelper.deleteExistingTables().then((value) {

    });

    isLoading = true;
    /* IMPORTANT */
    /* First initialize Firebase,
    * then check if the collection 'games' is empty
    * then do the necessary things according to data */
    Firebase.initializeApp().then((value) {
      /* IMPORTANT */
      // GET THE CATEGORY FROM SHARED PREFERENCES
      // AND REMOVE LOADING STATE TO MAKE THE FutureBuilder WORKS

      // Start FutureBuilder after getCategory();
      getCategory().then((value) {
        createIsolate(category).then((value) {
          isLoading = false;
          setState(() {});
        });
      });


    });

  }
  ///***************************************************************/

  Future<String> getCategory() async{
    print('== get category ==');
    category = await SharedPref().getCategory();
    if(category == null) {
      await SharedPref().setCategory("pvp");
      category = "pvp";
      print('SHARED PREFERENCES CATEGORY IS EMPTY');
    }
  }


  /// ISOLATE //////
  Future createIsolate(String category) async{
    ReceivePort receivePort = ReceivePort();
    var isolate = Isolate.spawn(isolateFunction, receivePort.sendPort);

    SendPort childSendPort = await receivePort.first;

    ReceivePort responsePort = ReceivePort();
    childSendPort.send([category,responsePort.sendPort]);

    var response = await responsePort.first;

    DBHelper dbhelper = DBHelper();

    for(Game element in response){
      print('ISOLATE: insert ${element.title}');
      dbhelper.insertGame(category, element.title);
    }

    isolate.then((value){
      print('KILL ISOLATE = $category');
      value.kill();
    });
  }

  static void isolateFunction(SendPort mainSendPort) async {
    ReceivePort childReceivePort  = ReceivePort();
    mainSendPort.send(childReceivePort.sendPort);

    await for(var message in childReceivePort){
      String category = message[0];
      SendPort replyPort = message[1];

      print('CATEGORY IN THE ISOLATE = $category');

      var apiService = GamesApiService();
      List gameList = await apiService.getObjects(category: category);

      replyPort.send(gameList);
    }
  }
  /// ISOLATE //////



  /* CREATE THE FUTURE BUILDER OF THE LIST HERE */
  Widget listFutureBuilderCreator(){
    /* SHOW LOADING PAGE IF STILL LOADING */
    if(isLoading == true){
      print(' STILL WAITING FOR SHARED PREF.. FutureBuilder did not work..');
      return Center(child: CircularProgressIndicator());
    }
    else{

      return FutureBuilder(
        /* GET OBJECTS FROM THE API */
          future: dbhelper.getDataFromDatabase(category),
          builder: (BuildContext context, AsyncSnapshot snapshot)
          {
            print('=== Snapshot data taken ====');
            if(snapshot.connectionState == ConnectionState.waiting)
            {
              print('=== WAITING FOR DATA ====');
              return Center(child: CircularProgressIndicator());
            }
            else {
              if(snapshot.hasData == false)
              {
                print('=== NO DATA ===');
                return Center(child: Icon(Icons.error_outline_outlined));
              }
              else
              {
                print('=== DATA FOUND ===');
                List gameList = snapshot.data;
                int length = gameList.length;
                if(length >= 10)
                  length = 10;
                return ListView.separated(
                  itemCount: length,
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                  itemBuilder: (BuildContext context, int index)
                  {
                    String game = gameList[index];
                    /* IMPORTANT! ADD THE GAMES TO COLLECTION */
                    AddGameToFire().addGame('$game');
                    /* IMPORTANT! ADD THE GAMES TO COLLECTION */
                    return ListTile(
                      title: Text('$game'),
                    );
                  },
                );
              }
            }
          }
      );
    }
  }

  Future<void> addGamesToCollection() async{
    print('== get category ==');
    var category = await SharedPref().getCategory();
    /* Change local category which is null initially */
    this.category = category;
    /* Start Api Service with category value */
    setState(() {
    });

    /* Get Games From API with initialized category... */
    var gameList = await gas.getObjects();
    int length = gameList.length;

    for(int i=0; i<length; i++){
      /* ADD 10 GAME TO THE COLLECTION */
      if(i<10) {
        var game = gameList[i];
        AddGameToFire().addGame('${game.title}');
      }
    }
  }

  /// SCAFFOLD ///
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: '/',
        home: Scaffold(
            appBar: AppBar(
              title: Text('Free To Play Games Database'),
              actions: <Widget>[ PopUpOptionsMenu() ],
            ),
            body: Container(
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FlatButton(
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 100,
                        color: Colors.amber,
                        child: Text('REFRESH'),
                      ),
                      onPressed: (){
                        refresh();
                      },
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
                        child: Text('Category: $category')
                    ),
                    Expanded(
                      /* ============= FUTURE BUILDER =============== */
                      child: listFutureBuilderCreator(),
                      /* ============= FUTURE BUILDER =============== */

                    ),
                  ]
              ),
            )
        )
    );
  }

  Future<bool> checkIfFirebaseEmpty() async{
    print('');
    print('### CHECK IF FIREBASE EMPTY ### ');
    print('');
    bool emptyState = await GetGamesFromFire().checkIfEmpty();
    print('RETURN STATE = $emptyState');
    return emptyState;
  }
}

////////////////////////// AUTH SERVICE /////////////////////////////

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign in anonymously
  Future signInAnon() async {
    try{
      UserCredential result = await _auth.signInAnonymously();
      print('## SIGN IN RESULT = $result');
    }
    catch(e){

    }
  }

  void listenForAuthState(){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }
}

////////////////////////// FIRESTORE SERVICES /////////////////////////////
class AddGameToFire {
  Future<void> addGame(String gameTitle){
    CollectionReference games = FirebaseFirestore.instance.collection('games');
    return games.add({
      'name': gameTitle
    });
  }
}
// .then((value) => print('%%%%%% $gameTitle added to FireStore... %%%%%%'));

class GetGamesFromFire {

  Future<List<String>> getGames() async {
    CollectionReference games = FirebaseFirestore.instance.collection('games');

    List<String> gameList = List<String>();

    var snapshot = await games.get();
    print('');
    print('## SNAPSHOT HAS TAKEN ##');
    print('');
    snapshot.docs.forEach((element) {
      String name = element['name'];
      print('$name');
      gameList.add(name);
    });
    print('');
    print('## RETURN GAMELIST ##');
    print('');
    return gameList;

  }

  Future<bool> checkIfEmpty() async {
    CollectionReference games = FirebaseFirestore.instance.collection('games');

    var snapshot = await games.get();
    if (snapshot.size > 0) {
      print('NOT EMPTY');
      return false;
    }
    else{
      print('EMPTY');
      return true;
    }
  }
}


////////////////////////// OPTIONS MENU /////////////////////////////

class PopUpOptionsMenu extends StatefulWidget {
  @override
  _PopUpOptionsMenuState createState() => _PopUpOptionsMenuState();
}

class _PopUpOptionsMenuState extends State<PopUpOptionsMenu> {

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context){
        return <PopupMenuEntry>[
          PopupMenuItem(
            child: Text('Settings'),
            value: 'settings',
          ),
        ];
      },
      onSelected: (value){
        if(value == 'settings') {
          print('$value SELECTED');
          isLoading = true;
          Navigator.of(context).pushNamed('/settings', arguments: '$value');
        }
      },
    );
  }
}



////////////////////////// SETTINGS PAGE /////////////////////////////

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  String selectedCategory;

  List<String> categories = List<String>();
  @override
  void initState(){
    super.initState();
    categories.add('shooter');
    categories.add('mmofps');
    categories.add('pvp');
    categories.add('mmorpg');

    SharedPref().getCategory().then((category){
      setState(() {
        print('CATEGORY IN SHARED = $category');
        selectedCategory = category;
      });
    });
  }

  setSelectedCategory(String val){
    setState(() {
      selectedCategory = val;
    });
  }

  List<Widget> createRadioListUsers()
  {
    List<Widget> widgets = [];
    for(String category in categories)
    {
      widgets.add(
          RadioListTile(
            value: category,
            groupValue: selectedCategory,
            title: Text('$category'),
            onChanged: (value){
              print('$value IS SELECTED');
              setSelectedCategory(value);
            },
            selected: selectedCategory == category,
          )
      );
    }
    return widgets;
  }

  /// SCAFFOLD ///
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.fromLTRB(15, 25, 15, 10),
          child: Column(
              children: [
                Column(children: createRadioListUsers()),
                FlatButton(
                  child: Container(
                    height: 40,
                    width: 100,
                    color: Colors.red,
                  ),
                  onPressed: (){
                    SharedPref().setCategory(selectedCategory).then((value) {
                      print('CATEGORY ==$selectedCategory== HAS BEEN WRITTEN TO SHARED PREF ');
                      Navigator.of(context).pop();
                    });

                  },
                )
              ]
          ),
        ),
      ),
    );
  }
}

////////////////////////// SHARED PREFERENCES /////////////////////////////

class SharedPref{
  Future<void> setCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('category', category);
    print('SHARED PREF SET category= $category');
  }

  Future<String> getCategory() async {
    final prefs = await SharedPreferences.getInstance();
    final category = prefs.getString('category');
    print('SHARED PREF GET category= $category');
    return category;
  }

}


////////////////////////// WEB SERVICE /////////////////////////////

class WebService{
  Future<List> getData(String url) async
  {
    Response response = await get(url);
    List data = jsonDecode(response.body);

    print('');
    print('##### DATA HAS FETCHED SUCCESSFULLY !  url= $url #####');
    print('');

    return data;
  }
}

////////////////////////// GAME CLASS /////////////////////////////
class Game{
  int id;
  String title;
  String thumbnail;
  String description;
  String shortDescription;
  String publisher;
  String gameUrl;
  String genre;
  String platform;
  String developer;
  String freeToGameProfileUrl;
  String releaseDate;
  List systemRequirements;
  List screenshots;


  Game({this.id, this.title, this.thumbnail, this.description,
    this.shortDescription, this.publisher, this.gameUrl, this.genre,
    this.platform, this.developer, this.freeToGameProfileUrl,
    this.releaseDate, this.systemRequirements, this.screenshots,});
}


////////////////////////// GAMES API SERVICE /////////////////////////////
class GamesApiService{

  WebService ws = WebService();
  String singleGameUrl = 'https://www.freetogame.com/api/game?';
  String multipleGameUrl = 'https://www.freetogame.com/api/games?';
  String allGameUrl = 'https://www.freetogame.com/api/games';


  Future<List> getObjects({String platform, String category, String sortBy, int requestSingleGameId}) async{
    print('== Get Objects ==');

    StringBuffer sb = StringBuffer();

    if(requestSingleGameId != null){
      print('Get Single Game');
      return await ws.getData("${singleGameUrl}id=$requestSingleGameId");
    }
    else
    {
      sb.write("$multipleGameUrl");

      int requestCount = 0;

      if (sortBy != null) {
        print('Sort By..');
        sb.write('sort-by=$sortBy');
        requestCount++;
      }

      if (category != null) {
        print('Category...');
        if (requestCount > 0) {
          sb.write('&');
        }
        sb.write('category=$category');
        requestCount++;
      }

      if (platform != null) {
        print('Platform...');
        if (requestCount > 0) {
          sb.write('&');
        }
        sb.write('platform=$platform');
        requestCount++;
      }
    }


    print('===== Final url== ${sb.toString()} =====');
    List responseList = await ws.getData(sb.toString());
    int length = responseList.length;

    List<Game> objectList = List<Game>();

    for(int i=0; i<length; i++){

      int id = responseList[i]['id'];
      String title = responseList[i]['title'];
      String thumbnail = responseList[i]['thumbnail'];
      String description = responseList[i]['description'];
      String shortDescription = responseList[i]['short_description'];
      String publisher = responseList[i]['publisher'];
      String gameUrl = responseList[i]['game_url'];
      String genre = responseList[i]['genre'];
      String platform = responseList[i]['platform'];
      String developer = responseList[i]['developer'];
      String freeToGameProfileUrl = responseList[i]['freetogame_profile_url'];
      String releaseDate = responseList[i]['release_date'];
      List systemRequirements = responseList[i]['minimum_system_requirements'];
      List screenshots = responseList[i]['screenshots'];

      Game game = Game(id: id,title: title,thumbnail: thumbnail,description: description,
          shortDescription: shortDescription, publisher: publisher, gameUrl: gameUrl, genre: genre,
          platform: platform, developer: developer,freeToGameProfileUrl: freeToGameProfileUrl,
          releaseDate: releaseDate, systemRequirements: systemRequirements,screenshots: screenshots);

      objectList.add(game);
    }

    return objectList;
  }
}

/////////////////////////// DATABASE ///////////////////////////////////


class DBHelper{

  static Database _database;
  static DBHelper _dbHelper;

  String pvpTable = 'pvp_table';
  String shooterTable = 'shooter_table';
  String mmofpsTable = 'mmofps_table';
  String mmorpgTable = 'mmorpg_table';

  String colId = 'id';
  String colName = 'name';

  Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  DBHelper._createInstance();

  factory DBHelper() {
    if (_dbHelper == null) {
      _dbHelper = DBHelper._createInstance(); // This is executed only once, singleton object
    }
    return _dbHelper;
  }


  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'games.db';

    var database = await openDatabase(
        path,
        version: 1,
        onCreate: _createDB
    );

    return database;
  }

  void _createDB(Database database,int newVersion) async{

    await database.execute('''
      CREATE TABLE $pvpTable(
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colName TEXT NOT NULL
      )
    ''');

    await database.execute('''
      CREATE TABLE $shooterTable(
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colName TEXT NOT NULL
      )
    ''');

    await database.execute('''
      CREATE TABLE $mmofpsTable(
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colName TEXT NOT NULL
      )
    ''');

    await database.execute('''
      CREATE TABLE $mmorpgTable(
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colName TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertGame(String category, String name){
    if(category == "pvp")
      return insertName(pvpTable, name);
    if(category == "shooter")
      return insertName(shooterTable, name);
    if(category == "mmofps")
      return insertName(mmofpsTable, name);
    if(category == "mmorpg")
      return insertName(mmorpgTable, name);
    return null;
  }

  // Future<int> insertPvp(String name) async{
  //   return insertName(pvpTable, name);
  // }
  // Future<int> insertShooter(String name) async{
  //   return insertName(shooterTable, name);
  // }
  // Future<int> insertMmofps(String name) async{
  //   return insertName(mmofpsTable, name);
  // }
  // Future<int> insertMmorpg(String name) async{
  //   return insertName(mmorpgTable, name);
  // }

  Future<List> getDataFromDatabase(String category) async{
    if(category == "pvp")
      return await _getPvpList();
    if(category == "shooter")
      return await _getShooterList();
    if(category == "mmofps")
      return await _getMmofpsList();
    if(category == "mmorpg")
      return await _getMmorpgList();
  }

  Future<List> _getPvpList() async{
    return await getDataList(pvpTable);
  }
  Future<List> _getShooterList() async{
    return await getDataList(shooterTable);
  }
  Future<List> _getMmofpsList() async{
    return await getDataList(mmofpsTable);
  }
  Future<List> _getMmorpgList() async{
    return await getDataList(mmorpgTable);
  }


  Future deletePvp() async{
    deleteTable(pvpTable);
  }
  Future deleteShooter() async{
    deleteTable(shooterTable);
  }
  Future deleteMmofps() async{
    deleteTable(mmofpsTable);
  }
  Future deleteMmorpg() async{
    deleteTable(mmorpgTable);
  }

  Future deleteExistingTables() async {
    var map = await getMapList("sqlite_master");

    for(Map<String,dynamic> element in map){
      String name = element["tbl_name"];
      if(name == "pvp_table") {
        deleteTable(pvpTable);
        print("$name deleted");
      }
      if(name == "shooter_table") {
        deleteTable(shooterTable);
        print("$name deleted");
      }
      if(name == "mmofps_table") {
        deleteTable(mmofpsTable);
        print("$name deleted");
      }
      if(name == "mmorpg_table") {
        deleteTable(mmorpgTable);
        print("$name deleted");
      }
    }
  }


  // Fetch Operation: Get all investment objects from database
  Future<List<Map<String, dynamic>>> getMapList(String table) async {
    Database db = await this.database;

    var result = await db.query(table);
    return result;
  }

  // Insert Operation: Insert a Investment object to database
  Future<int> insertName(String table, String name) async {
    Database db = await this.database;
    print('$name added to $table');
    var result = await db.insert(table, {"name":name});
    return result;
  }


  // Delete Operation: Delete a Investment object from database
  Future<int> deleteGame(String table, int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $table WHERE $colId = $id');

    print("deleteFrom= $table, delete= $id");
    return result;
  }

  Future<void> deleteTable(String table) async{
    var db = await this.database;
    print("delete $table");
    await db.delete(table);
  }

  // Get number of Investment objects in database
  Future<int> getCount(String table) async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $table');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Investment List' [ List<Investment> ]
  Future<List<String>> getDataList(String table) async {
    var mapList = await getMapList(table); // Get 'Map List' from database
    int count = mapList.length;         // Count the number of map entries in db table

    List<String> nameList = List<String>();
    // For loop to create a 'Investment List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      print('GET INVESTMENT FROM DB = ${mapList[i]}');
      nameList.add(mapList[i]["name"]);
    }

    return nameList;
  }
}




////////////////////////// ROUTE GENERATOR /////////////////////////////

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args  = settings.arguments;

    switch (settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => MyApp(data: args));
      case '/settings':
        return MaterialPageRoute(builder: (_) => Settings());

    }
  }
}




