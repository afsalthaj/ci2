#   Copyright 2014 Commonwealth Bank of Australia
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

#!/bin/bash

set -e
set -u
set -v

echo "releaseVersion: `grep VERSION ../VERSION.txt | cut -d '=' -f 2`" >> _config.yml

echo "Creating site"
sbt -Dsbt.global.base=$TRAVIS_BUILD_DIR/ci make-site

git config --global user.email "omnia-bamboo"
git config --global user.name "Travis"

echo "Cloning gh-pages"
git clone -b gh-pages https://omnia-bamboo:$GH_PASSWORD@github.com/$TRAVIS_REPO_SLUG.git ./target/gh-pages

cd ./target/gh-pages
git rm -r -f --ignore-unmatch *
cp -r ../site/* .

git add .
git commit -m "Updated site"
echo "Pushing site to gh-pages"
git push --quiet https://omnia-bamboo:$GH_PASSWORD@github.com/$TRAVIS_REPO_SLUG.git gh-pages
cd ..
rm -rf gh-pages
