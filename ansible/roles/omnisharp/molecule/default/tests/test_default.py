import os
from distutils.version import LooseVersion

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_hosts_file(host):
    home = host.user().home
    path = home + '/omnisharp/omnisharp/OmniSharp.exe'

    assert host.file(path).exists

    command = "monodis --assembly " + path + " | awk '/Version/{print $2}'"
    version = host.check_output(command)
    assert LooseVersion(version) >= LooseVersion('1.32')
