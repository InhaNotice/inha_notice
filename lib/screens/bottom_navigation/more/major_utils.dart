import 'package:inha_notice/firebase/firebase_service.dart';
import 'package:logger/logger.dart';

class MajorUtils {
  static final Logger logger = Logger();
  static const Map<String, Map<String, String>> majorGroups = {
    '공과대학': {
      '기계공학과': 'MECH',
      '항공우주공학과': 'AEROSPACE',
      '조선해양공학과': 'NAOE',
      '산업경영공학과': 'IE',
      '화학공학과': 'CHEMENG',
      '생명공학과': 'BIO',
      '고분자공학과': 'INHAPOLY',
      '신소재공학과': 'DMSE',
      '사회인프라공학과': 'CIVIL',
      '환경공학과': 'ENVIRONMENT',
      '공간정보공학과': 'GEOINFO',
      '건축학부': 'ARCH',
      '에너지자원공학과': 'ENERES',
      '전기공학과': 'ELECTRICAL',
      '전자공학과': 'EE',
      '정보통신공학과': 'ICE',
    },
    '자연과학대학': {
      '수학과': 'MATH',
      '통계학과': 'STATISTICS',
      '물리학과': 'PHYSICS',
      '화학과': 'CHEMISTRY',
      '생명과학과': 'BIOLOGY',
      '해양학과': 'WDN',
    },
    '경영대학': {
      '식품영양학과': 'FOODNUTRI',
      '경영학과': 'BIZ',
      '글로벌금융학과': 'GFIBA',
      '아태물류학과': 'APSL',
      '국제통상학과': 'STAR',
    },
    '사범대학': {
      '국어교육과': 'KOREANEDU',
      '영어교육과': 'DELE',
      '사회교육과': 'SOCIALEDU',
      '체육교육과': 'PHYSICALEDU',
      '교육학과': 'EDUCATION',
      '수학교육과': 'MATHED',
    },
    '사회과학대학': {
      '행정학과': 'PUBLICAD',
      '정치외교학과': 'POLITICAL',
      '미디어커뮤니케이션학과': 'COMM',
      '경제학과': 'ECON',
      '소비자학과': 'CONSUMER',
      '아동심리학과': 'CHILD',
      '사회복지학과': 'WELFARE',
    },
    '문과대학': {
      '한국어문학과': 'KOREAN',
      '사학과': 'HISTORY',
      '철학과': 'PHILOSOPHY',
      '중국학과': 'CHINESE',
      '일본언어문화학과': 'JAPAN',
      '영어영문학과': 'ENGLISH',
      '프랑스어문화학과': 'FRANCE',
      '문화콘텐츠문화경영학과': 'CULTURECM',
    },
    '의과대학': {
      '의예과': 'MEDICINE',
      '간호학과': 'NURSING',
    },
    '예술체육대학': {
      '조형예술학과': 'FINEARTS',
      '디자인학부': 'INHADESIGN',
      '스포츠과학과': 'SPORT',
      '연극영화학과': 'THEATREFILM',
      '의류디자인학과': 'FASHION',
    },
    '국제학부': {
      'IBT학과': 'SGCSA',
      'ISE학과': 'SGCSB',
    },
    '미래융합대학': {
      '메카트로닉스공학과': 'FCCOLLEGEA',
      '소프트웨어융합공학과': 'FCCOLLEGEB',
      '산업경영학과': 'FCCOLLEGEC',
      '금융투자학과': 'FCCOLLEGED',
    },
    '소프트웨어융합대학': {
      '인공지능공학과': 'DOAI',
      '스마트모빌리티공학과': 'SME',
      '데이터사이언스학과': 'DATASCIENCE',
      '디자인테크놀리지학과': 'DESIGNTECH',
      '컴퓨터공학과': 'CSE',
    },
    '프런티어학부대학': {
      '자유전공학부': 'LAS',
    }
  };

  // 저장된 영문 학과명을 국문 학과명으로 번역합니다.
  static String translateToKorean(String? majorKey) {
    return majorGroups.entries
        .expand((group) => group.value.entries)
        .firstWhere((entry) => entry.value == majorKey,
            orElse: () => const MapEntry('Unknown Major', ''))
        .key;
  }

  // 국문 학과명을 영문 학과명으로 저장합니다.
  static String translateToEnglish(String major) {
    return majorGroups.entries
        .expand((group) => group.value.entries)
        .firstWhere((entry) => entry.key == major,
            orElse: () => const MapEntry('', 'Unknown Major'))
        .value;
  }

  static Future<void> subscribeToMajor(
      String? currentMajorKey, String newMajorKey) async {
    try {
      final firebaseService = FirebaseService();

      if (currentMajorKey != null && currentMajorKey != newMajorKey) {
        await firebaseService.unsubscribeFromTopic(currentMajorKey);
      }

      await firebaseService.subscribeToTopic(newMajorKey);
    } catch (e) {
      logger.e('🚨 Error handling FCM topic subscription: $e');
    }
  }
}
