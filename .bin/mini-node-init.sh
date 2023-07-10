#!/usr/bin/env bash

# Function to display script usage
function show_usage {
        echo -e "\e[35mUsage: ./mini-node-init.sh [OPTIONS]\e[0m"
        echo ""
        echo -e "\e[33mOptions:\e[0m"
        echo -e "\e[33m  \e[1m-n, --name PROJECT_NAME\e[0m\t\e[32mName of the project and its root folder\e[0m"
        echo -e "\e[33m  \e[1m-p, --path FOLDER_PATH\e[0m\t\e[32mPath for creating the project folder\e[0m\e[36m \n\t\t\t\t(default: \${PWD}: $PWD)\e[0m"
        echo -e "\e[33m  \e[1m-h, --help\e[0m\t\t\t\e[32mDisplay this help message\e[0m"
        echo ""
        echo -e "\e[33mExample:\e[0m"
        echo -e "\e[35m\t./mini-node-init.sh\e[0m\e[33m -n \e[0m\e[32mmy-node-app\e[0m\e[33m -p \e[0m\e[32m/home/user/projects\e[0m"
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
      echo "Error: Invalid option: $1"
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

# Initialize a Node.js project inside a Docker container, run npm init -y, npm install express mongoose dotenv cors 
# also run npm install -g npm@9.8.0
docker run -v "${PWD}":/app -w /app node:lts-alpine3.18 npm install -g npm@9.8.0
docker run -v "${PWD}":/app -w /app node:lts-alpine3.18 npm init -y
docker run -v "${PWD}":/app -w /app node:lts-alpine3.18 npm install express mongoose dotenv cors
# Also run npm install -g nodemon
docker run -v "${PWD}":/app -w /app node:lts-alpine3.18 npm install -g nodemon

# Copy project files to the host server
CONTAINER_ID=$(docker ps -lq)

if [[ -z $CONTAINER_ID ]]; then
    echo -e "\e[91mError: No running container found.\e[0m"
    exit 1
fi

docker cp "$CONTAINER_ID:/app/." "$PWD"

# Cleanup - Stop and remove the Docker container
docker stop "$(docker ps -lq)"
docker rm "$(docker ps -lq)"

# go to project directory in host and create .gitignore file with some content
echo "node_modules" >> .gitignore
echo ".env" >> .gitignore

echo -e "\e[92mNode.js project '$PROJECT_NAME' is initialized and copied to '$PWD'.\e[0m"
