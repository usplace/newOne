TPS TRADE Entry逻辑(spring  ,  Tps)：                            JndiTemplate连接的信息？
1        	RioToTpsService          -->Receiver--> Queue: RioToTpsQueue  [JndiObjectFactoryBean]   (jndiName:URO.FICCRATES.1.TPS , jndiTemplate: JndiTemplate)
                                                                                        Listener : RioToTpsListener [RioJmsListener]   (JmsTemplate (CachingConnectionFactory, tps.to.rio.ack.topic),                                
                                                                                                                                                                                                                    RioAckMessagePreparer )

		                JndiTemplate{
				<prop key="java.naming.factory.initial">
					${jndiInitialFactory}
				</prop>
				<prop key="java.naming.provider.url">
					${mbsProviderUrl}
				</prop>
				<prop key="java.naming.security.principal">
					${mbsJndiPrincipal}
				</prop>
				<prop key="java.naming.security.credentials">
					${mbsJndiCredential}
				</prop>
				<prop key="com.tibco.tibjms.naming.security_protocol">
					${mbsSecurityProtocol}
				</prop>
				<prop key="com.tibco.tibjms.naming.ssl_enable_verify_host">
					${mbsSslEnableVerifyHost}
				</prop>
				<prop key="com.tibco.tibjms.naming.ssl_enable_verify_hostname">
					${mbsSslEnableVerifyHostName}
				</prop>
 
                                                                             }	
			command: RioToTps_CommandChain	

		
2	ClientToTpsCashSerice--> Receiver[ DefaultMessageListenerContainer]--> ClientToTpsCashQueue[J同上]   (tps.cash.client.request.queue,                             
                                                   jndiCorpTemplate: JndiTemplate)
                                                                                                                                              ClientToTpsCashListener[ProxyFactoryBean] (AbstractClientJmsListener)         
                                                                   command: ClientToTps_CommandChain
	
3	ClientToTpsMbsService->同上    --> ClientToTpsCashQueue[D同上]   (tps.cash.client.request.queue,  jndiCorpTemplate: JndiTemplate)
                                                                                                           ClientToTpsMbsListener[AbstractClientJmsListener] (ToDtgPublisher , tps.mbs.jms.provider.url)    
     
4	CacheManagerService-->JmxTopicListener[D同上]--> defaultDestination[J同上]( tps.cache.manager.jmx.topic  ,    jndiTemplate)
                                                                                                                         TopicListener[JmxListener](  InscopeAccountsJmx,
                                                                                                                                                                           MappingsCacheManagerJmx,
							           BusinessLineDiscovererJmx,
							           StrategyProductLineDiscovererJmx
                                                                                                                                                                          )  
                                                                  JmxPublisher

5	RioFusionToTpsService--> RioFusionToTpsReceiver    --> RioFusionToTpsQueue[J同上]   (rio.fusion.to.tps.queue, jndiCorpTemplate )
					         RioFusionToTpsListener[RioJmsListener](同一)
			command: RioFusionToTps_CommandChain

                                                                                                                
6	RioIcehotelToTpsService	
7	ClientToTpsJsonService


 监听处理：          *_ command_*.xml   配置文件：bean保存命令串 ，顺序执行，将bean作为参数传入AbstractClientJmsLister  ， 满足监听条件进行一系列  处理：  
                        <ref bean="ClientToTpsTransformCommand" />
                       <ref bean="TradeConversionCommand" />
	<ref bean="SupportedFlowValidationCommand" />
                       <ref bean="BizLineControllerCommand" />
	<ref bean="PositionCommand" />
	<ref bean="PersistCommand" />
	<ref bean="TEPublishCommand" />              
