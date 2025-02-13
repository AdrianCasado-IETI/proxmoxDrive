import 'package:flutter/material.dart';
import 'package:proxmox_drive/app_data.dart';
import 'package:proxmox_drive/widgets/titled_input.dart';

class Login extends StatefulWidget {

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  List<dynamic> _servers = [];
  int? _selectedServer;
  final Map<String, dynamic> _newServer = {
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
      appBar: AppBar(
        title: const Text("Proxmox Drive"),
      ),
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
                      value: _selectedServer != null ? _servers[_selectedServer!]["name"] : null,
                      callback: (value) {
                        setState(() {
                          _newServer["name"] = value;
                        });
                        AppData.getServers().then((value) => {
                          setState(() {
                            _servers = value;
                          })
                        });
                      },
                    ),
                    TitledInput(
                      title: "Servidor", 
                      value: _selectedServer != null ? _servers[_selectedServer!]["server"] : null,
                      callback: (value) {
                        setState(() {
                          _newServer["server"] = value;
                        });
                      },
                    ),
                    TitledInput(
                      title: "Port", 
                      value: _selectedServer != null ? _servers[_selectedServer!]["port"].toString() : null,
                      callback: (value) {
                        setState(() {
                          _newServer["port"] = value;
                        });
                      },
                    ),
                    TitledInput(
                      title: "Clau",
                      value: _selectedServer != null ? _servers[_selectedServer!]["key"] : null,
                      callback: (value) {
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
                            onPressed: () {}, 
                            child: const Icon(
                              Icons.delete
                            )
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
                              if(_newServer["name"] != "") {
                                AppData.saveServer(_newServer);
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
                            onPressed: () {}, 
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