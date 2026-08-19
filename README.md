# Flutter Web App

A small Flutter web page deployed to Cloudflare Pages through GitHub Actions.

## Local development

```bash
flutter pub get
flutter run -d chrome
```

Build the production site with:

```bash
flutter build web --release
```

The deployable files are written to `build/web`.

## GitHub Actions deployment

The workflow in `.github/workflows/deploy.yml` runs on every push to `main` and can also be started manually. It runs the tests, builds the release site, and deploys it with Wrangler.

Add these repository secrets under **Settings > Secrets and variables > Actions**:

- `CLOUDFLARE_API_TOKEN`: a Cloudflare API token with permission to deploy Pages
- `CLOUDFLARE_ACCOUNT_ID`: the Cloudflare account ID that owns the Pages project

Create the Pages project once before the first workflow run, using the project name `flutter-web-app`.
