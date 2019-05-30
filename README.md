# macbook-setup

# Purpose

Ansible roles for setting up Macbook dev environment

# Pre-requisites

The following items must be completed before running this running `mbp_setup.yml`:

1. Install Xcode from the Apple App Store

2. Install Homebrew

```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

3. Install Ansible

```bash
brew install ansible
ansible --version
```

# Running the playbook

To run the playbook:

```bash
cd <workdir>

git clone git@github.com:devzeroplatform/macbook-setup.git

cd macbook-setup

ansible-playbook -vv --ask-become-pass mbp_setup.yml
```

# Post steps

1. Install Docker Desktop for Mac from DockerHub [here](https://hub.docker.com/editions/community/docker-ce-desktop-mac).

**AV Personal note:** Way less effort compared to the voodo described [here](https://pilsniak.com/how-to-install-docker-on-mac-os-using-brew/).