/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-01-19
 */

/// 학과 목록 (키, 국문명, 단과대명 문자열 포함)
enum MajorType {
  // [공과대학] (18개)
  mechanicalEngineering(key: 'MECH', name: '기계공학과', college: '공과대학'),
  aerospaceEngineering(key: 'AEROSPACE', name: '항공우주공학과', college: '공과대학'),
  navalArchitecture(key: 'NAOE', name: '조선해양공학과', college: '공과대학'),
  industrialManagementEngineering(key: 'IE', name: '산업경영공학과', college: '공과대학'),
  chemicalEngineering(key: 'CHEMENG', name: '화학공학과', college: '공과대학'),
  polymerEngineering(key: 'INHAPOLY', name: '고분자공학과', college: '공과대학'),
  materialsEngineering(key: 'DMSE', name: '신소재공학과', college: '공과대학'),
  infrastructureEngineering(key: 'CIVIL', name: '사회인프라공학과', college: '공과대학'),
  environmentalEngineering(key: 'ENVIRONMENT', name: '환경공학과', college: '공과대학'),
  geoinformatics(key: 'GEOINFO', name: '공간정보공학과', college: '공과대학'),
  architecture(key: 'ARCH', name: '건축학부', college: '공과대학'),
  energyResourcesEngineering(key: 'ENERES', name: '에너지자원공학과', college: '공과대학'),
  electricalEngineering(key: 'ELECTRICAL', name: '전기공학과', college: '공과대학'),
  electronicsEngineering(key: 'EE', name: '전자공학과', college: '공과대학'),
  informationTelecomEngineering(key: 'ICE', name: '정보통신공학과', college: '공과대학'),
  electricalElectronicEngineering(key: 'EEE', name: '전기전자공학부', college: '공과대학'),
  semiconductorSystemsEngineering(
      key: 'SSE', name: '반도체시스템공학과', college: '공과대학'),
  iBattery(key: 'IBATTERY', name: '이차전지융합학과', college: '공과대학'),

  // [자연과학대학] (6개)
  mathematics(key: 'MATH', name: '수학과', college: '자연과학대학'),
  statistics(key: 'STATISTICS', name: '통계학과', college: '자연과학대학'),
  physics(key: 'PHYSICS', name: '물리학과', college: '자연과학대학'),
  chemistry(key: 'CHEMISTRY', name: '화학과', college: '자연과학대학'),
  foodNutrition(key: 'FOODNUTRI', name: '식품영양학과', college: '자연과학대학'),
  oceanography(key: 'OCEANOGRAPHY', name: '해양과학과', college: '자연과학대학'),

  // [경영대학] (4개)
  businessAdministration(key: 'BIZ', name: '경영학과', college: '경영대학'),
  financeManagement(key: 'GFIBA', name: '파이낸스경영학과', college: '경영대학'),
  asiaPacificLogistics(key: 'APSL', name: '아태물류학과', college: '경영대학'),
  internationalTrade(key: 'STAR', name: '국제통상학과', college: '경영대학'),

  // [사범대학] (6개)
  koreanEducation(key: 'KOREANEDU', name: '국어교육과', college: '사범대학'),
  englishEducation(key: 'DELE', name: '영어교육과', college: '사범대학'),
  socialEducation(key: 'SOCIALEDU', name: '사회교육과', college: '사범대학'),
  physicalEducation(key: 'PHYSICALEDU', name: '체육교육과', college: '사범대학'),
  educationMajor(key: 'EDUCATION', name: '교육학과', college: '사범대학'),
  mathematicsEducation(key: 'MATHED', name: '수학교육과', college: '사범대학'),

  // [사회과학대학] (7개)
  publicAdministration(key: 'PUBLICAD', name: '행정학과', college: '사회과학대학'),
  politicalScience(key: 'POLITICAL', name: '정치외교학과', college: '사회과학대학'),
  mediaCommunication(key: 'COMM', name: '미디어커뮤니케이션학과', college: '사회과학대학'),
  economics(key: 'ECON', name: '경제학과', college: '사회과학대학'),
  consumerStudies(key: 'CONSUMER', name: '소비자학과', college: '사회과학대학'),
  childPsychology(key: 'CHILD', name: '아동심리학과', college: '사회과학대학'),
  socialWelfare(key: 'WELFARE', name: '사회복지학과', college: '사회과학대학'),

  // [문과대학] (7개)
  // * 참고: ENGLISH(영어영문), FRANCE(프랑스언어문화)는 angloEuropeanHumanities(영미유럽인문융합학부)로 통합됨.
  koreanLiterature(key: 'KOREAN', name: '한국어문학과', college: '문과대학'),
  history(key: 'HISTORY', name: '사학과', college: '문과대학'),
  philosophy(key: 'PHILOSOPHY', name: '철학과', college: '문과대학'),
  chineseStudies(key: 'CHINESE', name: '중국학과', college: '문과대학'),
  japaneseLanguageCulture(key: 'JAPAN', name: '일본언어문화학과', college: '문과대학'),
  angloEuropeanHumanities(key: 'EES', name: '영미유럽인문융합학부', college: '문과대학'),
  cultureContentManagement(
      key: 'CULTURECM', name: '문화콘텐츠문화경영학과', college: '문과대학'),

  // [의과대학] (1개)
  preMedicine(key: 'MEDICINE', name: '의예과(의학과)', college: '의과대학'),

  // [간호대학] (1개)
  nursingDepartment(key: 'NURSING', name: '간호학과', college: '간호대학'),

  // [예술체육대학] (5개)
  fineArts(key: 'FINEARTS', name: '조형예술학과', college: '예술체육대학'),
  inhaDesign(key: 'INHADESIGN', name: '디자인융합학과', college: '예술체육대학'),
  sportsScience(key: 'SPORT', name: '스포츠과학과', college: '예술체육대학'),
  theaterFilm(key: 'THEATREFILM', name: '연극영화학과', college: '예술체육대학'),
  fashionDesign(key: 'FASHION', name: '의류디자인학과', college: '예술체육대학'),

  // [바이오시스템융합학부] (4개)
  bioEngineering(key: 'BIO', name: '생명공학과', college: '바이오시스템융합학부'),
  lifeScience(key: 'BIOLOGY', name: '생명과학과', college: '바이오시스템융합학부'),
  bioPharmEngineering(key: 'BIOPHARM', name: '바이오제약공학과', college: '바이오시스템융합학부'),
  advancedBioMedicine(
      key: 'BIOMEDICAL', name: '첨단바이오의약학과', college: '바이오시스템융합학부'),

  // [국제학부] (3개)
  ibtDepartment(key: 'SGCSA', name: 'IBT학과', college: '국제학부'),
  iseDepartment(key: 'SGCSB', name: 'ISE학과', college: '국제학부'),
  klcDepartment(key: 'SGCSC', name: 'KLC학과', college: '국제학부'),

  // [미래융합대학] (4개)
  mechatronics(key: 'FCCOLLEGEA', name: '메카트로닉스공학과', college: '미래융합대학'),
  softwareFusionEngineering(
      key: 'FCCOLLEGEB', name: '소프트웨어융합공학과', college: '미래융합대학'),
  industrialManagement(key: 'FCCOLLEGEC', name: '산업경영학과', college: '미래융합대학'),
  financeInvestment(key: 'FCCOLLEGED', name: '금융투자학과', college: '미래융합대학'),

  // [소프트웨어융합대학] (5개)
  aiEngineering(key: 'DOAI', name: '인공지능공학과', college: '소프트웨어융합대학'),
  smartMobility(key: 'SME', name: '스마트모빌리티공학과', college: '소프트웨어융합대학'),
  dataScience(key: 'DATASCIENCE', name: '데이터사이언스학과', college: '소프트웨어융합대학'),
  designTechnology(key: 'DESIGNTECH', name: '디자인테크놀리지학과', college: '소프트웨어융합대학'),
  computerEngineering(key: 'CSE', name: '컴퓨터공학과', college: '소프트웨어융합대학'),

  // [프런티어창의대학] (6개)
  interdisciplinaryStudies(key: 'LAS', name: '자유전공융합학부', college: '프런티어창의대학'),
  engineeringFusion(key: 'ECS', name: '공학융합학부', college: '프런티어창의대학'),
  naturalScienceFusion(key: 'NCS', name: '자연과학융합학부', college: '프런티어창의대학'),
  businessFusion(key: 'CVGBA', name: '경영융합학부', college: '프런티어창의대학'),
  socialScienceFusion(key: 'CVGSOSCI', name: '사회과학융합학부', college: '프런티어창의대학'),
  humanitiesFusion(key: 'CVGHUMAN', name: '인문융합학부', college: '프런티어창의대학');

  final String key;
  final String name;
  final String college;

  const MajorType({
    required this.key,
    required this.name,
    required this.college,
  });

  /// --------------------------------------------------------------------------
  /// 유틸리티 (기존 MajorUtils 대체)
  /// --------------------------------------------------------------------------

  /// 그룹별 학과 매핑: Map<단과대명(String), Map<학과명, 학과코드>>
  static Map<String, Map<String, String>> get majorGroups {
    final Map<String, Map<String, String>> groups =
        <String, Map<String, String>>{};

    // MajorType 순회하며 그룹핑
    for (final major in MajorType.values) {
      // 단과대 그룹이 없으면 생성
      if (!groups.containsKey(major.college)) {
        groups[major.college] = {};
      }
      // 해당 단과대 맵에 학과 정보 추가
      groups[major.college]![major.name] = major.key;
    }

    return groups;
  }

  /// 전체 한국어 학과명 리스트
  static List<String> get majorKeyList =>
      MajorType.values.map((e) => e.name).toList(growable: false);

  /// 전체 영문 키 리스트
  static List<String> get majorValueList =>
      MajorType.values.map((e) => e.key).toList(growable: false);

  /// 한국어 학과명 -> 영문 키 매핑
  static Map<String, String> get majorMappingOnKey =>
      {for (var e in MajorType.values) e.name: e.key};

  /// 영문 키 -> 한국어 학과명 매핑
  static Map<String, String> get majorMappingOnValue =>
      {for (var e in MajorType.values) e.key: e.name};

  /// 학과 폐지/통합 등으로 인해 지원되지 않는 키를 현재 학과의 국문명으로 반환
  static String? getUnsupportedMajorKoreanName(String oldKey) {
    const Map<String, String> kUnsupported = {
      'ENGLISH': '영미유럽인문융합학부', // Maps to angloEuropeanHumanities
      'FRANCE': '영미유럽인문융합학부', // Maps to angloEuropeanHumanities
    };
    return kUnsupported[oldKey];
  }

  /// key로 MajorType 찾기
  static MajorType? getByKey(String key) {
    try {
      return MajorType.values.firstWhere((e) => e.key == key);
    } catch (_) {
      // 레거시 코드 처리
      final String? mappedName = getUnsupportedMajorKoreanName(key);
      if (mappedName != null) {
        try {
          return MajorType.values.firstWhere((e) => e.name == mappedName);
        } catch (_) {}
      }
      return null;
    }
  }
}
