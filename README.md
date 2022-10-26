# breedbase_test
This repo contains the docker-compose.yml and SGN config files that can be used to run the breedbase tests

## Setup

There are separate web services for the fixture and mech tests, which allows them both to be run concurrently (in separate docker containers).

The following configuration parameters in the `docker-compose.yml` will need to be set to specify the image to run the tests on and which tests to run.

1. Change the **`image`** in the web services to specify the image to run the tests on.
    - To use the base breedbase image: `breedbase/breedbase:v0.46`
    - To use the T3/breedbase image: `triticeaetoolbox/breedbase_web:20220408` or `triticeaetoolbox/breedbase_web:latest`

2. Change the **`command`** in the web services to specify the specific test file or directory of tests to run
    - This currently only works with one path specified, multiple paths will cause the script to fail
    - To run a specific test file: `t/unit_fixture/CXGN/Dataset.t`
    - To run all fixture tests: `t/unit_fixture/`

## Usage

`docker compose up` will start the database and test instances and will automatically run the specified test(s).  The output from the tests will be written to the local `./logs*` directory.

- test.log - contains the combined STDOUT and STDERR output
- test.out - contains just STDOUT (useful for getting the summary output from each test)
- test.err - contains just STDERR (useful for getting details from a specific test)

## Testing Development Code

By default, the test containers will test the code in the specified docker image.  If you want to test code that is in development (from an sgn repository on the host), you can mount the sgn repo from its location on the host to `/home/production/cxgn/sgn` in both of the containers (breedbase_test_fixture and breedbase_test_mech).

**HOWEVER, the two test containers cannot be run concurrently with the same sgn repo mounted** - *each test container will need to be run separately*.

```
docker compose up breedbase_test_fixture
docker compose up breedbase_test_mech
```