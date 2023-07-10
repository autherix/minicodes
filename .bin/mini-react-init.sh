#!/usr/bin/env bash

# Function to display script usage
function show_usage {
        echo -e "\e[35mUsage: ./mini-react-init.sh [OPTIONS]\e[0m"
        echo ""
        echo -e "\e[33mOptions:\e[0m"
        echo -e "\e[33m  -n, --name \e[0m\e[32mPROJECT_NAME\e[0m\tName of the project and its root folder"
        echo -e "\e[33m  -p, --path \e[0m\e[32mFOLDER_PATH\e[0m\tPath for creating the project folder\n\t\t\t\t(default: \${PWD}: \e[36m$PWD\e[0m)"
        echo -e "\e[33m  -h, --help\e[0m\t\t\tDisplay this help message"
        echo ""
        echo -e "\e[33mExample:\e[0m"
        echo -e "\e[35m\t./mini-react-init.sh\e[0m\e[33m -n \e[0m\e[32mmy-react-app\e[0m\e[33m -p \e[0m\e[32m/home/user/projects\e[0m"
}

# Default values
FOLDER_PATH="."
PROJECT_NAME=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -n|--name)
            PROJECT_NAME="$2"
            shift
            shift
            ;;
        -p|--path)
            FOLDER_PATH="$2"
            shift
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo -e "\e[93mError: Invalid option: $1\e[0m"
            echo ""
            show_usage
            exit 1
            ;;
    esac
done

# Check if PROJECT_NAME is provided
if [[ -z $PROJECT_NAME ]]; then
    echo -e "\e[91mError: PROJECT_NAME is missing.\e[0m"
    echo ""
    show_usage
    exit 1
fi

# Create the project folder
PROJECT_FOLDER="$FOLDER_PATH/$PROJECT_NAME"
mkdir -p "$PROJECT_FOLDER"
cd "$PROJECT_FOLDER"

# Initialize a React project inside a Docker container
docker run --rm -v "${PWD}":/app -w /app node:lts-alpine3.18 npx create-react-app .

# Copy project files to the host server
docker cp "$(docker ps -lq)":"/app/." "$PWD"

# Cleanup - Stop and remove the Docker container
docker stop "$(docker ps -lq)"
docker rm "$(docker ps -lq)"

echo -e "\e[92mReact project '$PROJECT_NAME' is initialized and copied to '$PWD'.\e[0m"
