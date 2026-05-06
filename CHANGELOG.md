# Changelog

- please enter new entries in format, new entries on top

```
- <description> (#<PR_number>, kudos to @<author>)
```

## Next

- Add configurable `contrasts` parameter for snapshotting in high contrast (#17, kudos to @leinhauplk)
- Add configurable `drawHierarchyInKeyWindow` parameter for UIView and SwiftUI snapshots (#16, kudos to @komkovla)
- Update the package to Swift 6.2 (#15, kudos to @dede64)
- Fix nameAddition parameter, which did not work (#15, kudos to @dede64)
- Fix colorScheme is not applied on size and component snapshots (#13, kudos to @komkovla)
- Fix counter not being reset between test cases (#12, kudos to @komkovla)

## 0.4.0

- Add UIKit support for snapshot testing (#11, kudos to @komkovla)
- Add comprehensive test suite with examples (#11, kudos to @komkovla)

## 0.3.0

- Add index to the snapshot to avoid name clash on multiple asserts in one test (#10, kudos to @komkovla)
- Add `displayScale` parameter to public assert functions (#9, kudos to @olejnjak)
- Fixes bug: Snapshot for one device doesn't respect scrollViewMultiplier (#7) (#8, kudos to @komkovla)

## 0.2.0

- Adds orientation customizability for SnapshotDevice (#5, kudos to @nadvitek)
- Adds testDynamicSize parameter, which allows to control capturing dynamic size screenshots (#4, kudos to @babacros)

