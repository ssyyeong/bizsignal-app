class ServerSettings {
  Map? config;

  ServerSettings(String env) {
    if (env == 'development') {
      config = {
        'apiUrl': 'http://15.164.163.169:4021',
        // 'apiUrl': 'localhost:4021',
      };
    } else {
      config = {'apiUrl': '10.0.2.2:4021'};
    }
  }
}

var serverSettings = ServerSettings('d');
