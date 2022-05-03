import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static const DB_NAME = 'lcp-test8.db';
  static const DB_VERSION = 1;
  static Database _database;

  DBProvider._internal();

  static final DBProvider instance = DBProvider._internal();
  static const initScripts = [
    CREATE_TABLE_PRODUCT_Q,
    CREATE_TABLE_CART_ITEMS_Q
  ];

  init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), DB_NAME),
      onCreate: (db, version) {
        initScripts.forEach((element) async => await db.execute(element));
      },
      onUpgrade: (db, oldVersion, newVersion) {},
      version: DB_VERSION,
    );
  }

  Database get database => _database;

  // static const CREATE_TABLE_PRODUCT_Q = '''
  //     CREATE TABLE $TABLE_PRODUCT(
  //                   product_id TEXT PRIMARY KEY,
  //                   productName TEXT,
  //                   description TEXT,
  //                   briefDescription TEXT,
  //                   images TEXT,
  //                   colors INTEGER,
  //                   defaultPrice REAL,
  //                   category TEXT,
  //                   isFavourite INTEGER,
  //                   remainingSize TEXT,
  //                   weight TEXT
  //         );
  //   ''';
  static const TABLE_PRODUCT = 'Product';
  static const CREATE_TABLE_PRODUCT_Q = '''
      CREATE TABLE IF NOT EXISTS $TABLE_PRODUCT(
                    productId TEXT PRIMARY KEY,
                    productCode TEXT,
                    systemCategoryId TEXT,
                    productName TEXT,
                    description TEXT,
                    briefDescription TEXT,
                    images TEXT,
                    color TEXT,
                    defaultPrice REAL,
                    category TEXT,
                    isFavorite INTEGER,
                    remainingSize TEXT,
                    status INTEGER,
                    weight FLOAT,
                    size TEXT,
                    belongTo TEXT, 
                    residentId TEXT,
                    maxBuy INT
          );
    ''';

  static const TABLE_CART_ITEMS = 'CartItems';

  static const CREATE_TABLE_CART_ITEMS_Q = '''
            CREATE TABLE IF NOT EXISTS $TABLE_CART_ITEMS (
              cart_items_id INTEGER PRIMARY KEY,
              productId TEXT NOT NULL UNIQUE,
              quantity INTEGER NOT NULL,
              FOREIGN KEY (productId) REFERENCES Product (productId)
            );
         ''';
}
