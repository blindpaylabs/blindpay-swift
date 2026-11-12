# Releasing blindpay-swift

SwiftPM resolves versions from git tags, so a release is a `v<version>` tag plus a GitHub release. There is no registry upload.

## Version source of truth

`BlindPaySDK.version` in `Sources/BlindPay/Core/Version.swift`. It is also the User-Agent (`blindpay-swift/<version>`). Bump it in the PR that should release: major for breaking changes, minor for additive ones, patch for fixes. `sync.swift --apply` bumps the minor itself for API-sync PRs.

## What a merge to `main` does

1. `ci.yml` runs on the push (macOS: build, test, contract, sync checks; Linux `swift:6.0`: build, test; iOS: `xcodebuild` build).
2. `release.yml` runs `.github/scripts/release-check.sh`: it reads the constant and runs `git ls-remote` for tag `v<version>`.
   - Tag exists: it does nothing. A merge that doesn't change the constant never releases.
   - Tag missing: it pushes the tag at the merge commit and runs `gh release create v<version> --generate-notes`.
3. `api-sync-merged.yml` (only for PRs labelled `api-sync`) clears the sync baseline on the `api-sync-data` branch.
4. Swift Package Index picks the new tag up by itself and rebuilds the docs (`.spi.yml`).

`release.yml` does not wait for `ci.yml`. Merge only with green CI.

## Secrets and who owns them

| Secret | Used by | Owner |
|---|---|---|
| `GITHUB_TOKEN` (built in, `contents: write`) | `release.yml`: tag and release | GitHub |
| `SDK_SYNC_PAT` | `api-sync.yml` (push the `api-sync` branch, open and auto-merge the PR), `api-sync-merged.yml` | blindpaylabs org admins |
| `SLACK_WEBHOOK_URL` | `pipeline-alert.yml` (failure alerts for CI, Release, API Sync) | blindpaylabs org admins |

No OIDC or registry credentials are involved.

## Re-running a stuck release

The check is idempotent, so re-running is always safe:

```bash
gh workflow run release.yml -R blindpaylabs/blindpay-swift --ref main   # or: gh run rerun <run-id> --failed
```

If the tag was pushed but `gh release create` failed, create the release by hand for the same tag:

```bash
gh release create v5.1.0 -R blindpaylabs/blindpay-swift --title v5.1.0 --generate-notes --verify-tag
```

Never move or delete a published tag: SwiftPM and SPI cache tag revisions. Fix forward with a new patch version.

## Verifying the published release

```bash
git ls-remote --tags https://github.com/blindpaylabs/blindpay-swift refs/tags/v5.1.0   # tag points at the merge commit
gh release view v5.1.0 -R blindpaylabs/blindpay-swift
```

Then resolve it from a scratch package that depends on `.package(url: "https://github.com/blindpaylabs/blindpay-swift", exact: "5.1.0")`, run `swift build`, and check that `BlindPaySDK.version` prints `5.1.0`. Check the Swift Package Index page lists the version.

## Known traps

- **API-sync auto-merge.** `api-sync.yml` opens its PR with auto-merge, and `main` has no required status checks (the "Main" ruleset targets no branch), so a sync PR can merge and release with red CI (it happened with #51, v4.5.1). Until an admin makes CI a required check, watch sync PRs.
- **One bump per release.** A hand-written PR and an API-sync PR that both change the constant release twice. If a sync PR lands first, rebase the hand-written PR and bump from the new version.
- **No automatic sync delivery.** `blindpay-v2`'s `sdk-sync.yml` runs only on `workflow_dispatch` (its push trigger is commented out). Dispatch it from blindpay-v2 to deliver a new spec.
- **Snapshot size.** `sync.swift --apply` copies the spec file verbatim into `.api-sync/spec-snapshot.json`. Pass a 2-space pretty spec (`jq --indent 2 .`; `api-sync.yml` does) or the diff is the whole file.
- **Error codes.** After a spec refresh, regenerate `Sources/BlindPay/Core/ErrorCode.swift` with `swift .api-sync/check-contract.swift --write-error-codes`; CI fails until you do.
