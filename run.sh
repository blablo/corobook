#!/bin/bash

rake db:create
rake db:migrate

bundle exec rails s
