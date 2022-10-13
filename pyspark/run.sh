#!/bin/bash

## En local ->
## pig -x local -

## en dataproc...

## copy data
gsutil cp page_links_en.nt.bz2 gs://mon_seau/

## copy pig code
gsutil cp pagerank-notype.py gs://mon_seau/

## Clean out directory
gsutil rm -rf gs://mon_seau/out


## create the cluster
gcloud dataproc clusters create cluster-a35a --enable-component-gateway --region europe-west1 --zone europe-west1-c --master-machine-type n1-standard-4 --master-boot-disk-size 500 --num-workers 4 --worker-machine-type n1-standard-4 --worker-boot-disk-size 500 --image-version 2.0-debian10 --project pagerank-atal


## run
## (suppose that out directory is empty !!)
gcloud dataproc jobs submit pyspark --region europe-west1 --cluster cluster-a35a gs://mon_seau/pagerank-notype.py  -- gs://mon_seau/page_links_en.nt.bz2 3

## access results
gsutil cat gs://mon_seau/out/pagerank_data_10/part-r-00000

## delete cluster...
gcloud dataproc clusters delete cluster-a35a --region europe-west1

