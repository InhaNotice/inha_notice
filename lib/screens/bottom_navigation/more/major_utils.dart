/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-25
*/
import 'package:inha_notice/constants/major_keys.dart';
import 'package:logger/logger.dart';

/// **MajorUtils**
/// 이 클래스는 MajorSettingPage의 학과 설정 관련 유틸리티를 정의하는 클래스입니다.
///
/// ### 주요 기능:
/// - 인하대학교 단과대학, 국문학과명, 영문학과명 제공
/// - 국문학과명 및 영문학과명 간의 맵핑 지원
class MajorUtils {
  static final Logger logger = Logger();

  /// **모든 단과대학의 학과를 저장하는 컨테이너**
  static const Map<String, Map<String, String>> majorGroups = {
    '공과대학': {
      '기계공학과': MajorKeys.MECH,
      '항공우주공학과': MajorKeys.AEROSPACE,
      '조선해양공학과': MajorKeys.NAOE,
      '산업경영공학과': MajorKeys.IE,
      '화학공학과': MajorKeys.CHEMENG,
      '고분자공학과': MajorKeys.INHAPOLY,
      '신소재공학과': MajorKeys.DMSE,
      '사회인프라공학과': MajorKeys.CIVIL,
      '환경공학과': MajorKeys.ENVIRONMENT,
      '공간정보공학과': MajorKeys.GEOINFO,
      '건축학부': MajorKeys.ARCH,
      '에너지자원공학과': MajorKeys.ENERES,
      '전기공학과': MajorKeys.ELECTRICAL,
      '전자공학과': MajorKeys.EE,
      '정보통신공학과': MajorKeys.ICE,
      '전기전자공학부': MajorKeys.EEE,
      '반도체시스템공학과': MajorKeys.SSE,
    },
    '자연과학대학': {
      '수학과': MajorKeys.MATH,
      '통계학과': MajorKeys.STATISTICS,
      '물리학과': MajorKeys.PHYSICS,
      '화학과': MajorKeys.CHEMISTRY,
      '식품영양학과': MajorKeys.FOODNUTRI,
    },
    '경영대학': {
      '경영학과': MajorKeys.BIZ,
      '파이낸스경영학과': MajorKeys.GFIBA,
      '아태물류학과': MajorKeys.APSL,
      '국제통상학과': MajorKeys.STAR,
    },
    '사범대학': {
      '국어교육과': MajorKeys.KOREANEDU,
      '영어교육과': MajorKeys.DELE,
      '사회교육과': MajorKeys.SOCIALEDU,
      '체육교육과': MajorKeys.PHYSICALEDU,
      '교육학과': MajorKeys.EDUCATION,
      '수학교육과': MajorKeys.MATHED,
    },
    '사회과학대학': {
      '행정학과': MajorKeys.PUBLICAD,
      '정치외교학과': MajorKeys.POLITICAL,
      '미디어커뮤니케이션학과': MajorKeys.COMM,
      '경제학과': MajorKeys.ECON,
      '소비자학과': MajorKeys.CONSUMER,
      '아동심리학과': MajorKeys.CHILD,
      '사회복지학과': MajorKeys.WELFARE,
    },
    '문과대학': {
      '한국어문학과': MajorKeys.KOREAN,
      '사학과': MajorKeys.HISTORY,
      '철학과': MajorKeys.PHILOSOPHY,
      '중국학과': MajorKeys.CHINESE,
      '일본언어문화학과': MajorKeys.JAPAN,
      '영어영문학과': MajorKeys.ENGLISH,
      '프랑스어문화학과': MajorKeys.FRANCE,
      '문화콘텐츠문화경영학과': MajorKeys.CULTURECM,
    },
    '의과대학': {
      '의예과(의학과)': MajorKeys.MEDICINE,
    },
    '간호대학': {
      '간호학과': MajorKeys.NURSING,
    },
    '예술체육대학': {
      '조형예술학과': MajorKeys.FINEARTS,
      '스포츠과학과': MajorKeys.SPORT,
      '연극영화학과': MajorKeys.THEATREFILM,
      '의류디자인학과': MajorKeys.FASHION,
    },
    '바이오시스템융합학부': {
      '생명공학과': MajorKeys.BIO,
      '생명과학과': MajorKeys.BIOLOGY,
      '바이오제약공학과': MajorKeys.BIOPHARM,
      '첨단바이오의약학과': MajorKeys.BIOMEDICAL,
    },
    '국제학부': {
      'IBT학과': MajorKeys.SGCSA,
      'ISE학과': MajorKeys.SGCSB,
      'KLC학과': MajorKeys.SGCSC,
    },
    '미래융합대학': {
      '메카트로닉스공학과': MajorKeys.FCCOLLEGEA,
      '소프트웨어융합공학과': MajorKeys.FCCOLLEGEB,
      '산업경영학과': MajorKeys.FCCOLLEGEC,
      '금융투자학과': MajorKeys.FCCOLLEGED,
    },
    '소프트웨어융합대학': {
      '인공지능공학과': MajorKeys.DOAI,
      '스마트모빌리티공학과': MajorKeys.SME,
      '데이터사이언스학과': MajorKeys.DATASCIENCE,
      '디자인테크놀리지학과': MajorKeys.DESIGNTECH,
      '컴퓨터공학과': MajorKeys.CSE,
    },
    '프런티어창의대학': {
      '자유전공융합학부': MajorKeys.LAS,
      '공학융합학부': MajorKeys.ECS,
      '자연과학융합학부': MajorKeys.NCS,
      '사회과학융합학부': MajorKeys.CVGSOSCI,
      '인문융합학부': MajorKeys.CVGHUMAN,
    },
  };

  /// **저장된 영문 학과명을 국문 학과명으로 번역**
  static String translateToKorean(String? majorKey) {
    return majorGroups.entries
        .expand((group) => group.value.entries)
        .firstWhere((entry) => entry.value == majorKey,
            orElse: () => const MapEntry('Unknown Major', ''))
        .key;
  }

  /// **국문 학과명을 영문 학과명으로 저장**
  static String translateToEnglish(String major) {
    return majorGroups.entries
        .expand((group) => group.value.entries)
        .firstWhere((entry) => entry.key == major,
            orElse: () => const MapEntry('', 'Unknown Major'))
        .value;
  }
}
