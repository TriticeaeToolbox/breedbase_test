# breedbase_test
This repo contains the docker-compose.yml and SGN config files that can be used to run the breedbase tests

## Setup

Change the image in the `docker-compose.yml` file in the `test_breedbase` service to specify the image to run the tests on.

## Usage

`docker-compose up` will start the database and test instances and will automatically run the fixture and mech tests.  The output from the tests will be written to the local `./logs` directory (in separate stdout and stderr files for each group of tests).
