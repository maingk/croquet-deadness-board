# Simple Xcode Setup - 5 Minutes

This guide uses the **simplest possible approach**: Your Swift Package stays as-is (it already builds!), and we create tiny Xcode app projects that use it.

## What We'll Do

1. Open Xcode and create a blank iOS app (2 minutes)
2. Link it to your Swift Package (1 minute)
3. Copy just the app entry point file (30 seconds)
4. Repeat for tvOS (2 minutes)

That's it!

---

## Part 1: Create iOS App (3 minutes total)

### Step 1: Create New iOS Project in Xcode

1. **Open Xcode**
2. **File** → **Close Workspace/Project** (if anything is open)
3. **File** → **New** → **Project** (⇧⌘N)
4. Select **iOS** → **App** → **Next**
5. Fill in:
   - Product Name: **CroquetControlApp**
   - Organization Identifier: **com.croquet.deadness**
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **Uncheck everything**
6. Click **Next**
7. Save location: **Desktop** (NOT your project folder - we'll keep it separate)
8. **Uncheck** "Create Git repository"
9. Click **Create**

### Step 2: Add Swift Package Dependency

1. Select **CroquetControlApp** project (top of navigator)
2. Select **CroquetControlApp** target
3. **General** tab → Scroll to **Frameworks, Libraries, and Embedded Content**
4. Click **"+"**
5. **"Add Other..."** → **"Add Package Dependency..."**
6. Click the **folder icon** in search field
7. Navigate to `/Users/richard/Projects/croquet-deadness-board`
8. Select **Package.swift**
9. Click **Add Package**
10. Select both libraries:
    - ☑ SharedModels
    - ☑ SharedServices
11. Click **Add**

### Step 3: Replace App Entry Point

1. In Xcode navigator, find **CroquetControlAppApp.swift**
2. Delete its contents
3. Copy this code:

```swift
import SwiftUI
import SharedModels
import SharedServices

@main
struct CroquetControlApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Simple starter view - we'll connect to your real views later
struct ContentView: View {
    var body: some View {
        Text("Croquet Control App")
            .font(.largeTitle)
    }
}
```

4. **Build** (⌘B)

**Expected result:** Build succeeds! ✅

---

## Part 2: Create tvOS App (2 minutes total)

Repeat the exact same steps, but:
- Choose **tvOS** → **App** template
- Product Name: **CroquetDisplayApp**
- Save to Desktop (separate location)
- Link same Package.swift
- Entry point code:

```swift
import SwiftUI
import SharedModels
import SharedServices

@main
struct CroquetDisplayApp: App {
    var body: some Scene {
        WindowGroup {
            DisplayContentView()
        }
    }
}

struct DisplayContentView: View {
    var body: some View {
        Text("Croquet Display App")
            .font(.largeTitle)
    }
}
```

---

## Part 3: Connect Your Real Views (Later)

Once both apps build successfully, we can:
1. Copy your view files from `iOS-ControlApp/Views/` into the iOS project
2. Copy your viewmodel files
3. Update the entry points to use your real ContentView

But first, let's make sure the basic projects build!

---

## Why This Works

- ✅ Your Swift Package is separate and clean
- ✅ Firebase dependencies are in the package (already working)
- ✅ Apps are simple wrappers
- ✅ Easy to rebuild if needed
- ✅ Xcode manages everything automatically

---

## Ready?

Just follow Part 1 step by step. Let me know when you've completed Step 2 (adding the package dependency) and I'll help with the next part!
