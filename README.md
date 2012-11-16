# <a name="title"></a> chef-puppet [![Build Status](https://secure.travis-ci.org/fnichol/chef-puppet.png?branch=master)](http://travis-ci.org/fnichol/chef-puppet)

## <a name="description"></a> Description

Installs and manages a Puppet Master service. No, really.

Currently only the server is supported (that meets the immediate needs of the
author), but support for Agent/master and Standalone deployment types could
be added in the future. Pull requests [welcome][issues]!

* Github: https://github.com/fnichol/chef-puppet
* Opscode Community Site: http://community.opscode.com/cookbooks/puppet

## <a name="usage"></a> Usage

To set up a Puppet Master service, simply include `recipe[puppet::master]`
in your run\_list, bam! See the [Attributes](#attributes) section for more
details on tuning the server.

## <a name="requirements"></a> Requirements

### <a name="requirements-chef"></a> Chef

Tested on 10.16.2 but newer and older version should work just fine. File an
[issue][issues] if this isn't the case.

### <a name="requirements-platform"></a> Platform

The following platforms have been tested with this cookbook, meaning that the
recipes run on these platforms without error:

* ubuntu (12.04)

If you find this cookbook runs on other platforms/versions or you add support,
please file an [issue][issues]. Thank you!

### <a name="requirements-cookbooks"></a> Cookbooks

This cookbook depends on the following external cookbooks:

* [apt][apt_cb]

## <a name="installation"></a> Installation

Depending on the situation and use case there are several ways to install
this cookbook. All the methods listed below assume a tagged version release
is the target, but omit the tags to get the head of development. A valid
Chef repository structure like the [Opscode repo][chef_repo] is also assumed.

### <a name="installation-platform"></a> From the Opscode Community Platform

To install this cookbook from the Opscode platform, use the *knife* command:

    knife cookbook site install puppet

### <a name="installation-librarian"></a> Using Librarian-Chef

[Librarian-Chef][librarian] is a bundler for your Chef cookbooks.
To install Librarian-Chef:

    cd chef-repo
    gem install librarian
    librarian-chef init

To use the Opscode platform version:

    echo "cookbook 'puppet'" >> Cheffile
    librarian-chef install

Or to reference the Git version:

    repo="fnichol/chef-puppet"
    latest_release=$(curl -s https://api.github.com/repos/$repo/git/refs/tags \
    | ruby -rjson -e '
      j = JSON.parse(STDIN.read);
      puts j.map { |t| t["ref"].split("/").last }.sort.last
    ')
    cat >> Cheffile <<END_OF_CHEFFILE
    cookbook 'puppet',
      :git => 'git://github.com/$repo.git', :ref => '$latest_release'
    END_OF_CHEFFILE
    librarian-chef install

### <a name="installation-berkshelf"></a> Using Berkshelf

[Berkshelf][berkshelf] manages a cookbook or an application's cookbook
dependencies, very similar to the [Bundler][bundler] gem.
To install Berkshelf:

    cd chef-repo
    gem install berkshelf
    berks init

To use the Community Site version:

    echo "cookbook 'puppet'" >> Berksfile
    berks install

Or to reference the Git version:

    repo="fnichol/chef-puppet"
    latest_release=$(curl -s https://api.github.com/repos/$repo/git/refs/tags \
    | ruby -rjson -e '
      j = JSON.parse(STDIN.read);
      puts j.map { |t| t["ref"].split("/").last }.sort.last
    ')
    cat >> Berksfile <<END_OF_BERKSFILE
    cookbook 'puppet',
      :git => 'git://github.com/$repo.git', :branch => '$latest_release'
    END_OF_BERKSFILE

## <a name="recipes"></a> Recipes

### <a name="recipes-default"></a> default

This recipe is a no-op and does nothing.

### <a name="recipes-master"></a> master

Installs and configures a puppetmaster service.

## <a name="attributes"></a> Attributes

### <a name="attributes-master-conf"></a> master_conf

This hash maps directly into the configuration that will end up in the
`puppet.conf` file for a puppetmaster node. The keys under this hash
correspond to sections in a puppet configuration file and the data contained
within are the key/value pairs in that section. For example, an attribute

    node['puppet']['master_conf']['main']['logdir'] = '/var/log/puppet'

will create a **main** section with a **logdir** variable:

    [main]
    logdir = /var/log/puppet


See the attributes file for more example usage.

## <a name="lwrps"></a> Resources and Providers

There are **no** resources and providers in this cookbook.

## <a name="development"></a> Development

* Source hosted at [GitHub][repo]
* Report issues/Questions/Feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make.

## <a name="license"></a> License and Author

Author:: [Fletcher Nichol][fnichol] (<fnichol@nichol.ca>) [![endorse](http://api.coderwall.com/fnichol/endorsecount.png)](http://coderwall.com/fnichol)

Copyright 2012, Fletcher Nichol

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[apt_cb]:       http://community.opscode.com/cookbooks/apt
[berkshelf]:    http://berkshelf.com/
[bundler]:      http://gembundler.com/
[chef_repo]:    https://github.com/opscode/chef-repo
[librarian]:    https://github.com/applicationsonline/librarian#readme

[fnichol]:      https://github.com/fnichol
[repo]:         https://github.com/fnichol/chef-puppet
[issues]:       https://github.com/fnichol/chef-puppet/issues
