#!/bin/bash

#####	NOME:				install01.sh
#####	VERSÃO:				1.0
#####	DESCRIÇÃO:			Configura apenas um ambiente AMQ como SSL SNI (adaptado para o cluster Openshift do IBGE).
#####	DATA DA CRIAÇÃO:	02/07/2020
#####	ESCRITO POR:		Germano Araújo da Silva
#####	E-MAIL:				germanoaraujodasilva@gmail.com
##### MODIFICADO POR: Marcio Gonçalves da Silva
##### E-MAIL:       marcio.goncalves@ibge.gov.br
#####	DISTRO:				red Hat Enterprise Linux 7 
#####	LICENÇA:			GPLv3
#####	PROJETO:			https://github.com/marciogonsil/demo-amq-ssl-sni


# Criando os certificados para criação do canal SSL



BROKER_KEYSTORE_PASSWORD=redhat
CLIENT_KEYSTORE_PASSWORD=redhat
#OC_HOST=https://master.rjo-ff44.example.opentlc.com:443

IBGE_NAMESPACE_DEV=amq

echo "Criando os certificados.."

# Create a keystore for the broker SERVER
keytool \
	-genkey \
	-keyalg RSA \
	-alias amq-server \
    -dname "CN=amq-broker, OU=DI, O=IBGE, L=Rio de Janeiro, ST=RJ, C=BR" \
	-keystore amq-server.ks \
	-storepass $BROKER_KEYSTORE_PASSWORD \
    -keypass $BROKER_KEYSTORE_PASSWORD


# Export the broker SERVER certificate from the keystore
keytool \
	-export \
	-alias amq-server \
	-keystore amq-server.ks \
	-storepass $CLIENT_KEYSTORE_PASSWORD \
	-file amq-server_cert

# Create the CLIENT keystore
keytool \
	-genkey \
	-keyalg RSA \
	-alias amq-client \
    -dname "CN=app.amq-broker, OU=DI, O=IBGE, L=Rio de Janeiro, ST=RJ, C=BR" \
	-keystore amq-client.ks \
	-storepass $CLIENT_KEYSTORE_PASSWORD \
    -keypass $CLIENT_KEYSTORE_PASSWORD

# Import the previous exported broker’s certificate into a CLIENT truststore
keytool \
	-import \
	-alias amq-server \
	-keystore amq-client.ts \
	-file amq-server_cert \
	-storepass $CLIENT_KEYSTORE_PASSWORD \
    -trustcacerts \
    -noprompt


# OPTIONAL steps...
# If you want to make trusted also the client, you must export the client’s certificate from the keystore
 keytool -export -alias amq-client -keystore amq-client.ks -file amq-client_cert

# Import the client’s exported certificate into a broker SERVER truststore
 keytool -import -alias amq-client -keystore amq-server.ts -file amq-client_cert

# A good tool to know to list the contents of the key
keytool -list -keystore amq-server.ks


#
## CRIANDO OS NAMESPACES NO OPENSHIFT
#

echo "Conectando ao Openshift"
#oc login $OC_HOST -u admin@example.com



#echo "Instalando os novos templates do AMQ em: $IBGE_NAMESPACE_DEV"
#oc create -f amq-7.7-broker-openshift/amq-broker-7-image-streams.yaml -n openshift -n $IBGE_NAMESPACE_DEV

#for entry in amq-7.7-broker-openshift/templates/*
#do
#  oc create -f $entry -n openshift -n $IBGE_NAMESPACE_DEV
#done


#oc new-project $IBGE_NAMESPACE_DEV \
#    --description="Ambiente do broker de mensagens de desenvolvimento" \
#    --display-name="IBGE - Dev"

oc project $IBGE_NAMESPACE_DEV

#oc delete serviceaccount amq-service-account
#oc delete secrets amq-app-secret
#oc delete pvc amq-broker-amq-claim

#oc create serviceaccount amq-service-account
#oc policy add-role-to-user view system:serviceaccount:$IBGE_NAMESPACE_DEV:amq-service-account
#oc create secret amq-app-secret amq-server.ks 
#oc secrets add sa/amq-service-account secret/amq-app-secret



## Para remover tudo que foi criado
#

#oc delete serviceaccount amq-service-account
#oc delete secrets amq-app-secret
#oc delete pvc amq-broker-amq-claim
