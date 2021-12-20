#!/bin/bash

TORRSSEN2=0.9.52
TORRSSEN2_HASH=2d2fe5a2b365d670be9afd28d43ee18623ca9faa
DATE=`date +%y%m%d`
ARCH=`arch`

if [ ${ARCH} != "x86_64" ]; then
  rm -rf ./torrssen2
  git clone https://github.com/tarpha/torrssen2.git
  cd torrssen2
  git checkout ${TORRSSEN2_HASH}
  sudo docker build -f ../torrssen2.Dockerfile -t tarpha/torrssen2:${TORRSSEN2} .
  cd ..
  rm -rf ./torrssen2
fi

sudo docker build -t banyazavi/tsharp:${ARCH} \
  --build-arg build_date=${DATE} \
  --build-arg version_torrssen2=${TORRSSEN2} \
  .

# sudo docker login
# sudo docker push banyazavi/tsharp:${ARCH}
