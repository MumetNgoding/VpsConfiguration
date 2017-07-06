#!/bin/bash

read -p "The SSH user name will be deleted : " Name

userdel -r $Name
