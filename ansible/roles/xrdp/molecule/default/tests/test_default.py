import os
import re

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_hosts_file(host):
    assert host.package('xrdp').is_installed

    command = 'update-alternatives --query x-session-manager | grep Value:'
    session_manager = host.check_output(command)
    assert re.match(r'Value: .*startlxde', session_manager)
