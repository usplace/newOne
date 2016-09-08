#ident     "%W%"

echo "Start postinstall script"
echo "RPM_INSTALL_PREFIX: $RPM_INSTALL_PREFIX"
echo "RPM_INSTALL_PREFIX0: $RPM_INSTALL_PREFIX0"
echo "RPM_INSTALL_PREFIX1: $RPM_INSTALL_PREFIX1"
echo "RPM_INSTALL_PREFIX2: $RPM_INSTALL_PREFIX2"
echo "RPM_INSTALL_PREFIX3: $RPM_INSTALL_PREFIX3"

INSTALL_ENV=`echo $RPM_INSTALL_PREFIX1 | sed 's:/::' | tr A-Z a-z`
if [ "$INSTALL_ENV" != "dev" -a "$INSTALL_ENV" != "intg" -a "$INSTALL_ENV" != "ua" -a "$INSTALL_ENV" != "prod" -a "$INSTALL_ENV" != "cntg" ]; then
    echo "Error: INSTALL_ENV=${INSTALL_ENV} is invalid, please set it to [DEV|INTG|UA|PROD|CNTG]."
	echo "e.g. scsudo root /bin/rpm -ivh xxx.rpm --relocate /env=/INTG"
    exit 1
fi
echo "INSTALL_ENV=$INSTALL_ENV"

APP_OPT_DIR=$RPM_INSTALL_PREFIX0
echo "APP_OPT_DIR: $APP_OPT_DIR"
echo "Version: %{version}"

#copy files for gfi messageing
if [ -d $APP_OPT_DIR/%{version}/resources/gfi/ ]; then
echo "copying files..."
cp $APP_OPT_DIR/%{version}/resources/gfi/gfi-configuration-$INSTALL_ENV.xml  $APP_OPT_DIR/%{version}/resources/gfi-configuration.xml
fi

if [ -h $APP_OPT_DIR/lib ]; then   
   rm -rf $APP_OPT_DIR/lib
fi

if [ -d $APP_OPT_DIR/%{version}/lib ]; then
	ln -s $APP_OPT_DIR/%{version}/lib $APP_OPT_DIR/lib
	echo "Created link $APP_OPT_DIR/lib"
fi

if [ -h $APP_OPT_DIR/log ]; then   
   rm -rf $APP_OPT_DIR/log
fi

if [ -d /var/DspPubServiceCORP/%{version}/log ]; then
	ln -s /var/DspPubServiceCORP/%{version}/log $APP_OPT_DIR/log
	echo "Created link $APP_OPT_DIR/log"
fi

if [ -h $APP_OPT_DIR/scripts ]; then   
   rm -rf $APP_OPT_DIR/scripts
fi

if [ -d $APP_OPT_DIR/%{version}/scripts ]; then
	ln -s $APP_OPT_DIR/%{version}/scripts $APP_OPT_DIR/scripts
	chmod 500 $APP_OPT_DIR/%{version}/scripts/dsp.jmx.properties
	echo "Created link $APP_OPT_DIR/scripts"
fi

#take in JAVA_HOME from relocate parameters
export JAVA_HOME=`echo $RPM_INSTALL_PREFIX3`
if [ ! -d $JAVA_HOME ]; then
	export JAVA_HOME=/opt/jdk/1.6.0_37
fi
echo "JAVA_HOME:$JAVA_HOME"
sed -i "s:export JAVA_HOME=\(.*\):export JAVA_HOME=$JAVA_HOME:g" $APP_OPT_DIR/scripts/start-server.sh

if [ -h $APP_OPT_DIR/resources ]; then   
   rm -rf $APP_OPT_DIR/resources
fi

if [ -d $APP_OPT_DIR/%{version}/resources ]; then
	ln -s $APP_OPT_DIR/%{version}/resources $APP_OPT_DIR/resources
	echo "Created link $APP_OPT_DIR/resources"
	
fi

if [ -d $APP_OPT_DIR/%{version}/resources ]; then 
	 echo "starting prepare gemfire license"
	 cd $APP_OPT_DIR/%{version}/resources
   	 rm -rf $APP_OPT_DIR/%{version}/resources/*.dat
   	 cp /opt/gfitps/CorpGemfire/gemfireLicense.zip $APP_OPT_DIR/%{version}/resources/gemfireLicense.zip
fi

if [ -d $APP_OPT_DIR/ ]; then
	chown -R -h  gfitps:gfitps $APP_OPT_DIR
	echo "Change owner done"
fi

if [ -d $APP_OPT_DIR/lib ]; then
	rm -rf $APP_OPT_DIR/lib/XmlSerializer-*.jar
	rm -rf $APP_OPT_DIR/lib/TPSConstants-*.jar
	rm -rf $APP_OPT_DIR/lib/core-db-*.jar
	rm -rf $APP_OPT_DIR/lib/core-converters-*.jar
	rm -rf $APP_OPT_DIR/lib/core-*.jar
	rm -rf $APP_OPT_DIR/lib/xmltrade-*.jar
	rm -rf $APP_OPT_DIR/lib/tps-common-*.jar
fi

#start package break if it has
echo "%post: *** start DSP CORP package break deployments ***"
export CONFIG_NAME=`echo $RPM_INSTALL_PREFIX2 | sed -e "s:\/::g"`
echo "config file name is:$CONFIG_NAME"
export PROJECT_NAME=_DspCorp
if [ "-$CONFIG_NAME" = "-release_name" ]; then
                echo "release_name is not defined, it means no package break for the current rpm."
else
                export PKG_BRK_PATH=/home/gfitps/PackageBreak/$CONFIG_NAME
                export PKG_BRK_CFG_NAME="$CONFIG_NAME""$PROJECT_NAME".cfg
                export PKG_BRK_FILE=$PKG_BRK_PATH/$PKG_BRK_CFG_NAME
                echo "The configuration file name for package break is :$PKG_BRK_FILE"
                if [ ! -f $PKG_BRK_FILE ]; then
        						echo "Configuration file $PKG_BRK_FILE does not exist!"
                else
                		echo "Will execute the package break according to the configuration file of $PKG_BRK_FILE."                		
                    /opt/TpsCash/scripts/PackageBreak_Auto.sh $PKG_BRK_FILE deploy
                fi
                export HOST_NAME=`hostname`
                export PKG_BRK_CFG_NAME_WITH_HOST="$CONFIG_NAME"_"$PROJECT_NAME"_"$HOST_NAME".cfg
                export PKG_BRK_FILE=$PKG_BRK_PATH/$PKG_BRK_CFG_NAME_WITH_HOST
                if [ ! -f $PKG_BRK_FILE ]; then
        						echo "Configuration file $PKG_BRK_FILE does not exist!"
                else
                    echo "Will execute the package break according to the configuration file of $PKG_BRK_FILE."
                    /opt/TpsCash/scripts/PackageBreak_Auto.sh $PKG_BRK_FILE deploy
                fi
fi
echo "%post: *** end DSP CORP package break deployments ***"


echo "Done postinstall script"
