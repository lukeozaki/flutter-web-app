---
name: pendo-install
description: "Use only when the user explicitly invokes @pendo-install to install and configure a Pendo snippet in an application. Detect the framework, authentication, user/account data, placement, initialization timing, and route tracking."
argument-hint: "Paste the Pendo snippet provided by Pendo"
tools: [read, search, edit, execute]
user-invocable: true
disable-model-invocation: true
---

# Pendo Installation Assistant

## Activation rule

Activate only when the user explicitly invokes `@pendo-install`. Never suggest or implement Pendo without that explicit invocation.

When activated, the user only needs to provide the Pendo snippet as given by Pendo. Automatically detect the application type and handle configuration.

## Step 1: Detect application type and place snippet

When the user provides a Pendo snippet, detect the application type by checking package.json dependencies, configuration files, and file structure. Use this priority order:

- `react` -> React SPA
- `vue` -> Vue SPA
- `@angular/core` -> Angular SPA
- `ember-cli` -> Ember SPA
- `next` -> Next.js SSR/SPA hybrid
- `nuxt` -> Nuxt SSR/SPA hybrid
- `svelte` -> Svelte SPA
- Multiple package.json files in subdirectories -> likely micro-frontend architecture
- `.php` -> PHP MPA
- `.erb` -> Ruby on Rails MPA
- `.ejs`, `.pug`, or `.hbs` -> Node.js MPA
- `.jsp` -> Java MPA
- `.cshtml` -> .NET MPA
- Server templates without an SPA framework -> MPA

Place the snippet according to the detected type:

- React: split snippet and place the loader in `public/index.html` or `index.html`.
- Vue: split snippet and place the loader in `public/index.html`.
- Angular: split snippet and place the loader in `src/index.html`.
- Next.js: split snippet and place the loader in custom `_document.js` or `_app.js`.
- Nuxt: split snippet and place the loader in the `nuxt.config.js` head section.
- Rails: use `app/views/layouts/application.html.erb`.
- PHP: use `header.php` or `layout.php`.
- Node.js templates: use `views/layout.*` or `views/partials/head.*`.
- .NET: use `_Layout.cshtml`.
- Micro-frontends: locate the shell or host app, then use its index.html or equivalent.

Never modify the user-provided snippet.

## Step 2: Detect authentication and data sources

Scan for authentication patterns including `useAuth`, `useUser`, `AuthContext`, `UserContext`, Vue store user state, `AuthService`, `UserService`, `currentUser`, session stores, JWT decoding, and API calls to `/user`, `/profile`, or `/me`.

Determine whether the app is authenticated, mixed public/private, or primarily public by looking for `PrivateRoute`, `AuthGuard`, `requireAuth`, and protected routes. Detect whether user data comes from global state, an API response, JWT/cookies, or another source.

## Step 3: Report configuration and stop

Before editing, report:

```text
Pendo Installation Analysis:

Detected: [framework/type] application
- Framework version: [version]
- Authentication: [Required/Optional/Mixed]
- User data source: [Store/API/JWT/Session]

Snippet placement:
- Loader location: [exact path]
- Initialize timing: [lifecycle or hook]

This configuration will:
- Track [authenticated/all] users
- Initialize [after login/on page load]
- Capture [SPA routes/page loads]
```

Then stop and ask: `Configuration looks correct? Ready to scan for user data fields?`
Do not implement until the user confirms.

## Step 4: Map user and account data after confirmation

Scan state management and API responses. Map these fields when found:

Visitor mappings:

- `id`, `userId`, `user_id`, `uid` -> `visitor.id`
- `email`, `emailAddress`, `user_email` -> `visitor.email`
- `name`, `fullName`, `displayName`, `full_name` -> `visitor.full_name`
- `role`, `roles`, `userRole`, `permission` -> `visitor.role`
- `createdAt`, `created_at`, `signupDate` -> `visitor.created_at`

Account mappings:

- `accountId`, `account_id`, `companyId`, `company_id` -> `account.id`
- `accountName`, `companyName`, `organizationName` -> `account.name`
- `plan`, `planType`, `subscription`, `tier` -> `account.plan_level`
- `industry`, `vertical`, `segment` -> `account.industry`

Also scan user and account objects for shallow metadata. Normalize camelCase to snake_case, flatten one nested level, convert dates to ISO8601, convert primitive arrays to comma-separated strings, and preserve finite numbers and booleans. Add `is_` or `has_` prefixes to booleans when appropriate.

Exclude passwords, tokens, secrets, functions, methods, internal IDs except primary IDs, deeply nested objects, null or undefined values, and fields longer than 1000 characters. Keep the total metadata payload under 64KB.

## Step 5: Report mappings and stop

Before editing, display the complete mapping plan, including visitor and account field paths, example values, implementation locations, SPA routing behavior, and excluded sensitive or invalid fields. Then ask for confirmation:

`Ready to implement?`

Do not implement until the user confirms.

## Step 6: Implement after confirmation

Implement all approved changes:

- Place the unmodified loader snippet in the detected location.
- Add initialization using the detected visitor and account mappings.
- Initialize at the detected lifecycle point, after authentication or data hydration when required.
- Add SPA `pageLoad()` tracking when a routing library is detected.
- Add TypeScript definitions only when the project uses TypeScript.
- Use environment variables when `.env` files or existing environment configuration are present.
- Preserve existing code patterns and avoid unrelated refactoring.

## Step 7: Validate and report

Run the narrowest relevant tests, type checks, lint checks, and build checks available. Verify the loader placement, initialization timing, required IDs, metadata filtering, and payload size. Do not claim browser-console validation unless a browser check was actually performed.

Provide this checklist:

1. Start the app using its existing framework-specific command.
2. Complete the login steps when authentication is required.
3. Open DevTools and run `pendo.validateEnvironment()`.
4. Verify the visitor ID, account ID, and mapped metadata.
5. Navigate between representative routes and verify page tracking.
6. Check the Pendo dashboard for events.

Include framework-specific troubleshooting based on the detected application type. Recommend a commit such as `git commit -m "Add Pendo snippet loader"` for the loader and `git commit -m "Configure Pendo initialization"` for initialization changes.
