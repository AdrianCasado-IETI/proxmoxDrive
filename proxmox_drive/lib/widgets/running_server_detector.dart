import 'package:flutter/material.dart';
import 'package:proxmox_drive/ssh_conn.dart';
import 'package:proxmox_drive/widgets/is_connected.dart';

class RunningServerDetector extends StatefulWidget {
  final bool isRunning;
  final String serverName;

  const RunningServerDetector({
    super.key, 
    required this.serverName,
    required this.isRunning
  });

  @override
  State<RunningServerDetector> createState() => _RunningServerDetectorState();
}

class _RunningServerDetectorState extends State<RunningServerDetector> {

  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _isRunning = widget.isRunning;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 166, 189, 196),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IsConnected(
              isConnected: _isRunning, 
              onClick: () {
                if(_isRunning) {
                  SSHConn.getInstance().stopServer(widget.serverName).then((value) {
                    setState(() {
                      _isRunning = false;
                    });
                  });
                } else {
                  SSHConn.getInstance().startServer(widget.serverName).then((value) {
                    setState(() {
                      _isRunning = true;
                    });
                  });
                }
              }
            ),
            SizedBox(width: 10),
            Text(
              _isRunning ? "Server ${widget.serverName} functionant" : "Server ${widget.serverName} no functionant",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            
          ] 
        ),
      ),
    );
  }
}