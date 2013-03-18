#!/bin/sh

if [ $# -lt 2 ]
then
	echo "Usage: start.sh Instance Environment"
	echo "Sample: start.sh 6 Production
	echo "Exiting..."
	exit 1
fi

INSTANCE=$1
ENVIRONMENT=$2
APPNAME="AppName"
DATE=`date +%Y_%m_%dT%H_%M_%S`
JAVA_HOME=/usr/java/jdk1.7.0_05

#############################################################################
# Version Discovery
#############################################################################
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# work out the version from the directory structure
if [[ ${DIR} =~ ".*/(.*)/bin$" ]]
then
        VERSION=${BASH_REMATCH[1]}
else
        echo "start> No version found in directory hierarchy"
        echo "Exiting..."
        exit 1
fi

# set variables depending on the environment
case `echo ${ENVIRONMENT} | tr '[:upper:]' '[:lower:]'` in
prod*)
	ENVIRONMENT="Production"
	;;
qa*)
	ENVIRONMENT="Qa"
	;;
dev*)
	ENVIRONMENT="Development"
	;;
*)
	echo "Unknown environment ${ENVIRONMENT} [possible values: dev,qa,prod]"
	echo "Exiting..."
	exit 1;
esac

CONFIG_HOME="/usr/${APPNAME}/${VERSION}/config"
LIB_HOME="/usr/${APPNAME}/${VERSION}/lib"
BIN_HOME="/usr/${VERSION}/bin"
LOG_HOME="/usr/logs"
LOG="$LOG_HOME/${APPNAME}_${INSTANCE}_${DATE}.log.${ENVIRONMENT}"

#############################################################################
# Live Check
#############################################################################
LIVE_CHECK=`/bin/ps auwwx | grep Instance=${INSTANCE} | grep -v grep`

if [ ${LIVE_CHECK} -gt 0 ]
then
	echo "start> Instance already running, will not start new instance"
	echo "Exiting..."
	exit 1
fi

#############################################################################
# CLASSPATH params
#############################################################################
CLASSPATH=${LIB_HOME}:\
${LIB_HOME}/*:\
${CONFIG_HOME}/Common:\

#############################################################################
# JVM params
#############################################################################
JVM_PARAMS=-DInstance=${INSTANCE}" "\
-DDATE=${DATE}" "\
-DAPPNAME=${APPNAME}" "\
-Dcom.sun.management.jmxremote

##########################################################################
# Garbage collection params
##########################################################################
GC_PARAMS=-verbose:gc" "\
-Xms1024m" "\
-Xmx1024m" "\
-XX:PermSize=256m" "\
-XX:MaxPermSize=256m" "\
-XX:+UseLargePages" "\
-XX:+PrintGCDateStamps" "\
-XX:+UseConcMarkSweepGC" "\
-XX:MaxGCPauseMillis=1000" "\
-XX:+CMSIncrementalMode" "\
-XX:+PrintGCDetails

# print out environment variables
set >> ${LOG}

echo "start> Starting instance..."

$JAVA_HOME/bin/java -classpath $CLASSPATH $JVM_PARAMS $GC_PARAMS com.xyz.Program >> ${LOG} 2>&1 &
