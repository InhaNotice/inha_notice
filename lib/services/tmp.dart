// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// void main() async {
//   final String baseUrl = "https://lib.inha.ac.kr/pyxis-api/1/bulletin-boards/1/bulletins";
//
//   // 기본 파라미터 설정
//   Map<String, String> params = {
//     "nameOption": "",
//     "isSeq": "false",
//     "onlyWriter": "false",
//     "max": "10",
//     "offset": "0" // 시작점
//   };
//
//   while (true) {
//     final uri = Uri.parse(baseUrl).replace(queryParameters: params);
//     final response = await http.get(uri);
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final notices = data["data"]["list"] as List<dynamic>?;
//
//       if (notices == null || notices.isEmpty) break;
//
//       // 공지사항 출력
//       for (var notice in notices) {
//         print(
//             "ID: ${notice['id']}, Title: ${notice['title']}, Writer: ${notice['writer']}, Date: ${notice['dateCreated']}");
//       }
//
//       // 다음 페이지로 이동
//       int offset = int.parse(params["offset"]!);
//       int max = int.parse(params["max"]!);
//       params["offset"] = (offset + max).toString();
//
//       if (notices.length < max) {
//         break; // 더 이상 데이터가 없으면 종료
//       }
//     } else {
//       print("Failed to fetch data!");
//       break;
//     }
//   }
// }