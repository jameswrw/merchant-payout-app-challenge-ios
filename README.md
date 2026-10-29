# Merchant Payout App Challenge (iOS)

I believe the following requuirements have been carried out:
- Review account balances and recent activity with pagination
- Initiate and validate a payout to a bank account with confirmation
- Persist a device identity for payout requests
- Require biometric authentication for payouts over £1,000.00
- Protect the payout screen from screenshots and screen recording
- Handle various edge cases, including network errors and insufficient funds

There are some examples of accessibility usage such as accessibilityIdentifiers for UI tests and traits to identify headers.
There are more magic padding numbers than I would like. Ideally there would be a design system and a limited amount of options for padding and insets.
On the subject of design systems I have tried to use system colours and images throughout. A commercial app may want their own set of designs and a corporate colour scheme.
Tests have been written for some of the functionality expressed in the view models. Some untested areas really need proper dependency injection. For instance grouping items by date would be sensitive to being run around midnight as something that might be 'today might switch to 'yesterday' during a test run. Using PointFree's Swift Dependencies would be something to consider in a production app. Snapshot testing would be another nice to have. PointFree have a Swift package for that too. Other libraries are available.
AI has been used where appropriate. Mostly assisting where once upon a time Google was the solution. I will admit to the Toast being almost entirely AI. It seems a good use. Toasts are a solved problem, and a minor part of the test. If an AI can get 99% there in seconds it seems silly to spend time re-inventing the wheel.
Re-trying FaceID seems to require a real device. It works on my iPhone, but not on the simulator / device hub.
Error handling is a mix. Errors from the api/payouts where the MockURLProtocol generates errors for certain values are shown to the user. Other endpoints use print. They could do something similar to api/payouts, but as this is a challenge app I kept them simple. Also, screens using the other endpoints have a ContentUnavailableView providing some feedback beyond an empty screen. Keychain errors around persisting the device identifier use os\_log(). Here there is more justification as it happens early in app startup, so there isn't much UI to show, and the user probably isn't that interested if an optional device id isn't being tracked, but developers may well be.


