#!/bin/bash

apt-update
apt-get install -y curl

     --url 'http://example.com'\
     --output './path/to/file'