{
  description = "Elm application with Tailwind CSS using Nix flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Define the project directories and output paths
        srcDir = "./src";
        outputDir = "./public";
        outputJs = "${outputDir}/main.js";
        outputCss = "${outputDir}/output.css";
        fontsDir = "${outputDir}/fonts";

        # Helper function to build the Elm application
        buildElmApp = pkgs.writeShellScriptBin "build-elm" ''
          set -e
          mkdir -p ${outputDir}
          ${pkgs.elmPackages.elm}/bin/elm make ${srcDir}/Main.elm --output=${outputJs} --optimize
          echo "Elm application built successfully!"
        '';

        # Helper function to install IBM Plex fonts
        installFonts = pkgs.writeShellScriptBin "install-fonts" ''
          set -e
          mkdir -p ${fontsDir}
          cp -r ${pkgs.ibm-plex}/share/fonts/opentype/* ${fontsDir}/
          echo "IBM Plex fonts installed successfully!"
        '';

        # Helper function to setup Tailwind CSS
        setupTailwind = pkgs.writeShellScriptBin "setup-tailwind" ''
          set -e
          if [ ! -f "tailwind.config.js" ]; then
            echo "Creating tailwind.config.js..."
            cat > tailwind.config.js << EOF
          module.exports = {
            content: [
              './public/index.html',
              './src/**/*.elm'
            ],
            theme: {
              extend: {},
            },
            plugins: [],
          }
          EOF
          fi

          mkdir -p src/css
          if [ ! -f "src/css/input.css" ]; then
            echo "Creating src/css/input.css..."
            cat > src/css/input.css << EOF
          @tailwind base;
          @tailwind components;
          @tailwind utilities;
          EOF
          fi

          echo "Tailwind setup complete!"
        '';

        # Helper function to build Tailwind CSS
        buildTailwind = pkgs.writeShellScriptBin "build-tailwind" ''
          set -e
          mkdir -p ${outputDir}
          ${pkgs.nodePackages.tailwindcss}/bin/tailwindcss -i ./src/css/input.css -o ${outputCss} --minify
          echo "Tailwind CSS built successfully!"
        '';

        # Helper function to watch Tailwind CSS for changes
        watchTailwind = pkgs.writeShellScriptBin "watch-tailwind" ''
          set -e
          mkdir -p ${outputDir}
          ${pkgs.nodePackages.tailwindcss}/bin/tailwindcss -i ./src/css/input.css -o ${outputCss} --watch
        '';

        # Helper function to build the entire application
        buildAll = pkgs.writeShellScriptBin "build-all" ''
          set -e
          ${buildElmApp}/bin/build-elm
          ${buildTailwind}/bin/build-tailwind
          ${installFonts}/bin/install-fonts
          echo "Build completed successfully! Open ${outputDir}/index.html in your browser."
        '';

        # Helper function to run a development server
        devServer = pkgs.writeShellScriptBin "dev-server" ''
          set -e
          cd ${outputDir}
          ${pkgs.python3}/bin/python -m http.server 8000
        '';

        # NEW: Helper function to run elm-live for live reloading
        elmLive = pkgs.writeShellScriptBin "elm-live" ''
          set -e
          mkdir -p ${outputDir}
          echo "Starting elm-live with hot reloading..."
          ${pkgs.elmPackages.elm-live}/bin/elm-live ${srcDir}/Main.elm --port=8000 --dir=${outputDir} --start-page=index.html -- --output=${outputJs}
        '';

        # NEW: Helper function to run both Elm live reload and Tailwind watch concurrently
        devMode = pkgs.writeShellScriptBin "dev-mode" ''
          set -e
          echo "Starting development environment with live reloading..."
          echo "Elm will reload at http://localhost:8000"
          echo "Press Ctrl+C to stop all processes"

          # Ensure the output directory exists
          mkdir -p ${outputDir}

          # Install fonts if needed
          if [ ! -d "${fontsDir}" ]; then
            ${installFonts}/bin/install-fonts
          fi

          # Make sure index.html exists
          if [ ! -f "${outputDir}/index.html" ]; then
            echo "Ensuring index.html exists..."
            cp public/index.html ${outputDir}/index.html 2>/dev/null || cat > ${outputDir}/index.html << EOF
          <!DOCTYPE html>
          <html>
            <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>Elm with Tailwind CSS</title>
              <link href="output.css" rel="stylesheet">
              <script src="main.js"></script>
            </head>
            <body class="bg-background min-h-screen">
              <div id="elm-app"></div>
              <script>
                var app = Elm.Main.init({
                  node: document.getElementById('elm-app')
                });
              </script>
            </body>
          </html>
          EOF
          fi

          # Run Tailwind in the background
          ${pkgs.nodePackages.tailwindcss}/bin/tailwindcss -i ./src/css/input.css -o ${outputCss} --watch &
          TAILWIND_PID=$!

          # Cleanup function to kill background processes when the script terminates
          function cleanup {
            echo "Stopping Tailwind watcher..."
            kill $TAILWIND_PID 2>/dev/null || true
            echo "Development environment stopped"
          }

          # Register the cleanup function to run on exit
          trap cleanup EXIT

          # Run elm-live
          ${pkgs.elmPackages.elm-live}/bin/elm-live ${srcDir}/Main.elm --port=8000 --dir=${outputDir} --start-page=index.html -- --output=${outputJs}
        '';

      in {
        # Define build packages
        packages = {
          default = pkgs.stdenv.mkDerivation {
            name = "elm-tailwind-app";
            src = self;
            buildInputs = [
              pkgs.elmPackages.elm
              pkgs.nodePackages.tailwindcss
              pkgs.ibm-plex
            ];
            buildPhase = ''
              mkdir -p ${outputDir}

              # Build Elm
              ${pkgs.elmPackages.elm}/bin/elm make ${srcDir}/Main.elm --output=${outputJs} --optimize

              # Setup Tailwind config if not present
              if [ ! -f "tailwind.config.js" ]; then
                cat > tailwind.config.js << EOF
              module.exports = {
                content: [
                  './public/index.html',
                  './src/**/*.elm'
                ],
                theme: {
                  extend: {},
                },
                plugins: [],
              }
              EOF
              fi

              # Create Tailwind input file
              mkdir -p src/css
              cat > src/css/input.css << EOF
              @tailwind base;
              @tailwind components;
              @tailwind utilities;
              EOF

              # Build Tailwind
              ${pkgs.nodePackages.tailwindcss}/bin/tailwindcss -i ./src/css/input.css -o ${outputCss} --minify

              # Install IBM Plex fonts
              mkdir -p ${fontsDir}
              cp -r ${pkgs.ibm-plex}/share/fonts/opentype/* ${fontsDir}/
            '';
            installPhase = ''
              mkdir -p $out/public
              cp -r ${outputDir}/* $out/public/ || true

              # If index.html doesn't exist in outputDir, create it in $out/public
              if [ ! -f "${outputDir}/index.html" ]; then
                cat > $out/public/index.html << EOF
              <!DOCTYPE html>
              <html>
                <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>Elm with Tailwind CSS</title>
                  <link href="output.css" rel="stylesheet">
                  <script src="main.js"></script>
                </head>
                <body>
                  <div id="elm-app"></div>
                  <script>
                    var app = Elm.Main.init({
                      node: document.getElementById('elm-app')
                    });
                  </script>
                </body>
              </html>
              EOF
              else
                cp ${outputDir}/index.html $out/public/
              fi
            '';
          };
        };

        # Development shell with helpers
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            elmPackages.elm
            elmPackages.elm-format
            elmPackages.elm-test
            elmPackages.elm-review
            elmPackages.elm-live  # NEW: Added elm-live package
            nodePackages.tailwindcss
            python3  # For the simple HTTP server
            nodejs
            ibm-plex
            buildElmApp
            buildTailwind
            watchTailwind
            setupTailwind
            installFonts
            buildAll
            devServer
            elmLive    # NEW: Added elm-live command
            devMode    # NEW: Added combined dev mode command
          ];

          shellHook = ''
            echo "Elm with Tailwind CSS development environment ready!"
            echo ""
            echo "Available commands:"
            echo "  - setup-tailwind : Set up Tailwind CSS configuration files"
            echo "  - build-elm      : Build the Elm application"
            echo "  - build-tailwind : Build Tailwind CSS"
            echo "  - install-fonts  : Install IBM Plex fonts"
            echo "  - watch-tailwind : Watch for CSS changes and rebuild"
            echo "  - build-all      : Build both Elm and Tailwind and install fonts"
            echo "  - dev-server     : Start a simple development server on port 8000"
            echo "  - elm-live       : Start elm-live with hot reloading on port 8000"
            echo "  - dev-mode       : Start both elm-live and Tailwind watcher simultaneously"
            echo "  - elm reactor    : Start Elm's built-in development server"
            echo ""
            echo "First time setup? Run: setup-tailwind && build-all"
            echo "For development with live reloading, run: dev-mode"
          '';
        };

        # App shortcuts for running the commands directly
        apps = {
          default = {
            type = "app";
            program = "${buildAll}/bin/build-all";
          };
          build = {
            type = "app";
            program = "${buildAll}/bin/build-all";
          };
          setup = {
            type = "app";
            program = "${setupTailwind}/bin/setup-tailwind";
          };
          serve = {
            type = "app";
            program = "${devServer}/bin/dev-server";
          };
          watch = {
            type = "app";
            program = "${watchTailwind}/bin/watch-tailwind";
          };
          fonts = {
            type = "app";
            program = "${installFonts}/bin/install-fonts";
          };
          live = {  # NEW: Added elm-live as an app
            type = "app";
            program = "${elmLive}/bin/elm-live";
          };
          dev = {   # NEW: Added combined dev mode as an app
            type = "app";
            program = "${devMode}/bin/dev-mode";
          };
        };
      }
    );
}
