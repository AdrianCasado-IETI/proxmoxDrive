class ServerConfig {
  String name;
  String host;
  int port;
  String username;
  String? password;
  String? privateKey;

  ServerConfig({
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    this.password,
    this.privateKey,
  });

  factory ServerConfig.fromJson(Map<String, dynamic> json) {
    return ServerConfig(
      name: json['name'],
      host: json['host'],
      port: json['port'],
      username: json['username'],
      password: json['password'],
      privateKey: json['privateKey'],
    );
  }
}
