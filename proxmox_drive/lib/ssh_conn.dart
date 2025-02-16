class SSHConn {
  static final SSHConn _instance = SSHConn._internal();

  SSHConn._internal();

  static SSHConn getInstance() {
    return _instance;
  }

  
}