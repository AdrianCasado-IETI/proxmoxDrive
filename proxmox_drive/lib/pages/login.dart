import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:proxmox_drive/services/app_data.dart';
import 'package:proxmox_drive/services/ssh_services.dart';
import 'package:proxmox_drive/ssh_conn.dart';
import 'package:proxmox_drive/widgets/titled_input.dart';

class Login extends StatefulWidget {

  final onLogin;

  const Login({
    super.key,
    required this.onLogin
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  List<dynamic> _servers = [];
  int? _selectedServer;
  Map<String, dynamic> _newServer = {
    "name": "",
    "server": "",
    "port": -1,
    "key": ""
  };

  @override
  void initState() {
    super.initState();
    AppData.getServers().then((value) => {
      setState(() {
        _servers = value;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 300,
          width: 500,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(16)
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                        child: Text(
                          "Servidors",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _servers.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedServer = index;
                                  _newServer = {
                                    "name": _servers[_selectedServer!]["name"],
                                    "server": _servers[_selectedServer!]["server"],
                                    "port": _servers[_selectedServer!]["port"],
                                    "key": _servers[_selectedServer!]["key"],
                                  };
                                  print(_newServer);
                                });
                              },
                              child: ListTile(
                                key: Key(index.toString()),
                                title: Text(_servers[index]["name"]),
                              ),
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Configuració SSH",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TitledInput(
                      title: "Nom", 
                      value: _selectedServer != null ? _newServer["name"] : null,
                      onChanged: (value) {
                        setState(() {
                          _newServer["name"] = value;
                        });
                      },
                    ),
                    TitledInput(
                      title: "Servidor", 
                      value: _selectedServer != null ? _newServer["server"] : null,
                      onChanged: (value) {
                        setState(() {
                          _newServer["server"] = value;
                        });
                      },
                    ),
                    TitledInput(
                      title: "Port", 
                      value: _selectedServer != null ? _newServer["port"].toString() : null,
                      onChanged: (value) {
                        setState(() {
                          try {
                            _newServer["port"] = int.parse(value);
                          } catch (error) {
                            _newServer["port"] = -1;
                          }
                          
                        });
                      },
                    ),
                    TitledInput(
                      title: "Clau",
                      value: _selectedServer != null ? _newServer["key"] : null,
                      onChanged: (value) {
                        setState(() {
                          _newServer["key"] = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Colors.black, width: 0.5)
                              )
                            ),
                            onPressed: () {
                              if(_newServer["name"] != "") {
                                AppData.deleteServer(_newServer["name"]).then((value) {
                                  if (value) {
                                    AppData.getServers().then((data) {
                                      setState(() {
                                        print("Servidores actualizados: $data");
                                        _servers = data;
                                      });
                                    });
                                  }
                                });
                              }
                            }, 
                            child: const Icon(
                              Icons.delete
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Colors.black, width: 0.5)
                              )
                            ),
                            onPressed: () {
                              if(_newServer["name"] != "" && _newServer["server"] != "" && _newServer["port"] != "") {
                                AppData.saveServer(_newServer).then((value) {
                                    AppData.getServers().then((value) {
                                      setState(() {
                                        print("Servidores actualizados: $value");
                                        _servers = value;
                                      });
                                    },);
                                },);
                              }
                            }, 
                            child: const Text(
                              "Guardar"
                            )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                
                              ),
                            ),
                            onPressed: () {
                              final sshConn = SSHConn.getInstance();
                              try {
                                sshConn.connect(
                                  serverName: _newServer["name"], 
                                  serverAddress: _newServer["server"], 
                                  port: _newServer["port"], 
                                  privateKeyPath: _newServer["key"]
                                ).then((value) {
                                  if(value) {
                                    widget.onLogin();
                                  }
                                  
                                },);
                              } catch (error) {
                                print("Error: $error");
                              }
                            }, 
                            child: const Text(
                              "Connectar"
                            )
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}