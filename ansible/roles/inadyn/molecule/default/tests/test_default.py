import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_inadyn_configuration(host):
    config = host.file('/etc/inadyn.conf')
    assert config.contains('^system system@example.com')
    assert config.contains('^username username@example.com')
    assert config.contains('^password P@ssw0rd')
    assert config.contains('^alias alias.example.com')


def test_inadyn_service_configuration(host):
    config = host.file('/etc/default/inadyn')
    assert config.contains('^RUN_DAEMON="yes"')


def test_inadyn_service(host):
    inadyn = host.service('inadyn')
    assert inadyn.is_enabled
