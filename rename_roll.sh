#!/bin/bash

# This script replaces all instances of the 'old' name of this roll template with
# a 'new' roll name. It changes file/directory names as well as the contents of
# the files inside this template roll.

usage () {
  echo "$(basename "$0") -n newname [-c curname] [-h] -- program to rename the roll template

where:
    -h  show this help text
    -n  where newname is the new name for the roll
    -c  where curname is the current name of the roll"
}

CURNAME=
NEWNAME=
options='hn:c:'
while getopts $options option
do
  case "$option" in
    c  ) CURNAME=$OPTARG;;
    n  ) NEWNAME=$OPTARG;;
    h  ) usage; exit;;
    \? ) printf "unknown option: -%s\n" "$OPTARG" >&2; usage >&2; exit 1;;
    :  ) printf "missing argument for -%s\n" "$OPTARG" >&2; usage >&2; exit 1;;
    *  ) printf "unimplemented optio: -%s\n" "$OPTARG" >&2; usage >&2; exit 1;;
  esac
done
shift $((OPTIND - 1))

# You 'must' supply a new roll name'
if [[ -z $NEWNAME ]]
then
  usage
  exit 1
fi

# If -c option is not specified use the default.
if [[ -z $CURNAME ]]
then
  CURNAME='skeleton'
fi

echo "Renaming ${CURNAME} roll to ${NEWNAME}"
echo "   Un-bundling the sample package..."
ROOT=$(pwd)
cd src/${CURNAME}
tar -xzf ${CURNAME}-1.0.tgz
/bin/rm -f ${CURNAME}-1.0.tgz
cd ${ROOT}

echo "   Changing directory names..."
DIRS=$(find -depth -type d | grep $CURNAME)

for d in ${DIRS}
do
  if [ -d ${d} ]; then
    newd=$(echo ${d} | sed "s,\(.*\)"${CURNAME}"\(.*\),\1"${NEWNAME}"\2,g")
    mv ${d} ${newd};
  fi
done

echo "   Changing file names..."
FILES=$(find . -type f | grep ${CURNAME})

for f in ${FILES}
do
  if [ -f ${f} ]; then
    newf=$(echo ${f} | sed "s,"${CURNAME}","${NEWNAME}",g");
    mv ${f} ${newf};
  fi
done
cd ${ROOT}

echo "   Changing file contents...."
FILES=`find . -type f`

for f in ${FILES}
do
  sed -i "s,"${CURNAME}","${NEWNAME}",g" ${f}
  #echo 'sed -i "s,"${CURNAME}","${NEWNAME}",g" ${f}'
done
cd ${ROOT}

echo "   Bundling sample package..."
cd src/${NEWNAME}
tar -czf "${NEWNAME}-1.0.tgz" "${NEWNAME}-1.0/"
rm -rf "${NEWNAME}-1.0/"
cd ${ROOT}

echo "   Removing .git directories..."
find -depth -type d -iname ".git" | xargs /bin/rm -rf

echo "While not required, you should move rename this directory ${NEWNAME}."

exit 0
