import 'dart:async';

import 'package:Expenses/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseController<T> {
  final String path;
  Future<Database> database;

  DatabaseController(this.path)  {
    database = _init();
  }

  @protected
  FutureOr<void> _onCreate(Database db, int version);

  Future<Database> _init() async {
    return openDatabase(
      join(await getDatabasesPath(), this.path),
      onCreate: _onCreate,
      version: 1,
    );
  }

  @protected
  Future<void> insert(dynamic value);

  @protected
  Future<void> delete(dynamic value);

  @protected
  Future<List<T>> select(dynamic value);

  @protected
  Future<void> update(dynamic value);
}

class ExpensiveDatabaseController extends DatabaseController<ExpenseData> {
  ExpensiveDatabaseController(String path) : super(path);

  @override
  FutureOr<void> _onCreate(Database db, int version) async {
    return db.execute(
      '''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY, 
        category TEXT, 
        description TEXT,
        amount INTEGER,
        date INTEGER
      )
      ''',
    );
  }

  @override
  Future<void> insert(value) async {
    final db = await database;
    final expenseData = value as ExpenseData;
    await db.insert(
      'expenses',
      expenseData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> delete(value) async {
    final db = await database;
    await db.delete(
      'expenses',
      where: "id = ?",
      whereArgs: [value.id],
    );
  }

  @override
  Future<List<ExpenseData>> select(value) async {
    final db = await database;
    final period = value as DateTimeRange;
    final start = period.start;
    final end = convertDateTime(period.end).add(Duration(days: 1)).subtract(Duration(seconds: 1));
    final List<Map<String, dynamic>> maps =
      await db.query(
        'expenses',
        where: "date >= ? and date <= ?",
        whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
        orderBy: 'date desc'
      );

    return List.generate(maps.length, (i) {
      return ExpenseData(
        Expense(
          maps[i]['description'],
          maps[i]['amount'],
          DateTime.fromMillisecondsSinceEpoch(maps[i]['date']),
        ),
        ExpenseCategories.determine(maps[i]['category']),
        id: maps[i]['id'],
      );
    });
  }

  @override
  Future<void> update(value) async {
    final db = await database;
    await db.update(
      'expenses',
      value.toMap(),
      where: "id = ?",
      whereArgs: [value.id],
    );
  }
}
