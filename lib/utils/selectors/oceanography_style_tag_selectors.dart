/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2025-08-29
 */

abstract class OceanographyStyleTagSelectors {
  static const String kNoticeBoard = '.pic1';
  static const String kNoticeBoardTable = 'table';
  static const String kHeadline = '[공지]';
  static const String kPageBoard =
      'tbody > tr > td > table > tbody > tr > td > table > tbody > tr > td:nth-child(9) > a';
  static const String kProvider = 'oceanography';
}
