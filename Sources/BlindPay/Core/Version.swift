//
//  Version.swift
//  blindpay-swift
//

/// The SDK's own version metadata.
public enum BlindPaySDK {
    /// The SDK version, sent in the `User-Agent` (`blindpay-swift/<version>`).
    ///
    /// The single source of truth for releases: `release.yml` tags
    /// `v<version>` when this changes on `main`, and the API-sync workflow
    /// bumps it. Change it only in a release-bearing PR.
    public static let version = "5.2.0"
}
