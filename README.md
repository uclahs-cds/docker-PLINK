# docker-PLINK
Dockerfile for PLINK 1.9, an open-source whole-genome association analysis toolset.

# Documentation
PLINK 1.9 usage instructions can be found at https://www.cog-genomics.org/plink/1.9/.

# Version
### Background
PLINK has extremely confusing versioning.

* PLINK 1.07 was originally developed by Shaun Purcell and includes an
  application named `plink`.
* PLINK 1.9 (originally developed by Chris Chang and others) is a complete
  re-write of PLINK 1.07 that is _almost_ but not entirely feature-compatible
  with it. PLINK 1.9 is currently in beta releases and includes an application
  named `plink`.
* PLINK 2.0 (developed by Chris Chang and others) is an alpha-stage program
  with a new file format designed to enable new kinds of computations. It is
  not feature-compatible with PLINK 1.9 and includes an application named
  `plink2`.

In broad strokes, PLINK 2.0 is used for most new development, but PLINK 1.9 is
required for specific use cases. PLINK 1.07 is deprecated and unused.

However, the community generally differentiates between "PLINK 1" (1.07)
and "PLINK 2" / "second-generation PLINK" (1.9 and 2.0) based on the project
management transition from Shaun Purcell to Chris Chang. For example, the
`plink2-users@googlegroups.com` [mailing
list](https://groups.google.com/g/plink2-users) has a stated purpose of
"discussion of interest to regular PLINK 1.9 and 2.0 users." 

PLINK 1.9 release files are differentiated by datestamp (e.g.
`plink_<arch>_20230116.zip`). The [PLINK
website](https://www.cog-genomics.org/plink/) includes descriptive release
links, such as "Stable (beta 7, 16 Jan)", but the linked filenames do not
include these tags. The binaries each include a version string that combines
the descriptive name and build date:

```console
$ plink --version
PLINK v1.90b7 64-bit (16 Jan 2023)
```

There is no way to determine the baked-in version string from the filename:

| Filename | Version String | Inferred Version |
|----------|----------------|------------------|
|`plink_linux_x86_64_20220402.zip`|PLINK v1.90b6.26 64-bit (2 Apr 2022)|b6.26|
|`plink_linux_x86_64_20221210.zip`|PLINK v1.90b6.27 64-bit (10 Dec 2022)|b6.27|
|`plink_linux_x86_64_20230116.zip`|PLINK v1.90b7 64-bit (16 Jan 2023)|b7|
|`plink_linux_x86_64_latest.zip`|PLINK v1.90b7 64-bit (16 Jan 2023)|b7|

Additionally, neither the filename nor the version string reference the git
commit hash from which the code was built. The developers do not create release
tags for PLINK 1.9, so if we want to associate the version string with a commit
ID we must do so manually.

### Takeaway

For the purposes of this image:

* PLINK and `plink` will refer to PLINK 1.9
* PLINK 2 and `plink2` will refer to PLINK 2.0 (not included in this image)
* The docker tag version will be a combination of the compiled version string
  and the associated commit hash, e.g. `v1.90b7-a84a0cd`.
* The commit hash, release date, descriptive tags, and built-in version strings
  will be listed separately for in the table below for clarity

| Tool | Hash | Date | Descriptive Tag | Built-In Version String |
|------|------|------|-----------------|-------------------------|
| PLINK 1.9 | [a84a0cd](https://github.com/chrchang/plink-ng/commit/a84a0cd4b0e53cd9542e86487c11e0b58555a87f) | 20230116 | Stable (beta 7, 16 Jan) | v1.90b7 64-bit (16 Jan 2023) |

---

## References

1. Chang CC, Chow CC, Tellier LCAM, Vattikuti S, Purcell SM, Lee JJ (2015) Second-generation PLINK: rising to the challenge of larger and richer datasets. GigaScience, 4. https://doi.org/10.1186/s13742-015-0047-8

---

## License

Author: Nicholas Wiltsie

docker-PLINK is licensed under the GNU General Public License version 2. See the file LICENSE for the terms of the GNU GPL license.

docker-PLINK enables dockerized access to the PLINK toolset.

Copyright (C) 2023 University of California Los Angeles ("Boutros Lab") All rights reserved.

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
