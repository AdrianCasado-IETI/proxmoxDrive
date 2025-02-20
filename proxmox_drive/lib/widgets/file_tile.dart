import 'package:flutter/material.dart';
import 'package:proxmox_drive/services/app_data.dart';
import 'package:proxmox_drive/ssh_conn.dart';

class FileTile extends StatefulWidget {

  final String file;
  final String dir;
  final Function onDirChange;

  const FileTile({
    super.key,
    required this.file,
    required this.dir,
    required this.onDirChange
  });

  @override
  State<FileTile> createState() => _FileTileState();
}

class _FileTileState extends State<FileTile> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    bool isDir = widget.file[0] == "d";
    String fileName = widget.file.split(" ").last;

    return ListTile(
      shape: Border.fromBorderSide(
        BorderSide(
          width: 0.3, 
          color: const Color.fromARGB(255, 206, 206, 206)
        ),
      ),
      onTap: () {
        if(isDir){
          if(widget.dir == "/") {
            widget.onDirChange("${widget.dir}${widget.file.split(" ").last}");
          } else {
            widget.onDirChange("${widget.dir}/${widget.file.split(" ").last}");
          }
        }
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isDir ? Icons.folder : fileName.split(".").last == "zip" ? Icons.view_list : Icons.description,
                color: isDir ? const Color.fromARGB(255, 255, 201, 7) : fileName.split(".").last == "zip" ? Colors.purple : Colors.blue,
              ),
              SizedBox(width: 16,),
              Text(fileName)
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  String? savingDir = await AppData.chooseLocalDir();
                  if(savingDir != null) {
                    SSHConn conn = SSHConn.getInstance();
                    conn.downloadFile("${widget.dir}/$fileName", savingDir, isDir);
                  }
                  
                },
                icon: Icon(
                  Icons.download
                ),
              ),
              SizedBox(width:16,),
              IconButton(
                onPressed: () {
                  SSHConn conn = SSHConn.getInstance();
                  conn.deleteFile("${widget.dir}/$fileName").then((done) {
                    if(done) {
                      widget.onDirChange(widget.dir);
                    }
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red[800],
                ),
              ),
              SizedBox(width: 16,),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert),
                onSelected: (String result) {
                  if (result == 'rename') {
                    _showRenameDialog(context, fileName);
                  } else if (result == 'info') {
                    _showInfoDialog(context);
                  } else if(result == 'unzip') {
                    SSHConn conn = SSHConn.getInstance();
                    conn.unzipFile(widget.dir, fileName).then((done) {
                      if(done) {
                        widget.onDirChange(widget.dir);
                      }
                    });
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'rename',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 16,),
                        Text('Renombrar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'info',
                    child: Row(
                      children: [
                        Icon(Icons.info),
                        SizedBox(width: 16,),
                        Text('Informació'),
                      ],
                    ),
                  ),
                  if (fileName.split(".").last == "zip") const PopupMenuItem(
                    value: 'unzip',
                    child: Row(
                      children: [
                        Icon(Icons.unarchive),
                        SizedBox(width: 16,),
                        Text('Descomprimir'),
                      ],
                    )
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> _showRenameDialog(context, String fileName) {
    TextEditingController newNameController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text("Renombrar arxiu"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newNameController,
                decoration: InputDecoration(
                  hintText: fileName,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                SSHConn conn = SSHConn.getInstance();
                conn.renameFile("${widget.dir}/$fileName", "${widget.dir}/${newNameController.text}").then((done) {
                  if(done) {
                    widget.onDirChange(widget.dir);
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text("Renombrar"),
            ),
          ],
        );
      }
    );
  }

  Future<void> _showInfoDialog(context) {
    String file = widget.file.replaceAll(RegExp(r'\s+'), ' ');
    String fileName = file.split(" ").last;
    String permissions = file.split(" ")[0].substring(1);
    String owner = file.split(" ")[2];
    String group = file.split(" ")[3];
    String size = file.split(" ")[4];
    String date = file.split(" ").sublist(5, 8).join(" ");
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text("Informació de l'arxiu"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    "Nom: ", 
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(fileName)
                ],
              ),
              Row(
                children: [
                  Text("Propietari: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(owner)
                ],
              ),
              Row(
                children: [
                  Text("Grup: ", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(group)
                ],
              ),
              Row(
                children: [
                  Text("Data de creació: ", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(date)
                ],
              ),
              Row(
                children: [
                  Text("Mida: ", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("$size bytes")
                ],
              ),
              Row(
                children: [
                  Text("Permisos: ", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(permissions)
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Tancar"),
            ),
          ],
        );
      }
    );
  }
}