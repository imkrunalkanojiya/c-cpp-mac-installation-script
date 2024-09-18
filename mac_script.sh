#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to display help
show_help() {
  echo "Usage: $0 [--help]"
  echo
  echo "This script installs Homebrew and GCC on macOS if they are not already installed."
  echo "It also creates a script to compile and run C/C++ code."
  echo
  echo "Options:"
  echo "  --help    Show this help message and exit"
}

# Check for --help argument
if [ "$1" == "--help" ]; then
  show_help
  exit 0
fi

# Detect the operating system
OS="$(uname -s)"

# Install Homebrew on macOS if not installed
if [ "$OS" == "Darwin" ]; then
  if ! command_exists brew; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew is already installed."
  fi

  # Install GCC if not installed
  if ! command_exists gcc; then
    echo "GCC not found. Installing GCC..."
    brew install gcc
  else
    echo "GCC is already installed."
  fi

  # Create a script to compile and run C/C++ code
  cat << 'EOF' > compile_and_run.sh
#!/bin/bash

# Check if a file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <source-file>"
  exit 1
fi

# Get the file extension
EXT="${1##*.}"

# Compile and run based on the file extension
if [ "$EXT" == "c" ]; then
  gcc "$1" -o "${1%.c}" && "./${1%.c}"
elif [ "$EXT" == "cpp" ]; then
  g++ "$1" -o "${1%.cpp}" && "./${1%.cpp}"
else
  echo "Unsupported file extension: $EXT"
  exit 1
fi
EOF

  # Make the script executable
  chmod +x mac_script.sh
  echo "Script to compile and run C/C++ code has been created as mac_script.sh"

  # Run the compile_and_run.sh script
  ./mac_script.sh <source-file>
else
  echo "This script is intended to run on macOS."
  exit 1
fi