

class get_prod {
  late final String unique_id;
  late final String  created_by;
  late final String  created_ip;

  get_prod({
    required this.unique_id,
    required this.created_by,
    required this.created_ip,
  });

  factory get_prod.fromJson(Map<String, dynamic> json) {
    return get_prod(
      unique_id: json[' unique_id'],
      created_by: json['created_by'],
      created_ip: json['created_ip'],
    );
  }
}