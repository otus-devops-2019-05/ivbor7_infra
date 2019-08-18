import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')

# check if MongoDB is enabled,running and listening on 27017 port
def test_mongo_running_and_enabled(host):
    mongo = host.service("mongod")
    assert mongo.is_running
    assert mongo.is_enabled
    mongo_port = host.socket("tcp://0.0.0.0:27017")
    assert mongo_port.is_listening

# check if configuration file contains the required line
def test_config_file(host):
    config_file = host.file('/etc/mongod.conf')
    assert config_file.contains('bindIp: 0.0.0.0')
    assert config_file.is_file



#########################################################################
#def test_hosts_file(host):
#    f = host.file('/etc/hosts')
#
#    assert f.exists
#    assert f.user == 'root'
#    assert f.group == 'root'
