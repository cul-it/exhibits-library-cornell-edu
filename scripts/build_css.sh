#!/usr/bin/env bash

# This script builds the CSS for the application and custom spotlight themes.
# Defined in package.json scripts, called with yarn build:css.

# Parse YAML files for list of custom spotlight themes
# https://stackoverflow.com/a/21189044
function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}
eval $(parse_yaml ./config/spotlight_themes.yml "theme_")
themes="${theme_defaults} ${theme_customs}"
themes_arr=(${themes})

# Compile CSS
sass ./app/assets/stylesheets/application.bootstrap.scss:./app/assets/builds/application.css --no-source-map --load-path=node_modules

for i in "${themes_arr[@]}"
do
   sass ./app/assets/stylesheets/application_$i.scss:./app/assets/builds/application_$i.css --no-source-map --load-path=node_modules
done

# Prefix CSS
postcss ./app/assets/builds/application.css --use=autoprefixer --output=./app/assets/builds/application.css

for i in "${themes_arr[@]}"
do
   postcss ./app/assets/builds/application_$i.css --use=autoprefixer --output=./app/assets/builds/application_$i.css
done
