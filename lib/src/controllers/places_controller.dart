import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import '../models/place.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, long REAL, address TEXT)');
    },
    version: 1,
  );
  return db;
}

class PlacesNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() => const [];

  loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_place');
    final places = data
        .map((row) => Place(
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
                address: row['address'] as String,
                latitude: row['lat'] as double,
                longitude: row['long'] as double)))
        .toList();
    state = places;
  }

  addPlace(String title, File image, PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');
    final newPlace =
        Place(title: title, image: copiedImage, location: location);
    final db = await _getDatabase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'long': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [newPlace, ...state];
  }
}

final placesProvider =
    NotifierProvider<PlacesNotifier, List<Place>>(() => PlacesNotifier());
