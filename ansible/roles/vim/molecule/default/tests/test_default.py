import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_hosts_file(host):
    editor = host.check_output('readlink -f /usr/bin/editor')
    assert editor == '/usr/bin/vim.nox'

    home = host.user().home
    assert host.file(home + '/.vim').exists
    assert host.file(home + '/.vim/vimrc').exists
    assert host.file(home + '/.vim/undo').exists
    assert host.file(home + '/.editorconfig').exists
    assert host.file('etc/skel/.vim').exists
    assert host.file('etc/skel/.vim/vimrc').exists
    assert host.file('etc/skel/.vim/undo').exists
    assert host.file('etc/skel/.editorconfig').exists
