#/bin/env bash -e

USERNAME=`whoami`

# Installation directory (specify a full path!)
INSTALL_DIR=/home/${USERNAME}/argos3-dist

# ARGoS3 repository
ARGOS3_REPOSITORY=git://github.com/ilpincy/argos3.git
ARGOS3_BRANCH=master
ARGOS3_TAG=3.0.0-beta48
ARGOS3_DIR=argos3

# IRIDIA e-puck repository
EPUCK_REPOSITORY=git://github.com/demiurge-project/argos3-epuck.git
EPUCK_BRANCH=master
EPUCK_TAG=v48
EPUCK_DIR=argos3-epuck

# TAM repository
TAM_REPOSITORY=https://garattonilorenzo:prova@iridia-dev.ulb.ac.be/projects/iridia-tam.git
TAM_BRANCH=master
TAM_DIR=iridia-tam

#demiurge dao
DAO_REPO=git@github.com:demiurge-project/demiurge-epuck-dao.git
DAO_BRANCH=master
DAO_TAG=master
DAO_DIR=demiurge-epuck-dao

#demiurge loop functions
LOOP_REPO=git@github.com:demiurge-project/experiments-loop-functions.git
LOOP_BRANCH=master
LOOP_TAG=master
LOOP_DIR=experiments-loop-functions

#automode
AUTO_REPO=git@github.com:KenN7/argos3-AutoMoDe.git
AUTO_BRANCH=gianduja2
AUTO_TAG=gianduja2
AUTO_DIR=argos3-AutoMoDe

#neat
NEAT_REPO=git@github.com:KenN7/neat-argos3.git
NEAT_BRANCH=gianduja
NEAT_TAG=gianduja 
NEAT_DIR=neat-argos3



function error() {
    echo
    echo "Error, script halted."
    exit 1
}

# Fetches the latest sources from a git repository
# $1: full repository URL
# $2: repository branch
# $3: output directory
function get_code() {
    local REPO=$1
    local BRANCH=$2
    local TAG=$3
    local OUTDIR=$4
  
    if [ ! -d $OUTDIR ]; then
        echo -n "Downloading... "
        git clone --branch=$BRANCH $REPO $OUTDIR || error
        cd $OUTDIR || error
        git checkout $TAG|| error
        cd ..
    else
        echo -n "Updating... "
        cd $OUTDIR || error
        git checkout $TAG|| error
        cd ..
    fi
    echo "done"
}

# Creates the build directory, builds the code, and installs binaries
# $1: source location
# $*: extra CMake args
function do_build_install() {
    local SRC=../$1
    shift
    rm -rf build || error
    echo -n "Compiling... "
    mkdir build || error
    cd build || error
    cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
          -DCMAKE_BUILD_TYPE=Release \
          $* $SRC || error
    make -j4 || error
    echo "done"
    echo "Installing... "
    make install || error
    cd ..
    echo "done"
}

function do_build() {
    local SRC=../$1
    shift
    rm -rf build || error
    echo -n "Compiling... "
    mkdir build || error
    cd build
    cmake -DCMAKE_BUILD_TYPE=Release \
          $* $SRC || error
    make -j4 || error
    cd ..
    echo "done"
}

# Builds and installs ARGoS3
function do_argos3() {
    echo "+++ ARGoS3 +++"
    get_code $ARGOS3_REPOSITORY $ARGOS3_BRANCH $ARGOS3_TAG $ARGOS3_DIR
    cd $ARGOS3_DIR
    do_build_install src -DARGOS_INSTALL_LDSOCONF=OFF -DARGOS_DOCUMENTATION=OFF
    cd ..
    echo -n "Deleting default e-puck... "
    rm -rf \
        $INSTALL_DIR/include/argos3/plugins/robots/e-puck \
        $INSTALL_DIR/lib/argos3/lib*epuck*.so
    echo "done"
}

# Builds and installs e-puck
function do_epuck() {
    echo "+++ e-puck +++"
    export PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig
    get_code $EPUCK_REPOSITORY $EPUCK_BRANCH $EPUCK_TAG $EPUCK_DIR
    cd $EPUCK_DIR
    # modify CMakeList for cluster compiling without QT (desactivate vision tools)
    sed -i.bak 's/.*VisionTools/#&/' src/plugins/robots/e-puck/CMakeLists.txt
    echo "sed done, desactivate vision... "
    do_build_install src
    cd ..
}


function do_dao() {
    echo "+++ demiurge DAO +++"
    export PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig
    echo $DAO_REPO $DAO_BRANCH $DAO_TAG $DAO_DIR
    get_code $DAO_REPO $DAO_BRANCH $DAO_TAG $DAO_DIR
    cd $DAO_DIR
    do_build_install
    cd ..
}

function do_loop() {
    echo "+++ loop functions +++"
    export PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig
    get_code $LOOP_REPO $LOOP_BRANCH $LOOP_TAG $LOOP_DIR
    cd $LOOP_DIR
    do_build_install
    cd ..
}

function do_auto() {
    echo "+++ e-puck +++"
    export PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig
    get_code $AUTO_REPO $AUTO_BRANCH $AUTO_TAG $AUTO_DIR
    cd $AUTO_DIR
    do_build
    cd ..
}

function do_neat() {
    echo "+++ e-puck +++"
    export PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig
    get_code $NEAT_REPO $NEAT_BRANCH $NEAT_TAG $NEAT_DIR
    cd $NEAT_DIR
    sed -i 's/.*genome_parser/#&/' src/CMakeLists.txt
    do_build
    cd ..
}

# Builds and installs tam
function do_tam() {
    echo "+++ TAM +++"
    export PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig
    export LD_LIBRARY_PATH=/usr/java/jdk1.6.0_43/jre/lib/amd64/xawt
    get_code $TAM_REPOSITORY $TAM_BRANCH $TAM_DIR
    cd $TAM_DIR
    do_build_install argos3/src
    cd ..
}

# Creates the setup script
function do_create_setup_script() {
    local SCRIPTFILE=$INSTALL_DIR/bin/setup_argos3
    echo "export PKG_CONFIG_PATH=$INSTALL_DIR/lib/pkgconfig" > $SCRIPTFILE
    echo "export ARGOS_PLUGIN_PATH=$INSTALL_DIR/lib/argos3" >> $SCRIPTFILE
    echo "export LD_LIBRARY_PATH=\$ARGOS_PLUGIN_PATH:/usr/java/jdk1.6.0_43/jre/lib/amd64:/usr/java/jdk1.6.0_43/jre/lib/amd64/server:/usr/java/jdk1.6.0_43/jre/lib/amd64/xawt" >> $SCRIPTFILE
    echo "export PATH=$PATH:$INSTALL_DIR/bin" >> $SCRIPTFILE
    echo "Execute the following command to setup the environment for ARGoS3:"
    echo
    echo "  source $SCRIPTFILE"
}

# Erase and re-create installation directory
rm -rf $INSTALL_DIR
mkdir $INSTALL_DIR

# Go through packages
do_argos3
do_epuck
do_dao
do_loop
do_auto
do_neat
#do_tam

# Create the setup script
do_create_setup_script
