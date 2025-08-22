# Use SwiftUI + iOS 17+
- Prefer SwiftUI.
- Use @Observable or ObservableObject where needed.
- All screens must include a #Preview with mock data.
- No magic numbers; read spacing/color/typography from Tokens.

# Architecture
- MVVM: Views are "dumb," state lives in ViewModels.
- Protocol-first services (EntryStore, AIClient). Provide mocks for previews/tests.
- No hard-coded secrets. Use .xcconfig for API keys.

# Quality
- Keep PR-sized changes: ≤ 400 LOC per edit.
- Zero SwiftUIint violations; run SwiftFormat before finishing.
- Add one unit or UI test per feature slice.

# Output style
- Write complete code, not placeholders.
- Explain your plan before edits.
