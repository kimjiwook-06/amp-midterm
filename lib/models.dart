class Item {
  const Item({
    required this.id,
    required this.name,
    required this.color,
    required this.location,
    required this.use,
    required this.icon,
    required this.x,
    required this.y,
  });
  final int id;
  final String name, color, location, use, icon;
  final double x, y;
  factory Item.fromJson(Map<String, dynamic> j) => Item(
    id: j['id'] as int,
    name: j['name'] as String,
    color: j['color'] as String,
    location: j['location'] as String,
    use: j['use'] as String,
    icon: j['icon'] as String,
    x: (j['x'] as num).toDouble(),
    y: (j['y'] as num).toDouble(),
  );
}
