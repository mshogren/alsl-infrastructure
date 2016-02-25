#!/bin/bash
azure resource create Default-Storage-WestUS MyFarm "Microsoft.Web/ServerFarms" -l "West US" -o "2015-06-01" -p "{\"sku\":{\"name\": \"F1\" }}"
