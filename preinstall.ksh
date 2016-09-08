#!/bin/ksh
#ident	"%W%" 

function backUpOrigDirectory
{
	export ORIG_VERSION=%{version}
	export NEW_VERSION="${ORIG_VERSION}.`date +%y%m%d.%H%M`"
	export PRODUCT=${RPM_INSTALL_PREFIX0}/${ORIG_VERSION}
	export NEW_PRODUCT=${RPM_INSTALL_PREFIX0}/${NEW_VERSION}
	
	echo "ORIG_VERSION is:${ORIG_VERSION}"
	echo "NEW_VERSION is:${NEW_VERSION}"
	echo "PRODUCT is:${PRODUCT}"
	echo "NEW_PRODUCT is:${NEW_PRODUCT}"
	
	echo "checking the current installation for $PRODUCT......"
	if [ -d ${PRODUCT} ]; then
		echo "%preinstall: *** moving the current installtion ${PRODUCT} to ${NEW_PRODUCT} ***"
		mv ${PRODUCT} ${NEW_PRODUCT}
		echo "%preinstall: *** moved the current installtion ${PRODUCT} to ${NEW_PRODUCT} ***"
	else
		echo "No previous installation. Skipping backup for ${PRODUCT}!!!"
	fi
	
	# backup version for /opt/gficore/corp
	ORIG_DIRECTORY=/opt/gficore/corp/${ORIG_VERSION}
	NEW_DIRECTORY=/opt/gficore/corp/${NEW_VERSION}
	if [ -d ${ORIG_DIRECTORY} ]; then
		echo "%preun: *** moving the current installtion ${ORIG_DIRECTORY} to ${NEW_DIRECTORY} ***"
		mv ${ORIG_DIRECTORY} ${NEW_DIRECTORY}
		echo "%preun: *** moved the current installtion ${ORIG_DIRECTORY} to ${NEW_DIRECTORY} ***"
	else
		echo "No previous installation. Skipping backup for ${ORIG_DIRECTORY}!!!"
	fi
	
	# backup version for /opt/gficore-resources/corp
	ORIG_DIRECTORY=/opt/gficore-resources/corp/${ORIG_VERSION}
	NEW_DIRECTORY=/opt/gficore-resources/corp/${NEW_VERSION}
	if [ -d ${ORIG_DIRECTORY} ]; then
		echo "%preun: *** moving the current installtion ${ORIG_DIRECTORY} to ${NEW_DIRECTORY} ***"
		mv ${ORIG_DIRECTORY} ${NEW_DIRECTORY}
		echo "%preun: *** moved the current installtion ${ORIG_DIRECTORY} to ${NEW_DIRECTORY} ***"
	else
		echo "No previous installation. Skipping backup for ${ORIG_DIRECTORY}!!!"
	fi
	
	# backup version for /opt/gficore/mbs
	ORIG_DIRECTORY=/opt/gficore/mbs/${ORIG_VERSION}
	NEW_DIRECTORY=/opt/gficore/mbs/${NEW_VERSION}
	if [ -d ${ORIG_DIRECTORY} ]; then
		echo "%preun: *** moving the current installtion ${ORIG_DIRECTORY} to ${NEW_DIRECTORY} ***"
		mv ${ORIG_DIRECTORY} ${NEW_DIRECTORY}
		echo "%preun: *** moved the current installtion ${ORIG_DIRECTORY} to ${NEW_DIRECTORY} ***"
	else
		echo "No previous installation. Skipping backup for ${ORIG_DIRECTORY}!!!"
	fi
	
	# backup version for /opt/gficore-resources/mbs
	ORIG_DIRECTORY=/opt/gficore-resources/mbs/${ORIG_VERSION}
	NEW_DIRECTORY=/opt/gficore-resources/mbs/${NEW_VERSION}
	if [ -d ${ORIG_DIRECTORY} ]; then
		echo "%preun: *** moving the current installtion ${ORIG_DIRECTORY} to ${NEW_DIRECTORY} ***"
		mv ${ORIG_DIRECTORY} ${NEW_DIRECTORY}
		echo "%preun: *** moved the current installtion ${ORIG_DIRECTORY} to ${NEW_DIRECTORY} ***"
	else
		echo "No previous installation. Skipping backup for ${ORIG_DIRECTORY}!!!"
	fi
}

function unLink
{
        DIR=$1
        if [ -L ${DIR} ]; then
        		echo "remove softlink for ${DIR}"
                unlink ${DIR}
        else
            echo "failed remove softlink for ${DIR}"
        fi
}

function removeSoftlink
{
	if [ -d $RPM_INSTALL_PREFIX0/lib ]; then
		unlink $RPM_INSTALL_PREFIX0/lib
	fi
	if [ -d $RPM_INSTALL_PREFIX0/resources ]; then
		unlink $RPM_INSTALL_PREFIX0/resources
	fi
	
	if [ -d $RPM_INSTALL_PREFIX0/scripts ]; then
		unlink $RPM_INSTALL_PREFIX0/scripts
	fi
	
	if [ -d $RPM_INSTALL_PREFIX0/tpsadmin-scripts ]; then
		unlink $RPM_INSTALL_PREFIX0/tpsadmin-scripts
	fi
	
	if [ -d $RPM_INSTALL_PREFIX0/logs ]; then
		unlink $RPM_INSTALL_PREFIX0/logs
	fi
	

	unLink /opt/gficore/corp/antDeploy
	unLink /opt/gficore/corp/commonlib
	unLink /opt/gficore/corp/extensionlib
	unLink /opt/gficore/corp/Simpliciti
	unLink /opt/gficore/corp/scripts
	
	unLink /opt/gficore-resources/corp/core
	unLink /opt/gficore-resources/corp/core-converters 					
	unLink /opt/gficore-resources/corp/core-db 									
	unLink /opt/gficore-resources/corp/DataEnrichment
	unLink /opt/gficore-resources/corp/EVCalculator 						
	unLink /opt/gficore-resources/corp/PositionDispatcher
	unLink /opt/gficore-resources/corp/PosMgmtCommonResources 	
	unLink /opt/gficore-resources/corp/PosMgmtComponentResources
	unLink /opt/gficore-resources/corp/TradeProcessorService
	
	unLink /opt/gficore/mbs/commonlib
	unLink	 /opt/gficore/mbs/scripts
	
	unLink /opt/gficore-resources/mbs/BOEnrichmentService
	unLink /opt/gficore-resources/mbs/BOH-common                   
	unLink /opt/gficore-resources/mbs/BOHReceiverService           
	unLink /opt/gficore-resources/mbs/BOHReceiverServiceTMS        
	unLink /opt/gficore-resources/mbs/BOHSenderService             
	unLink /opt/gficore-resources/mbs/BOHSenderServiceTMS          
	unLink /opt/gficore-resources/mbs/BOResponseProcessor          
	unLink /opt/gficore-resources/mbs/BusinessTradeGenService      
	unLink /opt/gficore-resources/mbs/core                         
	unLink /opt/gficore-resources/mbs/core-converters              
	unLink /opt/gficore-resources/mbs/core-db                      
	unLink /opt/gficore-resources/mbs/DataEnrichment               
	unLink /opt/gficore-resources/mbs/DerivedTradeGenService       
	unLink /opt/gficore-resources/mbs/ECNServiceCommon             
	unLink /opt/gficore-resources/mbs/ECNServiceRequest            
	unLink /opt/gficore-resources/mbs/ECNServiceResponse           
	unLink /opt/gficore-resources/mbs/FigService                   
	unLink /opt/gficore-resources/mbs/MatchingService              
	unLink /opt/gficore-resources/mbs/PositionDispatcher           
	unLink /opt/gficore-resources/mbs/PosMgmtCommonResources       
	unLink /opt/gficore-resources/mbs/PosMgmtComponentResources
	unLink /opt/gficore-resources/mbs/QC                           
	unLink /opt/gficore-resources/mbs/RealTimeAndBatchUpdateService
	unLink /opt/gficore-resources/mbs/RttmReceiverService          
	unLink /opt/gficore-resources/mbs/RttmSenderService            
	unLink /opt/gficore-resources/mbs/TPSDistributionService       
	unLink /opt/gficore-resources/mbs/TpsPositionCommon            
	unLink /opt/gficore-resources/mbs/TPSProxyService              
	unLink /opt/gficore-resources/mbs/TPSTraceServiceCommon        
	unLink /opt/gficore-resources/mbs/TPSTraceServiceReceiver      
	unLink /opt/gficore-resources/mbs/TPSTraceServiceSender        
	unLink /opt/gficore-resources/mbs/TradeCreateService           
	unLink /opt/gficore-resources/mbs/TradeGen                     
	unLink /opt/gficore-resources/mbs/TradeProcessorService
}
echo "====================== Starting preinstall.ksh ======================"
echo "%preinstall:The rpm install prefix : $RPM_INSTALL_PREFIX0 $RPM_INSTALL_PREFIX1 $RPM_INSTALL_PREFIX2 $RPM_INSTALL_PREFIX3 $RPM_INSTALL_PREFIX4 $RPM_INSTALL_PREFIX5"
removeSoftlink
backUpOrigDirectory
