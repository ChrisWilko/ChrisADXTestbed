# ChrisADXTestbed
### Testing Project for Azure Data Explorer

## Created using:
* C#
* .NET Aspire
* Blazor
* Azure Data Explorer
* Make
* Docker (Azure Data Explorer Kusto emulator)


## Prerequisites:
* Dotnet 8.0
* Docker Desktop
* Make
* Bash enabled Terminal

## How to set up

There are two ways in which you can set up the project, firstly the local server using docker and the image

### Option 1: Docker local image
1. run `make setup-docker` - This will set up the ADX docker image for you
2. run `make docker-start` - Will start the container on port:8080 for you to connect locally
3. run `make dotnet-start` - Will start all the dotnet projects needed to run the frontend.