# macbook-setup

# Purpose

Ansible roles for setting up my Macbook dev environment. It installs the following:

* Various dev tools (including VSCode)
* VSCode plugins
* The [Fish shell](https://fishshell.com), because I like it over Bash

# Disclaimer

I recognize that there's plenty of room for improvement, though I just haven't had time to give this a ton of TLC. Send me a PR if you'd like to submit any tweaks and improvements!

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

git clone git@github.com:d0-labs/macbook-setup.git

cd macbook-setup

ansible-playbook -vv --ask-become-pass mbp_setup.yml
```

# Post steps

1. Install Docker Desktop for Mac from DockerHub [here](https://hub.docker.com/editions/community/docker-ce-desktop-mac).

**AV Personal note:** Way less effort compared to the voodo described [here](https://pilsniak.com/how-to-install-docker-on-mac-os-using-brew/). That said, if you have a better way, send me a PR!!
