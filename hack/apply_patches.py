#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os

import click
from _helpers import call_cmd, get_from_image, get_hack_dir, yellow


@click.command()
def main():
    """ Apply patches in Odoo folder.
    """
    hack_dir = get_hack_dir()
    odoo_version = os.environ.get("ODOO_VERSION")
    from_image = get_from_image("base")

    patches = call_cmd('docker run --entrypoint "" {} cat patches'.format(from_image))
    patches = patches.replace("#!/bin/bash", "#!/usr/bin/env bash")
    os.system(patches)

    prev_pwd = os.getcwd()

    odoo_folder = "ee" if os.environ.get("IS_ENTERPRISE") else "cc"
    odoo_workdir = os.path.join("vendor/odoo/", odoo_folder)

    apply_dir = os.path.abspath(os.path.join(hack_dir, "..", odoo_workdir))
    os.chdir(apply_dir)

    click.echo(
        call_cmd(
            "git stash push --keep-index --include-untracked "
            '--message "Patches for {odoo_version}" &> /dev/null'.format(
                odoo_version=odoo_version
            ),
            echo_cmd=True,
            exit_on_error=False,
        )
    )
    call_cmd(
        "git stash apply stash@{0} &> /dev/null", echo_cmd=True, exit_on_error=False
    )
    click.echo(
        yellow(
            "Patches are in your submodule workdir {apply_dir} "
            "and stashed there as: 'Patches for {odoo_version}'".format(
                apply_dir=apply_dir, odoo_version=odoo_version
            )
        )
    )
    os.chdir(prev_pwd)


if __name__ == "__main__":
    main()
