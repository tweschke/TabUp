# Release checklist — v1.1

Use this before tagging or submitting **1.1** to the App Store.

## Build & quality

- [ ] Open **TabsUp** scheme; **Product → Clean Build Folder**, then **Build** (Debug and Release as needed)
- [ ] Run **unit tests** (`TabsUpTests`) on a supported simulator or device
- [ ] Run **UI tests** (`TabsUpUITests`) where applicable
- [ ] Fix or document any new build warnings that block release

## UI & behaviour

- [ ] Manual pass on **Split** flows (regression)
- [ ] Manual pass on **Tip mode** (happy path + obvious edge cases)
- [ ] Portrait-only and supported devices verified
- [ ] No crashes on launch and after background/foreground

## Versioning

- [ ] **Marketing version** set to **1.1** (and **Current Project Version** / build number incremented per your scheme)
- [ ] Version strings match between Xcode, archive, and App Store Connect

## App Store prep

- [ ] **Archive** in Xcode; validate in Organizer
- [ ] Upload build to App Store Connect (TestFlight first if that is your process)
- [ ] Release notes / “What’s New” drafted for 1.1
- [ ] Screenshots and metadata updated only if 1.1 changes visible UI (otherwise confirm still accurate)
- [ ] Final review in App Store Connect; submit for review when ready
