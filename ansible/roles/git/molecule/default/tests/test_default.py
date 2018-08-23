import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_hosts_file(host):
    git_cred_config = host.check_output('git config credential.helper')
    assert git_cred_config == 'cache --timeout=604800'
    git_username = host.check_output('git config user.name')
    assert git_username == 'User Name'
    git_email = host.check_output('git config user.email')
    assert git_email == 'email@example.com'
