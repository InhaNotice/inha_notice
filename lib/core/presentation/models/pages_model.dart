/*
 * This is file of the project inha_notice
 * Licensed under the Apache License 2.0.
 * Copyright (c) 2025-2026 INGONG
 * For full license text, see the LICENSE file in the root directory or at
 * http://www.apache.org/licenses/
 * Author: Junho Kim
 * Latest Updated Date: 2026-02-12
 */

typedef Pages = Map<String, dynamic>;

Pages createPages([String? searchColumn, String? searchWord]) => {
      'pageMetas': <Map<String, dynamic>>[],
      'searchOptions': <String, dynamic>{
        'searchColumn': searchColumn,
        'searchWord': searchWord,
      },
    };
