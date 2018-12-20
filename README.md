# Vallet iOS

## Requirements

- Xcode 10.0 or later
- Homebrew 1.8.2 or later
- carthage 0.30.1 or later

## Initial Setup

Make sure that the machine has the necessary certificates (and private keys) installed in the keychain.
1. Install Carthage using Homebrew:

        brew install carthage

1. Build the Carthage dependencies using:

        carthage bootstrap --use-ssh --use-submodules --platform ios

1. Install Cocoapods dependencies:

        pod install

## Running the Project

1. Select the target in Xcode and run.

## Known Issues
- The client app does not allow purchases in quick succession. The [web3swift](https://github.com/matterinc/web3swift) library does not allow this at the moment, because the `nonce` value is not updated until the previous transaction is completed.
- Currently the faucet request is triggered every time the app is launched.
- The pricelist still uses the API server.
- The shop name is limited to 10 characters. This limitation is enforced by the form in the app as well as the API server.