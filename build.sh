#!/bin/bash
cd $(basename $WORKSPACE)
mvn clean package
