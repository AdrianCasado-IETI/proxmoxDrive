import 'package:flutter/material.dart';
import 'package:proxmox_drive/services/app_data.dart';
import 'package:proxmox_drive/ssh_conn.dart';
import 'package:proxmox_drive/widgets/file_tile.dart';

class Home extends StatefulWidget {

  final dynamic onLogOut;

  const Home({
    super.key,
    required this.onLogOut
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  SSHConn conn = SSHConn.getInstance();
  List<String> _files = [];
  String? _dir;

  final TextEditingController _dirController = TextEditingController(); 

  @override
  void initState() {
    super.initState();

    conn.executeCommand("pwd").then((value) {
      setState(() {
        _dir = value.trim();
        _dirController.text = _dir!;
      });
    });

    conn.executeCommand("ls -l").then((value) {
      setState(() {
        _files = value.split("\n").sublist(1,value.split("\n").length-1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Proxmox Drive"),
        backgroundColor: Colors.amber,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              AppData.chooseLocalFile().then((filePath) {
                if(filePath != null) {
                  conn.uploadFile(filePath, _dir!).then((value) {
                    if(value) {
                      conn.executeCommand("ls -l $_dir").then((value) {
                        setState(() {
                          _files = value.split("\n").sublist(1,value.split("\n").length-1);
                        });
                      });
                    }
                  });
                }
                
              });
            }, 
            icon: Icon(Icons.upload)
          ),
          SizedBox(width: 10,),
          IconButton(
            onPressed: () {
              widget.onLogOut();
            },
            icon: Icon(Icons.power_settings_new, color: Colors.red[800],),
          ),
          SizedBox(width: 10,)
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: Column(
              children: [
                SizedBox(height: 16,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      child: TextField(
                        controller: _dirController,
                        onChanged: (value) {
                          setState(() {
                            _dir = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)
                            ),
                            borderSide: BorderSide(
                              width: 1,
                              color: const Color.fromARGB(255, 184, 184, 184)
                            )
                          )
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)
                        )
                      ),),
                      onPressed: () {
                        conn.executeCommand("cd $_dir").then((value) {
                          conn.executeCommand("ls -l $_dir").then((value) {
                            setState(() {
                              _files = value.split("\n").sublist(1,value.split("\n").length-1);
                            });
                          });
                        });
                      }, child: Text(
                        "Ves-hi",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      )
                    )
                  ],
                ),
                SizedBox(height: 16,),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _files.length + 1,
              itemBuilder: (context, index) {
                if(index == 0) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        if(_dir != "") {
                          int lastIndex = _dir!.lastIndexOf("/");
                          _dir = _dir!.substring(0, lastIndex);
                          if(_dir == "")  {
                            _dir = "/";
                          }
                          _dirController.text = _dir!;
                          conn.executeCommand("ls -l $_dir").then((value) {
                            setState(() {
                              _files = value.split("\n").sublist(1,value.split("\n").length-1);
                            });
                          });
                        }
                        
                      });
                      
                    },
                    title: Row(
                      children: [
                        Icon(Icons.source),
                        SizedBox(width: 16,),
                        Text("...")
                      ],
                    ),
                  );
                } else {
                  return FileTile(
                    onDirChange: (dirName) {
                      setState(() {
                        _dir = "$dirName";
                        _dirController.text = _dir!;
                        conn.executeCommand("ls -l $_dir").then((value) {
                          setState(() {
                            _files = value.split("\n").sublist(1,value.split("\n").length-1);
                          });
                        });
                      });
                    },
                    dir: _dir!,
                    file: _files[index-1]
                  );
                }
              }  
            ),
          )
        ],
      )
    );
  }
}   