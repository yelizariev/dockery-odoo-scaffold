#!/usr/bin/env python
# -*- coding: utf-8 -*-
import click
from _helpers import (
    call_cmd_realtime,
    cyan,
    get_from_image,
    get_hack_dir,
    get_image_tag,
    red,
)


def build_image(image_type, nocache):
    hack_dir = get_hack_dir()
    from_image = get_from_image(image_type)
    image_tag = get_image_tag(image_type)
    if nocache:
        cmd = (
            'docker build --tag "{BASE_IMAGE_TAG}" --no-cache  --build-arg '
            '"FROM_IMAGE={FROM_IMAGE}"   "{DIR}/../."'
        )
    else:
        cmd = (
            'docker build --tag "{BASE_IMAGE_TAG}" --build-arg '
            '"FROM_IMAGE={FROM_IMAGE}"   "{DIR}/../."'
        )
    for line in call_cmd_realtime(
        cmd.format(BASE_IMAGE_TAG=image_tag, FROM_IMAGE=from_image, DIR=hack_dir)
    ):
        click.echo(line)


@click.command()
@click.option("--nocache", is_flag=True, default=False)
def main(nocache):
    """ Build Docker Images.
    """
    # Build *base image
    click.echo(red("\nFirst we build the production image. It contains:\n"))
    click.echo(cyan("\t- Odoo Community Code"))
    click.echo(cyan("\t- Odoo Enterprise Code (if configured)"))
    click.echo(cyan("\t- Vendored modules"))
    click.echo(cyan("\t- Your project modules (`src` folder)"))
    click.echo(cyan("\t- Your further customizations from the Dockerfile\n"))
    build_image("base", nocache=nocache)

    # Build *devops image
    click.echo(
        red("\nNow we build the devops image as sibling to the production image.\n")
    )
    click.echo(cyan("\t- Provides Odoo Server API extensions for DevOps."))
    click.echo(cyan("\t- Remote build context maintained by XOE."))
    click.echo(cyan("\t- Therefore, as devops image evolves, just rebuild."))
    click.echo(cyan("\t- For details, visit: https://git.io/fpMvT\n"))
    build_image("devops", nocache=nocache)

    click.echo(red("\nFirst time? Next, do:\n"))
    click.echo(cyan("\t- apply patches to your local workdir: `make patch`;"))
    click.echo(
        cyan(
            "\t- scaffold your first module in `src`: `docker-compose run scaffold`;\n"
        )
    )


if __name__ == "__main__":
    main()
