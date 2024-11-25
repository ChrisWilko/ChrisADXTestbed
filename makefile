SHELL := powershell.exe

# Name of the Docker image
DOCKER_IMAGE := mcr.microsoft.com/azuredataexplorer/kustainer-linux:latest

setup-docker:
	powershell.exe -ExecutionPolicy Bypass -File ./scripts/setup-docker.ps1

run-docker:
	powershell.exe -ExecutionPolicy Bypass -File ./scripts/run-docker.ps1

ingest-data:
	powershell.exe ./scripts/upload_csv_to_adx.ps1