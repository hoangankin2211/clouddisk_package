class Api {
  static const String baseUrl = 'https://groupware57.hanbiro.net';

  static final Map<String, dynamic> header = {
    "Content-Type":
        "multipart/form-data; boundary=----WebKitFormBoundaryjk5qx8gPXTK2T6Tf",
    "Accept": "*/*",
    'APP_TYPE': 'clouddisk',
    'App-Type': 'clouddisk',
    'app-type': 'clouddisk',
    'DEVICE_TYPE': 'android',
    'device-type': 'android',
    'Device-Type': 'android',
    'DEVICE': 'phone',
    'device': 'phone',
    'device_id': '1e10f743-196e-4bc0-aee7-8c14690f2ac4',
    'X-REQUESTED-WITH': 'XMLHttpRequest',
    "User_Agent": "Android 1.0 APP_HANBIRO_2.0.0.2",
    "Accept-Encoding": "gzip, deflate, br",
    "Accept-Language": "en-US,en;q=0.9",
    "Connection": "keep-alive",
  };
}

class ApiPath {
  static const String apiLogin = "/ngw/sign/auth?is_checking_otp=0";
  static const String apiMainFolder = "/cloud/api/get.php";
  static const String apiGetLink = "/cloud/api/link.php";
  static const String apiCreateFolder = "/cloud/api/mkdir.php";
}

class ApiParam {
  static const Map<String, dynamic> paramLogin = {
    'gw_id':
        'IzQYQiaiG93ZsqpadBkZK5kfntXZHgNmxoQuFQB+Ee2NJcQqAOKheUv05mLHmF1Xx5FWVepSPCH8bS/3TN0riDbaYjJ67OZ7IYT0T4mjksTh6xMal53XNZzJNwhkyms724ejv6geNpCIAfm/op3RErq0WZaRS82jAlxSPLwjOK0=',
    'gw_pass':
        'VcojcSjsb8UEbKP9R6W638DjDA9ZgfBG8Hwo666M4VHQGUAKcfN2L9XLypm+NsojHgUPGWUpIb/cplTB9o8/A5GkKV+4tLZxlTcrGhdz5RPysA7QC2Lho3rJ9U96wCGOZX8FJE+w/2iYCnTM8zicAsDVrNTZsSatw5bPFx/YAQE=',
    'model': 'samsung SM-N970F',
    'device_id': '2eaba74b-e0b5-49cb-b9ab-f9630845d43b',
  };

  static const Map<String, dynamic> mainFolderParam = {
    "access": "1",
    "type": "dir",
  };

  static const defaultItemLengthLimit = 12;
  static final Map<String, dynamic> childFolderParam = {
    "cache": false,
    "limit2": defaultItemLengthLimit,
    "start": 0,
    "type": "file",
  };

  static final Map<String, dynamic> getLinkParams = {
    "mode": "set",
  };
}
