# composevalidate

composevalidate checks that all images referenced in a Docker Compose file
have images for a given platform and expected architecture.

Using this as a step in a PR workflow can catch issues where something like
Renovate might try to update you to a new upstream image that is missing an
architecture.

Retrieving the manifests is done using
[regctl](https://github.com/regclient/regclient/) and the docker image for
this tool is based on the regctl docker image, which includes authentication
helpers for AWS and GCP.

## Usage

1.  Populate a Docker Compose yaml file with services that reference images.

    ```yaml
    services:
      service-name-does-not-matter:
        image: "rabbitmq:3.4"
    ```

    The example above references an amd64-only image. It will pass if run with
    the defaults (`--platform linux/amd64`, `--architecture amd64`) but it
    will fail if you specify `--platform linux/arm64 --architecture arm64`.

2.  If any registry authentication configuration is required, you'll need to
    mount it in to the composevalidate docker image.

    The path for a docker config file is `/home/appuser/.docker/config.json`
    and the path for a regctl config is `/home/appuser/.regctl/config.json`.

3.  Run composesync as a container in a CICD workflow.

    ```shell
    docker run -i --rm \
    --volume $HOME/.config/gcloud:/home/appuser/.config/gcloud:ro \
    --volume `pwd`/compose.yaml:/compose.yaml:ro \
    ghcr.io/retailnext/composevalidate \
    --platform linux/arm64 \
    --architecture arm64 \
    /compose.yaml
    ```

## Project Status

We use this internally. It _may_ receive some publicly-visible maintenance,
but it is not a priority for us. 

:warning: We are likely to make breaking changes without warning.

## Contributing

Contributions considered, but be aware that this is mostly just something we
needed. It's public because there's no reason anyone else should have to waste
an afternoon (or more) building something similar, and we think the approach
is good enough that others would benefit from adopting.

This project is licensed under the [Apache License, Version 2.0](LICENSE).

Please include a `Signed-off-by` in all commits, per
[Developer Certificate of Origin version 1.1](DCO).
