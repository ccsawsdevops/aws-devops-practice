#!/bin/bash
# Install Apache if not already installed
yum install -y httpd
# Remove old deployment if exists
rm -rf /var/www/html/*
