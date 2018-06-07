#!/bin/sh -e

if [ "$target" == "2" ];then
   settingsXml=$SETTINGS_XML_FILE
else
   settingsXml="NADA"
fi

echo "settingsXml :" $settingsXml
