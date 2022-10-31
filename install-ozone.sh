#!/usr/bin/env bash

echo $USER

sudo mkdir -p /ozone/data/meta
sudo chown -R rhel9dev:rhel9dev /ozone

cd ~
wget https://dlcdn.apache.org/ozone/1.2.1/ozone-1.2.1.tar.gz

tar zfxv ~/ozone-1.2.1.tar.gz
sudo cp -rf ~/ozone-1.2.1/* /ozone/

gedit ~/.bashrc
source ~/.bashrc

gedit ~/.bash_profile
source ~/.bash_profile

sudo gedit /etc/profile
sudo su
source /etc/profile

cat <<EOF >> ~/.bashrc
export PATH=$PATH:/ozone/bin
export HADOOP_OPTS='-XX:ParallelGCThreads=8 -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=70 -XX:+CMSParallelRemarkEnabled'
EOF

source ~/.bashrc

cat <<EOF >> ~/.bash_profile
export PATH=$PATH:/ozone/bin
export HADOOP_OPTS='-XX:ParallelGCThreads=8 -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=70 -XX:+CMSParallelRemarkEnabled'
EOF

source ~/.bash_profile

sudo cat <<EOF >> /etc/profile
export PATH=$PATH:/ozone/bin
export HADOOP_OPTS='-XX:ParallelGCThreads=8 -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=70 -XX:+CMSParallelRemarkEnabled'
EOF

sudo su
source /etc/profile
exit


ozone version

mv /ozone/etc/hadoop/ozone-site.xml /ozone/etc/hadoop/ozone-site.xml_bkp

ozone genconf /ozone/etc/hadoop


#/ozone/etc/hadoop


mv /ozone/etc/hadoop/ozone-site.xml /ozone/etc/hadoop/ozone-site.xml_bkp
ozone genconf /ozone/etc/hadoop

vim /ozone/etc/hadoop/ozone-site.xml

gedit /ozone/etc/hadoop/ozone-site.xml

...
   </property>
    <property>
        <name>ozone.metadata.dirs</name>
        <value>/ozone/data/meta</value>
...


ozone scm --init
ozone --daemon start scm

ozone om --init
ozone --daemon start om



ozone --daemon start datanode

ozone sh volume ls

ls /ozone/data

### PARTE 2

ozone sh volume create rescue

ozone sh volume ls

ozone sh volume create point

ozone sh volume delete point

ozone sh bucket --help

ozone sh bucket create /rescue/teste/testando

ozone sh key --help


ozone sh key --help

ozone sh bucket create /rescue/teste


ozone sh key --help

ozone sh key put /rescue/teste/README.md /ozone/README.md


tail -300f /ozone/logs/ozone-opc-scm-whiterose.log


ozone sh key put -r=ONE /rescue/teste/README.md /ozone/README.md


ozone sh key cat /rescue/teste/README.md


#

cd /home/rhel9dev/ZIGGIE/SPARK_STREAMING/spark-streaming/ozone/hadoop-ozone/dist/src/main/compose/ozone


mvn clean verify -DskipTests -Dskip.npx -DskipShade -Ddocker.ozone-runner.version=dev

###

cd /ozone/compose/ozone

docker-compose up -d

docker-compose exec datanode bash


ozone sh volume create --quota=1TB --user=homer /myvolume

ozone sh bucket create /myvolume/mybucket


echo 'Ozone is great!' > /tmp/ozone.txt

ozone sh key put /myvolume/mybucket/ozone.txt /tmp/ozone.txt

ozone sh key get /myvolume/mybucket/ozone.txt /tmp/getozone.txt
cat /tmp/getozone.txt

ozone sh key get o3://ozoneManager:9862/myvolume/mybucket/ozone.txt /tmp/getozone.txt


ozone sh key get \
  http://ozoneManager:9874/myvolume/mybucket/ozone.txt \
  /tmp/getozone.txt


# Get a file using REST directly (with wget)
curl -i \
  -H "x-ozone-user: homer" \
  -H "x-ozone-version: v1" \
  -H "Date: Mon, 22 Apr 2019 18:23:30 GMT" \
  -H "Authorization:OZONE" \
  "http://datanode:9880/myvolume/mybucket/ozone.txt"


docker-compose scale ozoneManager=2

docker-compose exec datanode bash
# Create the volume /myvolume on both Ozone Manager
ozone sh volume create o3://ozoneManager1:9862/myvolume
ozone sh volume create o3://ozoneManager2:9862/myvolume
# It worked! Now delete it using http on the first one
ozone sh volume delete http://ozoneManager1:9874/myvolume
# Great! Now delete the bucket on the second one, should work
ozone sh volume delete http://ozoneManager2:9874/myvolume
## Exception org.apache.hadoop.ozone.client.rest.OzoneException: Delete Volume failed, error:VOLUME_NOT_FOUND



# For this we will need at least 3 datanodes
docker-compose scale datanode=3
# Create the S3 bucket name mys3bucket
aws s3api --endpoint-url http://localhost:9878 create-bucket --bucket=mys3bucket
# Place a file under the bucket
aws s3 cp --endpoint-url http://localhost:9878 ozone.txt s3://mys3bucket/ozone.txt
# Get the file
aws s3 cp --endpoint-url http://localhost:9878 s3://mys3bucket/ozone.txt ozone.txt



aws s3api --endpoint-url http://localhost:9878 create-bucket --bucket=mynewbucket
aws s3 cp --endpoint-url http://localhost:9878 ozone.txt s3://mynewbucket/ozone.txt
# And get the file using ozone cli
ozone sh key get /s3myaccesskey/mynewbucket/ozone.txt /tmp/s3ozone.txt


###

<property>
  <name>fs.o3fs.impl</name>
  <value>org.apache.hadoop.fs.ozone.OzoneFileSystem</value>
</property>
<property>
  <name>fs.defaultFS</name>
  <value>o3fs://localhost:9864/volume/bucket</value>
</property>

export HADOOP_CLASSPATH=/opt/ozone/share/hadoop/ozonefs/hadoop-ozone-filesystem.jar:$HADOOP_CLASSPATH

cd compose/ozonefs
docker-compose up -d
sleep 10
docker-compose exec datanode ozone sh volume create /volume
docker-compose exec datanode ozone sh bucket create /volume/bucket
docker-compose exec hadooplast bash
echo "Hello Ozone from HDFS!" > /tmp/hdfsOzone.txt
hdfs dfs put /tmp/hdfsOzone.txt /hdfsOzone.txt
hdfs dfs ls /
exit
docker-compose exec datanode ozone sh keys list /volume/bucket



ozone scmcli list -s 0


##

docker run -p 9878:9878 apache/ozone

aws s3api --endpoint http://localhost:9878/ create-bucket --bucket=wordcount

aws s3 --endpoint http://localhost:9878 cp --storage-class REDUCED_REDUNDANCY ./testfile  s3://tw-pabx-storage-sp-smb/testes/testfile

s3://tw-pabx-storage-sp-smb/testes/

aws s3 --endpoint http://localhost:9874 cp --storage-class REDUCED_REDUNDANCY ./testfile  s3://tw-pabx-storage-sp-smb/testes/testfile























































































