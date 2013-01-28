import os, getpass

from fabric.api import cd, env, get, run, task, sudo, settings, local
from fabric.contrib import files
from argyle import system

PROJECT_ROOT = os.path.dirname(__file__)
DJANGO_ADMIN = '/usr/local/bin/django-admin.py'
LOCALHOST_USER = 'd' ## Fixed this for you

#@task
def staging():
    env.environment = 'staging'
    env.hosts = []
    env.branch = 'master'
    env.server_name = ''

#@task
def production():
    env.environment = 'production'
    env.hosts = []
    env.branch = 'master'
    env.server_name = ''



@task
def create_git_user():
    """
    Create git user and group
    """
    create_user('git', ['git',])

@task
def create_git_project(project_name):
    """
    Create git project
    """
    if project_name is None:
        print "project name cannot be empty."
        return

    project_path = '/home/git/%s' % project_name
    if files.exists(project_path):
        print('Project exists!')
        return

#    run('mkdir %s' % project_path)
    with settings(warn_only=True):
        result = run(u'git init --bare %s' % project_path)
        if 127 == result.return_code:
            print 'Please install git with:\n' \
                '\tfab -H %s -u root system.install_packages:git' \
                % (env.host)

@task
def create_django_project(project_name):
    local(u'%s startproject ' \
            '--template=https://github.com/donilan' \
            '/django-project-template/zipball/master' \
            ' --extension=py,rst %s' % (DJANGO_ADMIN, project_name))


def create_user(name, groups=None, key_file=None):
    """
    Create system user
    """
    groups = groups or []
    if not system.user_exists(name):
        for group in groups:
            sudo(u'addgroup %s' % group)
        groups = groups and u'-g %s' % u','.join(groups) or ''
        sudo(u'useradd -m %s -s /bin/bash %s' % (groups, name))
        sudo(u'passwd -d %s' % name)
        sudo(u"mkdir -p /home/%s/.ssh" % name)
        
        key_file = os.path.join(os.getenv('HOME'), '.ssh/id_rsa.pub')
        if os.path.exists(key_file):
            system.put(open(key_file), u"/home/%s/.ssh/authorized_keys" \
                           % name, use_sudo=True)
            sudo(u"chown -R %(name)s:%(name)s /home/%(name)s/.ssh" \
                     % {'name': name})


def su(user, command):
    with settings(sudo_prefix="su %s -c " % user, sudo_prompt="Password:"):
        return sudo(command)

#def test():
#    """
#    Change ssh_config
#    """
#    files.sed(u'/etc/ssh/sshd_config', u'Port 2222$', u'Port 22', use_sudo=True)
