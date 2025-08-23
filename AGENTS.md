# AGENTS.MD: Constitution for the AI Journal iOS Application

This document serves as the primary set of instructions and constraints for any AI agent working on this project. Adherence to these principles is mandatory. This is a living document; it should be updated as the project's requirements and architecture evolve.

## 1\. Core Philosophy & Product Vision

### 1.1. Primary Goal

To create a mobile-first, native iOS application that serves as a private, intelligent sanctuary for thoughts. The core experience is a "brain dump" page where users can freely express themselves via text or voice, with AI assistance for later organization. The final product must be of a quality suitable for release on the Apple App Store.

### 1.2. Guiding Principles (The Synthesis)

The agent must internalize and apply the following principles, which are synthesized from the philosophies of world-class technology companies. Every line of code and every design decision must be justifiable under this framework.

| Principle | Source Inspiration | Application in AI Journal | `agents.md` Directive |
| :--- | :--- | :--- | :--- |
| **Crafted to Perfection** | Linear | Every UI element, animation, and interaction must be pixel-perfect, performant, and feel intentional. The app must be blazing fast and responsive. | All UI code must be clean, efficient, and leverage hardware acceleration where appropriate. Performance is a primary feature. |
| **Developer-First Rigor** | Stripe | All code, including internal logic and data models, must be treated as a public-facing API: clean, consistent, well-documented, and robust. | Enforce strict naming conventions, clear data models, and explicit error handling. Avoid "magic numbers" and ambiguity. |
| **Unified & Universal** | Airbnb | The app will be built on a consistent, reusable set of components and patterns (a Design Language System). The experience must be universal—welcoming and accessible. | Create and reuse SwiftUI components. Adhere to accessibility standards (WCAG 2.1 AA) for all UI elements. |
| **Feels Like Apple** | Apple HIG | The app must feel like a natural extension of the iOS platform. It should be immediately intuitive to any iPhone user. | **Strict and non-negotiable adherence to Apple's Human Interface Guidelines is mandatory.** See Section 3 for details. |
| **Engineered for Retention**| Duolingo | The user journey is designed to build habits. Onboarding must be frictionless, and the core loop must incorporate positive reinforcement. | Implement a "try-before-you-buy" onboarding flow and build in architectural hooks for gamification features from day one. |

## 2\. Platform & Architectural Mandates

### 2.1. Target Platform & Technology Stack

  - **Platform**: iOS (targeting the latest major OS version and one version prior).
  - **Language**: **Swift (latest stable version)**.
  - **UI Framework**: **SwiftUI**. Use `UIKit` interoperability (via `UIViewRepresentable` or `UIViewControllerRepresentable`) only when a native SwiftUI solution is impossible or severely compromises performance or functionality. Justify any use of `UIKit` with a comment.

### 2.2. Architectural Pattern

  - **Mandate**: The application **MUST** follow the **Model-View-ViewModel (MVVM)** architectural pattern to ensure a clean separation of concerns, enhance testability, and improve maintainability.
  - **Model**: Represents the raw data and business logic (e.g., `JournalEntry`, `UserSettings`). Models must be `struct` types whenever possible and must conform to `Codable`.
  - **View**: Purely declarative SwiftUI views. Views **MUST NOT** contain any business logic. Their role is to display data provided by the ViewModel and relay user actions to it.
  - **ViewModel**: An `ObservableObject` class that manages state for a corresponding View. It handles all business logic, data manipulation, and communication with Model/Service layers.

### 2.3. API & Data Model Philosophy (Stripe-inspired)

  - **Directive**: Even though this app may initially be client-only, all data models and service layers **MUST** be designed as if they were part of a public, versioned REST API. This ensures robustness, clarity, and future-proofing.
  - **Rules**:
      - **Resource-Oriented Naming**: Data models must have clear, unambiguous names (e.g., `JournalEntry`, `ThoughtFragment`, `UserPreferences`).
      - **`Codable` Conformance**: All data models must conform to the `Codable` protocol.
      - **Explicit State Machines**: Use `enum`s to represent the status of objects rather than multiple booleans. For example:swift
        enum EntryStatus: String, Codable {
        case drafting
        case saved
        case processing // For AI organization
        case organized
        }
        ```
        This is preferable to using properties like `isDraft` and `isProcessed`.

        ```

## 3\. The iOS User Experience: Strict Adherence to Apple's Human Interface Guidelines (HIG)

This is a non-negotiable, top-priority directive. The app must feel like it was designed by Apple.

### 3.1. Core Tenets

  - **Hierarchy**: Content is the primary focus. The interface must elevate and support the user's content, not compete with it. Establish a clear visual hierarchy through typography, color, and layout.
  - **Harmony**: The app's design must align with the native look, feel, and conventions of iOS. Use system-provided components, fonts, and icons wherever possible.
  - **Consistency**: The app must be internally consistent and consistent with the broader iOS ecosystem. This builds user trust and makes the app intuitive.

### 3.2. UI/UX Directives Checklist

The agent must validate its UI implementations against the following checklist.

| Guideline | Requirement | Implementation Notes |
| :--- | :--- | :--- |
| **Clarity** | Legible text, clear controls, and understandable layout. | Use system fonts (`SF Pro`). Default text size **MUST** be at least 11 points. Ensure a minimum contrast ratio of 4.5:1 for text. |
| **Interactivity** | All interactive elements must be easy to tap. | All controls **MUST** have a minimum hit target of `44x44` points. Use standard SwiftUI gestures. Provide subtle haptic feedback for key interactions. |
| **Graphics** | All image assets must be crisp and undistorted. | Use `SF Symbols` for iconography. All custom bitmap assets must be provided at `@2x` and `@3x` resolutions. |
| **Adaptivity** | The UI must adapt to all device sizes, orientations, and system settings. | Views **MUST** adapt seamlessly to Dark Mode, Dynamic Type, and different screen sizes (from iPhone SE to Pro Max). Use `GeometryReader` and adaptive layouts. |

## 4\. Engineering Craftsmanship & Code Standards

### 4.1. Style, Formatting, and Naming

  - **Style Guide**: Adhere strictly to the official **Swift API Design Guidelines**.
  - **Formatting**: All generated Swift code must be compliant with `swift-format`.
  - **Naming Convention**: Employ **human-centric, descriptive, and unambiguous naming**.
      - **DO**: `var journalEntries: [JournalEntry]`, `func saveJournalEntry(entry: JournalEntry) async throws`, `let characterCount: Int`.
      - **AVOID**: `var data: [Any]`, `var arr`, `func handleData(d: Any)`, `var i: Int`. Variable names should communicate intent and context.

### 4.2. Humanization & Refactoring Protocols (The "No AI Trace" Mandate)

  - **Core Directive**: The final code committed **MUST NOT** contain any artifacts, comments, or patterns that identify it as AI-generated. The goal is code that is indistinguishable from that of a senior, idiomatic Swift developer.
  - **Prohibited Patterns (AI Code Smells)**:
      - **Redundant Comments**: Do not write comments that explain *what* the code is doing (e.g., `// Loop through the entries`). The code itself must be self-documenting. Comments should only be used to explain the *why*—the intent, complex business logic, or trade-offs.
      - **Overly Verbose or Generic Code ("AI Slop")**: Avoid unnecessarily complex or verbose implementations. If a standard Swift library function or a higher-order function (e.g., `map`, `filter`, `reduce`) can accomplish a task concisely, it **MUST** be preferred over a manual loop.
      - **Inconsistent Style**: The agent must maintain a consistent coding style across the entire project.
      - **No AI Signatures**: **Absolutely no comments like "As an AI model...", "Generated by...", or placeholder text that reveals AI origin.** Any such comment is a critical failure.
  - **Refactoring Mandate**: The agent is expected to refactor its own output. If a first-draft generation violates a principle (e.g., is not DRY, contains a "God Object," has deep nesting), the agent **MUST** refactor it to be compliant before presenting the final solution. The "return early" pattern is preferred to reduce nesting.

### 4.3. Security & Error Handling

  - **No Silent Failures**: All operations that can fail (e.g., network requests, file I/O, data parsing) **MUST** be handled explicitly using Swift's `async/throws` mechanisms or `Result` types. Do not use `try?` or `try!` unless there is a justifiable, documented reason.
  - **Input Validation**: All user-provided input must be validated and sanitized before use.
  - **Data Privacy**: No sensitive user data (journal entries) should be logged or transmitted without explicit user consent.

## 5\. The Retention Engine: Implementing the Duolingo Playbook

### 5.1. Onboarding & Core Loop

  - **Frictionless Entry**: The user **MUST** be able to access and use the core "brain dump" feature immediately upon launching the app for the first time. The sign-up/login flow is secondary and should be presented only when the user attempts to access features that require an account (e.g., cloud sync).
  - **Gamification Hooks**: The data models and business logic must be architected to support gamification.
      - The `User` or `Profile` model must include properties for `dailyStreak: Int`, `experiencePoints: Int`, and `unlockedAchievements: [Achievement]`.
      - An `Achievement` model should be defined to support milestones (e.g., "First Week Streak," "100 Thoughts Logged").

### 5.2. Feedback & Reinforcement

  - **Immediate Positive Feedback**: Upon successfully saving a journal entry, provide immediate, non-intrusive positive feedback. This should be implemented with subtle haptics (e.g., `.sensoryFeedback(.success, trigger: isSaved)`) and/or a brief, delightful animation (e.g., a checkmark).
  - **Progress Visualization**: The main UI must contain clear visual indicators of progress, such as a streak counter or a progress ring for a daily goal.
  - **Personalized Notifications**: Implement a local notification system. Notification copy should be friendly, encouraging, and personalized, reminiscent of Duolingo's mascot, to gently remind users to maintain their streak.

## 6\. Development Workflow & Quality Assurance

### 6.1. Build, Test, & Run Commands

  - **Build**: `xcodebuild build -scheme AIJournalApp -destination 'platform=iOS Simulator,name=iPhone 16 Pro'`
  - **Test**: `xcodebuild test -scheme AIJournalApp -destination 'platform=iOS Simulator,name=iPhone 16 Pro'`
  - **Run**: Use the standard Xcode "Run" command or `xcodebuild install` and `xcrun simctl launch`.

### 6.2. Testing Mandate (TDD)

  - **Directive**: Development **MUST** follow a Test-Driven Development (TDD) approach. For every new piece of non-trivial logic (especially in ViewModels and Models), a failing test using `XCTest` must be written first, followed by the implementation that makes it pass.
  - **Coverage**: All non-UI logic (ViewModels, Models, Services) **MUST** have a minimum of 80% unit test coverage.

### 6.3. Version Control Protocol

  - **Commit Messages**: All git commit messages **MUST** follow the **Conventional Commits** specification. This creates a clean, semantic, and machine-readable git history.
      - `feat:` for a new feature.
      - `fix:` for a bug fix.
      - `refactor:` for code changes that neither fix a bug nor add a feature.
      - `docs:` for documentation-only changes.
      - `test:` for adding missing tests or correcting existing tests.
      - `chore:` for changes to the build process or auxiliary tools.
      
## 7\. UI & Animation Mandates

- **Prefer Native Animations:** All animations and transitions **MUST** be implemented using native SwiftUI APIs like `matchedGeometryEffect`, `phaseAnimator`, and custom `AnyTransition`.
- **Fluidity is Key:** Animations should be responsive and interruptible. Use physics-based animations (e.g., `.spring()`) for a natural feel.
- **No Abrupt Changes:** State changes in the UI must always be animated using `withAnimation`.

<!-- end list -->

```
```
