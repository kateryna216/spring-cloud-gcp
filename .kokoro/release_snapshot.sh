#!/bin/bash
# Copyright 2019 Google LLC
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA

set -eov pipefail

dir=$(dirname "$0")

source $dir/common.sh

pushd $dir/../

MAVEN_SETTINGS_FILE=$(realpath .)/settings.xml

setup_environment_secrets
create_settings_xml_file $MAVEN_SETTINGS_FILE

./mvnw clean deploy \
  --settings ${MAVEN_SETTINGS_FILE} \
  -DskipTests=true \
  -Dgpg.executable=gpg \
  -Dgpg.passphrase=${GPG_PASSPHRASE} \
  -Dgpg.homedir=${GPG_HOMEDIR} \
  -DautoReleaseAfterClose=true
  --activate-profiles release
  --batch-mode

popd
