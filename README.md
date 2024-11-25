# ChrisADXTestbed
### Testing Project for Azure Data Explorer

## Created using:
* C#
* .NET Aspire
* Blazor
* Azure Data Explorer
* Make
* Docker (Azure Data Explorer Kusto emulator)
* Example Dataset taken from [adx-sample-dataset-stormevents](https://github.com/CloudBreadPaPa/adx-sample-dataset-stormevents/tree/main/dataset)


## Prerequisites:
* Dotnet 8.0
* Docker Desktop
* Make
* Azure CLI

## How to set up

There are two ways in which you can set up the project.

### Before
Ensure you are logged into azure through the CLI and have a token authenticated on that terminal session.  
Ensure you have the [Kusto CLI](https://learn.microsoft.com/en-us/azure/data-explorer/azure-powershell#prerequisites) installed.

### Setup Option 1: Docker local image (WIP)
1. run `make setup-docker` - This will set up the ADX docker image for you. (can be slow to download)
2. run `make docker-start` - Will start the container on port:8080 for you to connect locally.

### Setup Option 2: Azure Free Cluster (WIP)

1. Follow this [link](https://learn.microsoft.com/en-us/azure/data-explorer/start-for-free-web-ui) and set up a free cluster for your given URLs and fill in the appSettings.json accordingly with your URLs.

### Setup Both continued

1. run `make ingest-data` - Will ingest the data directly in to the free adx db for you.
2. run `make dotnet-start` - Will start all the dotnet projects needed to run the project, and you'll have a frontend & backend ready to connect to ADX.
