#!/bin/bash

echo "===== Updating System ====="
sudo apt update -y
sudo apt upgrade -y

echo "===== Installing Java 11 ====="
sudo apt install -y openjdk-11-jdk

echo "===== Installing Maven ====="
sudo apt install -y maven

echo "===== Installing Git ====="
sudo apt install -y git

echo "===== Downloading Tomcat ====="
cd /home/ubuntu
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.112/bin/apache-tomcat-9.0.112.tar.gz

echo "===== Extracting Tomcat ====="
gunzip apache-tomcat-9.0.112.tar.gz
tar -xvf apache-tomcat-9.0.112.tar
rm -f apache-tomcat-9.0.112.tar

echo "===== Setting Tomcat PATH in ~/.profile ====="
echo "" >> ~/.profile
echo "# Tomcat PATH" >> ~/.profile
echo "export PATH=\$PATH:/home/ubuntu/apache-tomcat-9.0.112/bin" >> ~/.profile

echo "===== Reloading Profile ====="
source ~/.profile

echo "===== Starting Tomcat ====="
/home/ubuntu/apache-tomcat-9.0.112/bin/startup.sh

echo "===== Tomcat Installation Completed Successfully ====="
echo "Tomcat running at: http://<EC2-PUBLIC-IP>:8080"
