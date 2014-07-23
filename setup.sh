#  Copyright (c) 2014 "Kaazing Corporation," (www.kaazing.com)
#
#  This file is part of Robot.
#
#  Robot is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as
#  published by the Free Software Foundation, either version 3 of the
#  License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program. If not, see <http://www.gnu.org/licenses/>.

#!/bin/bash
echo Starting Setup...

yum -y install glibc
yum -y install gcc
yum -y install gcc-c++
yum -y install cmake
yum -y install unzip

# Install Oracle jdk-7u60 
cd /home/vagrant
wget -O jdk-7u60-linux-x64.rpm --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u60-b19/jdk-7u60-linux-x64.rpm
rpm -Uvh jdk-7u60-linux-x64.rpm
rm jdk-7u60-linux-x64.rpm

# Install GTest 1.7.0 shared library to /usr/local/lib
wget https://googletest.googlecode.com/files/gtest-1.7.0.zip
unzip gtest-1.7.0.zip
rm gtest-1.7.0.zip
mkdir ./gtest-1.7.0/lib
cd ./gtest-1.7.0/lib
cmake ..
make 
mv libgtest_main.a /usr/local/lib
mv libgtest.a /usr/local/lib
cp -r ../include/gtest/ /usr/local/include/
cd ../..
rm -rf ./gtest-1.7.0

# Install c-robot-control shared library to /usr/local/lib (makefile default)
cd /vagrant/
make clean
make install

# Add library path /usr/local/lib and update cache
sed -i '1i /usr/local/lib' /etc/ld.so.conf
/sbin/ldconfig

# Remove windows line endings (if present) from scripts needed to run
tr -d '\15\32' < /vagrant/test/run_tests.sh > /vagrant/test/tmp.sh
mv /vagrant/test/tmp.sh /vagrant/test/run_tests.sh
tr -d '\15\32' < /vagrant/wrap_run_tests.sh > /vagrant/tmp.sh
mv /vagrant/tmp.sh /vagrant/wrap_run_tests.sh

echo Setup Complete
