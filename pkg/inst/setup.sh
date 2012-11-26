#! /bin/bash

path=$1
rinstdir=$2
pyinstdir="healthvisServer"

# check python
command -v python >/dev/null 2>&1 || { echo "python not found" >&2; exit 1; }

# create directory if it doesn't exist
if [ -d $path ] 
then
	mkdir -p $path
fi

# switch to directory
pushd $path

# check if virtualenv is there already
if [ ! -f virtualenv.py ]; then
	# get virtualenv
	echo "Getting virtualenv"
	curl -O https://raw.github.com/pypa/virtualenv/master/virtualenv.py

	# verify virtualenv was downloaded
	if [ ! -f virtualenv.py ]; then
		echo "couldn't download virtualenv.py";
		exit 1;
	fi
fi

# check if the virtual environment is ther already
if [ ! -f ./$pyinstdir/bin/pip ]; then
	# make the virtual environment
	python virtualenv.py $pyinstdir
fi

# check pip works
command -v ./$pyinstdir/bin/pip >/dev/null 2>&1 || { echo "error pip not found" >&2; exit 1; }

res=$(./$pyinstdir/bin/pip freeze | grep tornado)
if [ -z "$res" ]; then
	echo "Installing tornado"

	# install tornado
	./$pyinstdir/bin/pip install tornado
fi

res=$(./$pyinstdir/bin/pip freeze | grep Flask-WTF)
if [ -z "$res" ]; then
	echo "Installing flask"
	# install flask-wtf
	./$pyinstdir/bin/pip install flask-wtf
fi

# test flask
echo "Testing installation"
./$pyinstdir/bin/python $rinstdir/test_setup.py || { echo "error starting flask" >&2; exit 1; }

# copy files over 
echo "Copying healthvis files"
cp -r $rinstdir/application $pyinstdir
cp $rinstdir/runit.py $pyinstdir
cp $rinstdir/startserver.sh $pyinstdir/bin
cp $rinstdir/stopserver.sh $pyinstdir/bin

# done
exit 0



