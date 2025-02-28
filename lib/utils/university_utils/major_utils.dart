/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: junho Kim
 * Latest Updated Date: 2025-02-28
 */

import 'package:inha_notice/constants/university_keys/major_keys.dart';

abstract class MajorUtils {
  /// 그룹별 학과 매핑: 각 그룹별로 (한국어 학과명 → 영문 키) 를 정의합니다.
  static const Map<String, Map<String, String>> majorGroups = {
    MajorKeys.kEngineering: {
      MajorKeys.mechanicalEngineering: MajorKeys.MECH,
      MajorKeys.aerospaceEngineering: MajorKeys.AEROSPACE,
      MajorKeys.navalArchitecture: MajorKeys.NAOE,
      MajorKeys.industrialManagementEngineering: MajorKeys.IE,
      MajorKeys.chemicalEngineering: MajorKeys.CHEMENG,
      MajorKeys.polymerEngineering: MajorKeys.INHAPOLY,
      MajorKeys.materialsEngineering: MajorKeys.DMSE,
      MajorKeys.infrastructureEngineering: MajorKeys.CIVIL,
      MajorKeys.environmentalEngineering: MajorKeys.ENVIRONMENT,
      MajorKeys.geoinformatics: MajorKeys.GEOINFO,
      MajorKeys.architecture: MajorKeys.ARCH,
      MajorKeys.energyResourcesEngineering: MajorKeys.ENERES,
      MajorKeys.electricalEngineering: MajorKeys.ELECTRICAL,
      MajorKeys.electronicsEngineering: MajorKeys.EE,
      MajorKeys.informationTelecomEngineering: MajorKeys.ICE,
      MajorKeys.electricalElectronicEngineering: MajorKeys.EEE,
      MajorKeys.semiconductorSystemsEngineering: MajorKeys.SSE,
    },
    MajorKeys.kNaturalScience: {
      MajorKeys.mathematics: MajorKeys.MATH,
      MajorKeys.statistics: MajorKeys.STATISTICS,
      MajorKeys.physics: MajorKeys.PHYSICS,
      MajorKeys.chemistry: MajorKeys.CHEMISTRY,
      MajorKeys.foodNutrition: MajorKeys.FOODNUTRI,
    },
    MajorKeys.kBusiness: {
      MajorKeys.businessAdministration: MajorKeys.BIZ,
      MajorKeys.financeManagement: MajorKeys.GFIBA,
      MajorKeys.asiaPacificLogistics: MajorKeys.APSL,
      MajorKeys.internationalTrade: MajorKeys.STAR,
    },
    MajorKeys.kEducation: {
      MajorKeys.koreanEducation: MajorKeys.KOREANEDU,
      MajorKeys.englishEducation: MajorKeys.DELE,
      MajorKeys.socialEducation: MajorKeys.SOCIALEDU,
      MajorKeys.physicalEducation: MajorKeys.PHYSICALEDU,
      MajorKeys.educationMajor: MajorKeys.EDUCATION,
      MajorKeys.mathematicsEducation: MajorKeys.MATHED,
    },
    MajorKeys.kSocialScience: {
      MajorKeys.publicAdministration: MajorKeys.PUBLICAD,
      MajorKeys.politicalScience: MajorKeys.POLITICAL,
      MajorKeys.mediaCommunication: MajorKeys.COMM,
      MajorKeys.economics: MajorKeys.ECON,
      MajorKeys.consumerStudies: MajorKeys.CONSUMER,
      MajorKeys.childPsychology: MajorKeys.CHILD,
      MajorKeys.socialWelfare: MajorKeys.WELFARE,
    },
    MajorKeys.kHumanities: {
      MajorKeys.koreanLiterature: MajorKeys.KOREAN,
      MajorKeys.history: MajorKeys.HISTORY,
      MajorKeys.philosophy: MajorKeys.PHILOSOPHY,
      MajorKeys.chineseStudies: MajorKeys.CHINESE,
      MajorKeys.japaneseLanguageCulture: MajorKeys.JAPAN,
      MajorKeys.englishLiterature: MajorKeys.ENGLISH,
      MajorKeys.frenchCulture: MajorKeys.FRANCE,
      MajorKeys.cultureContentManagement: MajorKeys.CULTURECM,
    },
    MajorKeys.kMedicine: {
      MajorKeys.preMedicine: MajorKeys.MEDICINE,
    },
    MajorKeys.kNursing: {
      MajorKeys.nursingDepartment: MajorKeys.NURSING,
    },
    MajorKeys.kArtsSports: {
      MajorKeys.fineArts: MajorKeys.FINEARTS,
      MajorKeys.sportsScience: MajorKeys.SPORT,
      MajorKeys.theaterFilm: MajorKeys.THEATREFILM,
      MajorKeys.fashionDesign: MajorKeys.FASHION,
    },
    MajorKeys.kBioSystemFusion: {
      MajorKeys.bioEngineering: MajorKeys.BIO,
      MajorKeys.lifeScience: MajorKeys.BIOLOGY,
      MajorKeys.bioPharmEngineering: MajorKeys.BIOPHARM,
      MajorKeys.advancedBioMedicine: MajorKeys.BIOMEDICAL,
    },
    MajorKeys.kInternational: {
      MajorKeys.ibtDepartment: MajorKeys.SGCSA,
      MajorKeys.iseDepartment: MajorKeys.SGCSB,
      MajorKeys.klcDepartment: MajorKeys.SGCSC,
    },
    MajorKeys.kFutureFusion: {
      MajorKeys.mechatronics: MajorKeys.FCCOLLEGEA,
      MajorKeys.softwareFusionEngineering: MajorKeys.FCCOLLEGEB,
      MajorKeys.industrialManagement: MajorKeys.FCCOLLEGEC,
      MajorKeys.financeInvestment: MajorKeys.FCCOLLEGED,
    },
    MajorKeys.kSoftwareFusion: {
      MajorKeys.aiEngineering: MajorKeys.DOAI,
      MajorKeys.smartMobility: MajorKeys.SME,
      MajorKeys.dataScience: MajorKeys.DATASCIENCE,
      MajorKeys.designTechnology: MajorKeys.DESIGNTECH,
      MajorKeys.computerEngineering: MajorKeys.CSE,
    },
    MajorKeys.kFrontierCreative: {
      MajorKeys.interdisciplinaryStudies: MajorKeys.LAS,
      MajorKeys.engineeringFusion: MajorKeys.ECS,
      MajorKeys.naturalScienceFusion: MajorKeys.NCS,
      MajorKeys.socialScienceFusion: MajorKeys.CVGSOSCI,
      MajorKeys.humanitiesFusion: MajorKeys.CVGHUMAN,
    },
  };

  /// 전체 한국어 학과명 리스트 (모든 그룹에서 추출)
  static List<String> get kMajorKeyList =>
      majorGroups.values.expand((group) => group.keys).toList(growable: false);

  /// 전체 영문 키 리스트 (모든 그룹에서 추출)
  static List<String> get kMajorValueList => majorGroups.values
      .expand((group) => group.values)
      .toList(growable: false);

  /// 전체 한국어 학과명 → 영문 키 역매핑 (각 그룹을 병합)
  static Map<String, String> get kMajorMappingOnKey {
    final mapping = <String, String>{};
    for (final group in majorGroups.values) {
      mapping.addAll(group);
    }
    return mapping;
  }

  /// 전체 영문 키 → 한국어 학과명 역매핑 (자동 생성)
  static Map<String, String> get kMajorMappingOnValue =>
      {for (var entry in kMajorMappingOnKey.entries) entry.value: entry.key};
}
