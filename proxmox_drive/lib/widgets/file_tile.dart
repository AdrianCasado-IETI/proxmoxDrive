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
          widget.onDirChange("${widget.dir}/${widget.file.split(" ").last}");
        }
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isDir ? Icons.folder : Icons.description,
                color: isDir ? const Color.fromARGB(255, 255, 201, 7) : Colors.blue,
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
              )
            ],
          )
        ],
      ),
    );
  }
}