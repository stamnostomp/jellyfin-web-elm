# Jellyfin Web Client - Elm Edition

[![Deploy with Nix Flake](https://github.com/stamnostomp/jellyfin-web-elm/actions/workflows/flake-deploy.yml/badge.svg)](https://github.com/stamnostomp/jellyfin-web-elm/actions/workflows/flake-deploy.yml)

A modern, responsive web client for Jellyfin media server built with Elm and styled using Tailwind CSS with the elegant Everbush theme.

**[✨ Live Demo ✨](https://stamnostomp.github.io/jellyfin-web-elm/)**

![Jellyfin Web Elm Screenshot](https://i.imgur.com/64TCq42.png)

## Features

- 🎬 Browse and manage your Jellyfin media library
- 📱 Responsive design works on desktop and mobile
- 🎨 Elegant dark theme based on Everbush Vim color scheme
- ⚡ Fast and reliable thanks to Elm's architecture
- 🔄 Smooth animations and transitions
- 🔍 Search functionality to quickly find content
- 🎛️ Filtering by genre and media type
- ⚙️ Server configuration settings

## Technology Stack

- [Elm](https://elm-lang.org/) - A delightful language for reliable web applications
- [Tailwind CSS](https://tailwindcss.com/) - A utility-first CSS framework
- [Nix](https://nixos.org/) - Reproducible builds and development environment
- [IBM Plex](https://www.ibm.com/plex/) - Beautiful, modern typeface

## Getting Started

### Prerequisites

- [Nix](https://nixos.org/download.html) (recommended)
- Or: [Elm](https://guide.elm-lang.org/install/elm.html) and [Node.js](https://nodejs.org/) (for Tailwind CSS)

### Quick Start with Nix

```bash
# Clone the repository
git clone https://github.com/stamnostomp/jellyfin-web-elm.git
cd jellyfin-web-elm

# Enter the Nix development shell
nix develop

# Build the application
build-all

# Start a development server
dev-server
```

### Manual Setup

```bash
# Clone the repository
git clone https://github.com/stamnostomp/jellyfin-web-elm.git
cd jellyfin-web-elm

# Install dependencies
npm install -g elm
npm install -D tailwindcss

# Build Elm
elm make src/Main.elm --output=public/main.js --optimize

# Build Tailwind CSS
npx tailwindcss -i ./src/css/input.css -o ./public/output.css --minify

# Serve the application
cd public
python -m http.server 8000
```

## Development

### Nix Development Commands

When using the Nix development environment, you have access to these helpful commands:

- `setup-tailwind` - Set up Tailwind CSS configuration files
- `build-elm` - Build the Elm application
- `build-tailwind` - Build Tailwind CSS
- `watch-tailwind` - Watch for CSS changes and rebuild
- `install-fonts` - Install IBM Plex fonts
- `build-all` - Build both Elm and Tailwind and install fonts
- `dev-server` - Start a development server on port 8000

### Project Structure

```
jellyfin-web-elm/
├── src/                  # Source code
│   ├── Main.elm          # Application entry point
│   ├── Theme.elm         # UI component styling
│   ├── JellyfinAPI.elm   # API interface
│   ├── JellyfinUI.elm    # Main UI components
│   ├── MediaDetail.elm   # Media detail view
│   └── ServerSettings.elm # Server configuration
├── public/               # Compiled output
├── flake.nix             # Nix flake configuration
└── tailwind.config.js    # Tailwind configuration
```

## Deployment

The application is automatically deployed to GitHub Pages using GitHub Actions. Any push to the main branch triggers a new build and deployment.

You can also manually trigger a deployment by running the "Deploy Jellyfin Web Elm" workflow from the Actions tab in GitHub.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
