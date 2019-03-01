#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import click
import subprocess


def call_cmd(cmd, echo_cmd=True, exit_on_error=True):
    if echo_cmd:
        click.echo(click.style(cmd, fg="green"))
    try:
        result = subprocess.check_output(
            cmd, stderr=subprocess.STDOUT, shell=True, universal_newlines=True
        )
    except subprocess.CalledProcessError as exc:
        click.echo(
            click.style("FAIL {} {}".format(exc.returncode, exc.output), fg="red")
        )
        if exit_on_error:
            exit(exc.returncode)
        result = "ERROR"
    return result


@click.command()
def main():
    """ Apply patches in Odoo folder.
    """
    DIR = os.path.dirname(os.path.abspath(__file__))
    FROM = os.environ.get("FROM")
    ODOO_VERSION = os.environ.get("ODOO_VERSION")
    BASE_IMAGE = "{FROM}:{ODOO_VERSION}-base".format(
        FROM=FROM, ODOO_VERSION=ODOO_VERSION
    )

    BASE_IMAGE = "{FROM}:{ODOO_VERSION}-base".format(
        FROM=FROM, ODOO_VERSION=ODOO_VERSION
    )
    PATCHES = call_cmd('docker run --entrypoint "" {} cat patches'.format(BASE_IMAGE))
    PATCHES = PATCHES.replace("#!/bin/bash", "#!/usr/bin/env bash")
    os.system(PATCHES)

    PREV_PWD = os.getcwd()

    ODOO_FOLDER = "ee" if os.environ.get("IS_ENTERPRISE") else "cc"
    ODOO_WORKDIR = os.path.join("vendor/odoo/", ODOO_FOLDER)

    APPLY_DIR = os.path.abspath(os.path.join(DIR, "..", ODOO_WORKDIR))
    os.chdir(APPLY_DIR)

    click.echo(
        call_cmd(
            "git stash push --keep-index --include-untracked "
            '--message "Patches for {ODOO_VERSION}" &> /dev/null'.format(
                ODOO_VERSION=ODOO_VERSION
            ),
            echo_cmd=True,
            exit_on_error=False,
        )
    )
    call_cmd(
        "git stash apply stash@{0} &> /dev/null", echo_cmd=True, exit_on_error=False
    )
    click.echo(
        click.style(
            "Patches are in your submodule workdir {APPLY_DIR} "
            "and stashed there as: 'Patches for {ODOO_VERSION}'".format(
                APPLY_DIR=APPLY_DIR, ODOO_VERSION=ODOO_VERSION
            ),
            fg="yellow",
        )
    )
    os.chdir(PREV_PWD)


if __name__ == "__main__":
    main()
