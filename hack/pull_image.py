#!/usr/bin/env python
# -*- coding: utf-8 -*-
import click
from _helpers import call_cmd_realtime, get_from_image


def docker_pull(image_type):
    from_image = get_from_image(image_type)
    cmd = 'docker pull "{FROM_IMAGE}"'
    for line in call_cmd_realtime(cmd.format(FROM_IMAGE=from_image)):
        click.echo(line)


@click.command()
def main():
    """ Pull `from images`.
    """
    docker_pull("base")
    docker_pull("devops")


if __name__ == "__main__":
    main()
