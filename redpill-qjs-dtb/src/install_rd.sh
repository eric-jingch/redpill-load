#!/bin/sh

tar -zxvf patch.tar.gz
# install dtc
chmod +x dtc
cp dtc /usr/sbin/dtc

# copy 16 ports dts file to /etc.defaults
echo $PLATFORM_ID
if [ "${PLATFORM_ID}" == "ds920p_42218" ]; then
  echo "copy DS920+'s 16 ports ds920p_16ports.dts to /etc.defaults"
  ./dtc -I dts -O dtb -o model.dtb ds920p_16ports.dts
  cp -vf model.dtb /etc.defaults/model.dtb
elif [ "${PLATFORM_ID}" == "fs2500_42218" ]; then
  echo "copy FS2500's 12 ports fs2500_12ports.dts to /etc.defaults"
  ./dtc -I dts -O dtb -o model_fs2500_42218.dtb fs2500_12ports.dts
elif [ "${PLATFORM_ID}" == "ds1621p_42218" ]; then
  echo "copy DS1621+'s 16 ports ds1621p_16ports.dts to /etc.defaults"
  ./dtc -I dts -O dtb -o model.dtb ds1621p_16ports.dts
  cp -vf model.dtb /etc.defaults/model.dtb
fi  

# copy file
if [ ! -f model_${PLATFORM_ID}.dtb ]; then
echo "dtb file not exists for this platform!!!"
  # Dynamic generation
  ./dtc -I dtb -O dts -o output.dts /etc.defaults/model.dtb
  if [ "echo ${PLATFORM_ID} | cut -c 1-2" == "fs" ]; then
    qjs --std ./dts_fs.js output.dts output.dts.out
  else
    qjs --std ./dts.js output.dts output.dts.out 
  fi
  if [ $? -ne 0 ]; then
    echo "auto generated dts file is broken"
    exit 0
  fi
  ./dtc -I dts -O dtb -o model_r2.dtb output.dts.out
  cp -vf model_r2.dtb /etc.defaults/model.dtb
  cp -vf model_r2.dtb /var/run/model.dtb
else
  cp -vf model_${PLATFORM_ID}.dtb /etc.defaults/model.dtb
  cp -vf model_${PLATFORM_ID}.dtb /var/run/model.dtb
fi
