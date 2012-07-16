
#library("pets");

final num MAX_CATS = 10;

final SPARKY = const Cat("Sparky");

interface Animal {

  bool livesWith(Animal other);

  void performAction();

}

class Cat implements Animal {
  // TODO(devoncarew): cmd-line: can't see static vars
  static final String BEST_CAT_NAME = "Spooky";

  static final BLACK_CAT = const Cat("Midnight");

  final String name;

  const Cat(this.name);

  bool livesWith(Animal other) => other is Cat;

  void performAction() {
    print("meow");
  }

  String toString() => "cat ${name}";

}

class FloppyEars {
  // TODO(devoncarew): both: EAR_COUNT is not displayed
  static final int EAR_COUNT = 2;

}

class Dog extends FloppyEars implements Animal {
  static final String BEST_DOG_NAME = "Chips";

  String name;

  bool collar;

  int fleaCount;

  Date bornOn;

  // TODO(devoncarew): both: stack trace shows Dog.Dog.() ("functionName":"Dog.Dog.")
  Dog(this.name) {
    fleaCount = (Math.random() * 10.0).round().toInt();
    bornOn = new Date.now();
  }

  Dog.withFleas(this.name, this.fleaCount) {
    bornOn = new Date.now();
  }

  bool livesWith(Animal other) => true;

  void performAction() {
    print("bark");
    print("bark");
    print("bark");
  }

  String toString() => "dog ${name}";

}

List<Animal> getLotsOfAnimals() {
  return [
      new Dog("Scooter"),
      new Cat("Munchkins"),
      SPARKY,
      new Dog.withFleas(Dog.BEST_DOG_NAME, 2)
  ];
}

Map<String, Animal> getMapOfAnimals() {
  Map<String, Animal> map = new Map<String, Animal>();

  for (var animal in getLotsOfAnimals()) {
    map[animal.toString()] = animal;
  }

  return map;
}