import 'dart:io';
import 'dart:math';

// 1. Классы «Кружка» и «Человек»
class Cup {
  double volume;
  double currentVolume;

  Cup(this.volume) : currentVolume = volume;

  void fill() {
    currentVolume = volume;
    print('Кружка наполнена до краёв (${volume} мл).');
  }

  void drink(double amount) {
    if (amount <= currentVolume) {
      currentVolume -= amount;
      print('Выпито $amount мл. Осталось ${currentVolume.toStringAsFixed(2)} мл.');
    } else {
      print('В кружке недостаточно жидкости (есть только ${currentVolume.toStringAsFixed(2)} мл).');
    }
  }
}

class Person {
  String name;

  Person(this.name);

  void drinkFromCup(Cup cup, double amount) {
    print('$name пьёт из кружки.');
    cup.drink(amount);
  }
}

// 2. Класс «Шкаф» с системами хранения
abstract class StorageSystem {
  Map<String, dynamic> items = {};

  void put(String key, dynamic item);
  dynamic take(String key);
}

class Shelf extends StorageSystem {
  @override
  void put(String key, dynamic item) {
    items[key] = item;
    print('На полку положено: $key -> $item');
  }

  @override
  dynamic take(String key) {
    if (items.containsKey(key)) {
      var item = items.remove(key);
      print('С полки взято: $key -> $item');
      return item;
    } else {
      print('На полке нет предмета с ключом "$key"');
      return null;
    }
  }
}

class Drawer extends StorageSystem {
  @override
  void put(String key, dynamic item) {
    items[key] = item;
    print('В ящик положено: $key -> $item');
  }

  @override
  dynamic take(String key) {
    if (items.containsKey(key)) {
      var item = items.remove(key);
      print('Из ящика взято: $key -> $item');
      return item;
    } else {
      print('В ящике нет предмета с ключом "$key"');
      return null;
    }
  }
}

class Wardrobe {
  List<StorageSystem> storageSystems;

  Wardrobe(this.storageSystems);

  void putItem(StorageSystem system, String key, dynamic item) {
    system.put(key, item);
  }

  dynamic takeItem(StorageSystem system, String key) {
    return system.take(key);
  }
}

// 3. Классы «Гриф» и «Блин»
class Plate {
  double weight;

  Plate(this.weight);
}

class Barbell {
  final double maxLoad;
  double leftWeight = 0.0;
  double rightWeight = 0.0;
  List<Plate> leftPlates = [];
  List<Plate> rightPlates = [];

  Barbell(this.maxLoad);

  bool addPlateLeft(Plate plate) {
    if (leftWeight + plate.weight <= maxLoad / 2 &&
        leftWeight + plate.weight + rightWeight <= maxLoad) {
      leftPlates.add(plate);
      leftWeight += plate.weight;
      print('Добавлен блин ${plate.weight} кг слева. Общий вес слева: $leftWeight кг');
      return true;
    } else {
      print('Нельзя добавить блин ${plate.weight} кг слева: превышение максимальной нагрузки.');
      return false;
    }
  }

  bool addPlateRight(Plate plate) {
    if (rightWeight + plate.weight <= maxLoad / 2 &&
        leftWeight + rightWeight + plate.weight <= maxLoad) {
      rightPlates.add(plate);
      rightWeight += plate.weight;
      print('Добавлен блин ${plate.weight} кг справа. Общий вес справа: $rightWeight кг');
      return true;
    } else {
      print('Нельзя добавить блин ${plate.weight} кг справа: превышение максимальной нагрузки.');
      return false;
    }
  }

  double totalWeight() => leftWeight + rightWeight;
}

// 4. Класс для конвертации валют
class CurrencyConverter {
  static const Map<String, double> rates = {
    'USD': 1.0,
    'EUR': 0.92,
    'RUB': 90.5,
    'GBP': 0.79,
  };

  static double convert(double amount, String from, String to) {
    if (!rates.containsKey(from) || !rates.containsKey(to)) {
      throw Exception('Неизвестная валюта. Доступны: USD, EUR, RUB, GBP');
    }
    double inUSD = amount / rates[from]!;
    return inUSD * rates[to]!;
  }
}

// 5. Класс с перегруженными арифметическими операциями (вектор)
class Vector2 {
  double x, y;

  Vector2(this.x, this.y);

  Vector2 operator +(Vector2 other) => Vector2(x + other.x, y + other.y);
  Vector2 operator -(Vector2 other) => Vector2(x - other.x, y - other.y);
  Vector2 operator *(double scalar) => Vector2(x * scalar, y * scalar);
  Vector2 operator /(double scalar) => Vector2(x / scalar, y / scalar);
  bool operator ==(Object other) =>
      other is Vector2 && x == other.x && y == other.y;
  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Vector2($x, $y)';
}

// 6. Класс «Автомобиль» с перечислениями
enum CarState { stop, moving, turning }

enum TurnDirection { left, right }

class Car {
  CarState state = CarState.stop;

  void go() {
    state = CarState.moving;
    print('Автомобиль начал движение.');
  }

  void stop() {
    state = CarState.stop;
    print('Автомобиль остановился.');
  }

  void turn(TurnDirection direction) {
    state = CarState.turning;
    print('Автомобиль поворачивает ${direction == TurnDirection.left ? 'налево' : 'направо'}.');
    state = CarState.moving;
  }
}

// 7. Базовый класс «Геометрическая фигура» и производные
abstract class Shape {
  double area();
}

class Rectangle extends Shape {
  double width, height;
  Rectangle(this.width, this.height);
  @override
  double area() => width * height;
}

class Triangle extends Shape {
  double base, height;
  Triangle(this.base, this.height);
  @override
  double area() => 0.5 * base * height;
}

class Circle extends Shape {
  double radius;
  Circle(this.radius);
  @override
  double area() => pi * radius * radius;
}

// 8. Класс для перевода систем счисления
class BaseConverter {
  static String fromDecimal(int number, int base) {
    if (base == 10) return number.toString();
    if (base == 16) return number.toRadixString(16).toUpperCase();
    if (base == 8) return number.toRadixString(8);
    throw Exception('Поддерживаются только системы 8, 10, 16');
  }

  static int toDecimal(String value, int base) {
    if (base == 10) return int.parse(value);
    if (base == 16) return int.parse(value, radix: 16);
    if (base == 8) return int.parse(value, radix: 8);
    throw Exception('Поддерживаются только системы 8, 10, 16');
  }

  static String convert(String value, int fromBase, int toBase) {
    int decimal = toDecimal(value, fromBase);
    return fromDecimal(decimal, toBase);
  }
}

// 9. Класс со списком фигур и поиском максимальной площади
class ShapeCollection {
  List<Shape> shapes = [];

  void add(Shape shape) => shapes.add(shape);

  Shape? getMaxAreaShape() {
    if (shapes.isEmpty) return null;
    return shapes.reduce((a, b) => a.area() > b.area() ? a : b);
  }
}

// 10. Классы «Стол» и столовые приборы
abstract class Utensil {
  String name;
  Utensil(this.name);
}

class Fork extends Utensil {
  Fork() : super('Вилка');
}

class Spoon extends Utensil {
  Spoon() : super('Ложка');
}

class Knife extends Utensil {
  Knife() : super('Нож');
}

class Table {
  List<Utensil> utensils = [];

  void put(Utensil utensil) {
    utensils.add(utensil);
    print('${utensil.name} поставлен на стол.');
  }

  void remove(Utensil utensil) {
    if (utensils.remove(utensil)) {
      print('${utensil.name} убран со стола.');
    } else {
      print('${utensil.name} не найден на столе.');
    }
  }

  void listUtensils() {
    if (utensils.isEmpty) {
      print('На столе нет приборов.');
    } else {
      print('На столе: ${utensils.map((u) => u.name).join(', ')}');
    }
  }
}

// ------------------ Интерактивное меню ------------------
void main() {
  while (true) {
    print('\n========== ГЛАВНОЕ МЕНЮ ==========');
    print('1. Кружка и Человек');
    print('2. Шкаф и системы хранения');
    print('3. Гриф и блины');
    print('4. Конвертер валют');
    print('5. Перегруженные арифметические операции (Vector2)');
    print('6. Автомобиль');
    print('7. Геометрические фигуры');
    print('8. Конвертер систем счисления');
    print('9. Поиск фигуры с максимальной площадью');
    print('10. Стол и столовые приборы');
    print('0. Выход');
    stdout.write('Выберите пункт: ');

    String? choice = stdin.readLineSync();
    switch (choice) {
      case '1':
        demo1();
        break;
      case '2':
        demo2();
        break;
      case '3':
        demo3();
        break;
      case '4':
        demo4();
        break;
      case '5':
        demo5();
        break;
      case '6':
        demo6();
        break;
      case '7':
        demo7();
        break;
      case '8':
        demo8();
        break;
      case '9':
        demo9();
        break;
      case '10':
        demo10();
        break;
      case '0':
        print('До свидания!');
        return;
      default:
        print('Неверный ввод. Попробуйте снова.');
    }
  }
}

// Демонстрация 1: Кружка и Человек
void demo1() {
  print('\n--- Кружка и Человек ---');
  stdout.write('Введите объём кружки (мл): ');
  double volume = double.parse(stdin.readLineSync()!);
  Cup cup = Cup(volume);
  cup.fill();

  stdout.write('Введите имя человека: ');
  String name = stdin.readLineSync()!;
  Person person = Person(name);

  stdout.write('Сколько мл выпить? ');
  double amount = double.parse(stdin.readLineSync()!);
  person.drinkFromCup(cup, amount);
}

// Демонстрация 2: Шкаф
void demo2() {
  print('\n--- Шкаф и системы хранения ---');
  var shelf = Shelf();
  var drawer = Drawer();
  var wardrobe = Wardrobe([shelf, drawer]);

  print('1 - положить вещь на полку');
  print('2 - взять вещь с полки');
  print('3 - положить вещь в ящик');
  print('4 - взять вещь из ящика');
  stdout.write('Выберите действие: ');
  String? action = stdin.readLineSync();

  if (action == '1') {
    stdout.write('Ключ для вещи: ');
    String key = stdin.readLineSync()!;
    stdout.write('Что положить? ');
    String item = stdin.readLineSync()!;
    wardrobe.putItem(shelf, key, item);
  } else if (action == '2') {
    stdout.write('Ключ вещи: ');
    String key = stdin.readLineSync()!;
    wardrobe.takeItem(shelf, key);
  } else if (action == '3') {
    stdout.write('Ключ для вещи: ');
    String key = stdin.readLineSync()!;
    stdout.write('Что положить? ');
    String item = stdin.readLineSync()!;
    wardrobe.putItem(drawer, key, item);
  } else if (action == '4') {
    stdout.write('Ключ вещи: ');
    String key = stdin.readLineSync()!;
    wardrobe.takeItem(drawer, key);
  } else {
    print('Неверное действие');
  }
}

// Демонстрация 3: Гриф и блины
void demo3() {
  print('\n--- Гриф и блины ---');
  stdout.write('Введите максимальную нагрузку грифа (кг): ');
  double maxLoad = double.parse(stdin.readLineSync()!);
  Barbell barbell = Barbell(maxLoad);

  while (true) {
    print('\n1 - добавить блин слева');
    print('2 - добавить блин справа');
    print('3 - показать общий вес');
    print('4 - закончить');
    stdout.write('Выбор: ');
    String? choice = stdin.readLineSync();
    if (choice == '1') {
      stdout.write('Вес блина (кг): ');
      double w = double.parse(stdin.readLineSync()!);
      barbell.addPlateLeft(Plate(w));
    } else if (choice == '2') {
      stdout.write('Вес блина (кг): ');
      double w = double.parse(stdin.readLineSync()!);
      barbell.addPlateRight(Plate(w));
    } else if (choice == '3') {
      print('Общий вес на грифе: ${barbell.totalWeight()} кг');
    } else if (choice == '4') {
      break;
    } else {
      print('Неверный выбор');
    }
  }
}

// Демонстрация 4: Конвертер валют
void demo4() {
  print('\n--- Конвертер валют ---');
  stdout.write('Сумма: ');
  double amount = double.parse(stdin.readLineSync()!);
  stdout.write('Из валюты (USD, EUR, RUB, GBP): ');
  String from = stdin.readLineSync()!.toUpperCase();
  stdout.write('В валюту (USD, EUR, RUB, GBP): ');
  String to = stdin.readLineSync()!.toUpperCase();
  try {
    double result = CurrencyConverter.convert(amount, from, to);
    print('$amount $from = ${result.toStringAsFixed(2)} $to');
  } catch (e) {
    print('Ошибка: $e');
  }
}

// Демонстрация 5: Перегруженные операции (Vector2)
void demo5() {
  print('\n--- Векторная арифметика ---');
  stdout.write('Введите x1 y1 для первого вектора: ');
  List<String> parts1 = stdin.readLineSync()!.split(' ');
  double x1 = double.parse(parts1[0]);
  double y1 = double.parse(parts1[1]);
  Vector2 v1 = Vector2(x1, y1);

  stdout.write('Введите x2 y2 для второго вектора: ');
  List<String> parts2 = stdin.readLineSync()!.split(' ');
  double x2 = double.parse(parts2[0]);
  double y2 = double.parse(parts2[1]);
  Vector2 v2 = Vector2(x2, y2);

  stdout.write('Введите скаляр: ');
  double scalar = double.parse(stdin.readLineSync()!);

  print('$v1 + $v2 = ${v1 + v2}');
  print('$v1 - $v2 = ${v1 - v2}');
  print('$v1 * $scalar = ${v1 * scalar}');
  print('$v1 / $scalar = ${v1 / scalar}');
}

// Демонстрация 6: Автомобиль
void demo6() {
  print('\n--- Автомобиль ---');
  Car car = Car();
  while (true) {
    print('\n1 - ехать');
    print('2 - остановиться');
    print('3 - повернуть налево');
    print('4 - повернуть направо');
    print('5 - выйти');
    stdout.write('Выбор: ');
    String? choice = stdin.readLineSync();
    if (choice == '1') car.go();
    else if (choice == '2') car.stop();
    else if (choice == '3') car.turn(TurnDirection.left);
    else if (choice == '4') car.turn(TurnDirection.right);
    else if (choice == '5') break;
    else print('Неверная команда');
  }
}

// Демонстрация 7: Геометрические фигуры
void demo7() {
  print('\n--- Геометрические фигуры ---');
  print('Выберите фигуру: 1 - прямоугольник, 2 - треугольник, 3 - круг');
  String? choice = stdin.readLineSync();
  Shape? shape;
  if (choice == '1') {
    stdout.write('Ширина: ');
    double w = double.parse(stdin.readLineSync()!);
    stdout.write('Высота: ');
    double h = double.parse(stdin.readLineSync()!);
    shape = Rectangle(w, h);
  } else if (choice == '2') {
    stdout.write('Основание: ');
    double b = double.parse(stdin.readLineSync()!);
    stdout.write('Высота: ');
    double h = double.parse(stdin.readLineSync()!);
    shape = Triangle(b, h);
  } else if (choice == '3') {
    stdout.write('Радиус: ');
    double r = double.parse(stdin.readLineSync()!);
    shape = Circle(r);
  } else {
    print('Неверный выбор');
    return;
  }
  print('Площадь: ${shape.area().toStringAsFixed(2)}');
}

// Демонстрация 8: Конвертер систем счисления
void demo8() {
  print('\n--- Конвертер систем счисления ---');
  stdout.write('Введите число: ');
  String value = stdin.readLineSync()!;
  stdout.write('Из системы (8, 10, 16): ');
  int fromBase = int.parse(stdin.readLineSync()!);
  stdout.write('В систему (8, 10, 16): ');
  int toBase = int.parse(stdin.readLineSync()!);
  try {
    String result = BaseConverter.convert(value, fromBase, toBase);
    print('$value (осн. $fromBase) = $result (осн. $toBase)');
  } catch (e) {
    print('Ошибка: $e');
  }
}

// Демонстрация 9: Поиск фигуры с максимальной площадью
void demo9() {
  print('\n--- Поиск максимальной площади ---');
  ShapeCollection collection = ShapeCollection();
  while (true) {
    print('\n1 - добавить прямоугольник');
    print('2 - добавить треугольник');
    print('3 - добавить круг');
    print('4 - найти фигуру с максимальной площадью');
    print('5 - выйти');
    stdout.write('Выбор: ');
    String? choice = stdin.readLineSync();
    if (choice == '1') {
      stdout.write('Ширина: ');
      double w = double.parse(stdin.readLineSync()!);
      stdout.write('Высота: ');
      double h = double.parse(stdin.readLineSync()!);
      collection.add(Rectangle(w, h));
      print('Прямоугольник добавлен.');
    } else if (choice == '2') {
      stdout.write('Основание: ');
      double b = double.parse(stdin.readLineSync()!);
      stdout.write('Высота: ');
      double h = double.parse(stdin.readLineSync()!);
      collection.add(Triangle(b, h));
      print('Треугольник добавлен.');
    } else if (choice == '3') {
      stdout.write('Радиус: ');
      double r = double.parse(stdin.readLineSync()!);
      collection.add(Circle(r));
      print('Круг добавлен.');
    } else if (choice == '4') {
      Shape? maxShape = collection.getMaxAreaShape();
      if (maxShape != null) {
        print('Фигура с максимальной площадью: ${maxShape.runtimeType}, площадь = ${maxShape.area().toStringAsFixed(2)}');
      } else {
        print('Нет ни одной фигуры.');
      }
    } else if (choice == '5') {
      break;
    } else {
      print('Неверный выбор');
    }
  }
}

// Демонстрация 10: Стол и столовые приборы
void demo10() {
  print('\n--- Стол и столовые приборы ---');
  Table table = Table();
  Fork? fork;
  Spoon? spoon;
  Knife? knife;

  while (true) {
    print('\n1 - поставить вилку');
    print('2 - поставить ложку');
    print('3 - поставить нож');
    print('4 - убрать вилку');
    print('5 - убрать ложку');
    print('6 - убрать нож');
    print('7 - показать приборы на столе');
    print('8 - выйти');
    stdout.write('Выбор: ');
    String? choice = stdin.readLineSync();
    
    if (choice == '1') {
      fork = Fork();
      table.put(fork);
    } else if (choice == '2') {
      spoon = Spoon();
      table.put(spoon);
    } else if (choice == '3') {
      knife = Knife();
      table.put(knife);
    } else if (choice == '4') {
      if (fork != null) table.remove(fork);
      else print('Вилка не была поставлена');
    } else if (choice == '5') {
      if (spoon != null) table.remove(spoon);
      else print('Ложка не была поставлена');
    } else if (choice == '6') {
      if (knife != null) table.remove(knife);
      else print('Нож не был поставлен');
    } else if (choice == '7') {
      table.listUtensils();
    } else if (choice == '8') {
      break;
    } else {
      print('Неверный выбор');
    }
  }
}