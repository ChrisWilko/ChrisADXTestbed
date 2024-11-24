.PHONY: setup-docker

# Name of the Docker image
DOCKER_IMAGE := mcr.microsoft.com/azuredataexplorer/kustainer-linux:latest

setup-docker:
	@echo "Checking if Docker is running..."
	@docker info > /dev/null 2>&1 || (echo "Docker is not running. Please start Docker." && exit 1)
	@echo "Docker is running..."
	@echo "Checking if Docker image \`$(DOCKER_IMAGE)\` is downloaded..."
	@if [ -z "$$(docker images -q $(DOCKER_IMAGE))" ]; then \
		echo "Docker image \`$(DOCKER_IMAGE)\` not found. Downloading..."; \
		docker pull $(DOCKER_IMAGE); \
	fi
	@echo "Docker is downloaded and setup"
	
run-docker:
	@echo "Checking if Docker container 'my_container' is running..."
	@if [ "$(shell docker ps -q -f name=my_container)" ]; then
		echo "Docker container 'my_container' is already running. Skipping start...";
	else
		if docker ps -a --format "{{.Names}}" | grep -Eq "^my_container$$"; then
			echo "A container named 'my_container' already exists. Stopping and removing it...";
			docker stop my_container > /dev/null;
			docker rm my_container > /dev/null;
		fi;
		echo "Running Docker container from image \`$(DOCKER_IMAGE)\`...";
		docker run -d -p 8080:8080 --name my_container -e ACCEPT_EULA=Y $(DOCKER_IMAGE) > /dev/null || (echo "Failed to start Docker container" && exit 1);
		echo "Docker container started successfully.";
		sleep 5;
	fi
	@set -e;
	RET=1;
	COUNTER=0;
	MAX_TRIES=10;
	while [ $$RET -ne 0 ] && [ $$COUNTER -lt $$MAX_TRIES ]; do
		COUNTER=$$((COUNTER+1));
		echo "Attempt $$COUNTER/$${MAX_TRIES}: Checking if the container is up...";
		curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" -d '{"csl":".show cluster"}' http://localhost:8080/v1/rest/mgmt | grep -q "200";
		RET=$$?;
		if [ $$RET -ne 0 ]; then
			echo "Container is not up yet. Retrying in 5 seconds...";
			sleep 5;
		fi;
	done;
	if [ $$RET -ne 0 ]; then
		echo "Failed to connect to the container after $$COUNTER tries.";
		exit 1;
	fi
	@echo "${GREEN}Container is up and running!${NC}"
	@curl -X POST -H "Content-Type: application/json" -d '{"csl":".show cluster"}' http://localhost:8080/v1/rest/mgmt

ingest-data:
	scripts/ingest-data.sh data/StormEvents.csv