#!/bin/bash
# This is a comment

#defining a variable
#echo "What is your name?"
#reading input
#read NAME
#defining a variable
#GREETINGS="Hello! How are you"
#echo $NAME $GREETINGS

#To log into Azure portal
az login
#Getting account details
az account show
#Grabbing ID from output using jq 
echo "step1"
az account show | jq -r '.id'
# Set as an environment variable in the Bash session
export id=$(az account show | jq -r '.id')
# To print the id
echo "step2"
echo $id


echo "#Generating 4 uuids and appending the string test_vnet to the uuid"
export id1=$(uuidgen)_test_vnet
export id2=$(uuidgen)_test_vnet
export id3=$(uuidgen)_test_vnet
export id4=$(uuidgen)_test_vnet
echo $id1 $id2 $id3 $id4

#ARRAY

echo "#Generating 4 resource groups and appending the string test_vnet to the UUID"
 #One variable for location and do it in a loop
az group create --name $id1, $id2, $id3, $id4 --location westus
az group create --name $id2 --location westus
az group create --name $id3 --location westus
az group create --name $id4 --location westus


echo "#Creating a virtual network in the resource groups" 
#do it in a loop
az network vnet create \
  --name myVNet1 \
  --resource-group $id \
  --subnet-name default

az network vnet create \
  --name myVNet2 \
  --resource-group $id2 \
  --subnet-name default

az network vnet create \
  --name myVNet3 \
  --resource-group $id3 \
  --subnet-name default

 az network vnet create \
  --name myVNet4 \
  --resource-group $id4 \
  --subnet-name default 

for i in `seq 1 4`; do 
az network vnet create \
  --name myVNet1 \
  --resource-group $id$i \
  --subnet-name default
done

#example of for while loop
i=0
while [ $i -ne 4 ]
do
        i=$(($i+1))
        echo $id$i
done

echo "#List all resource groups in your subscription"
az group list


#Getting the names of all resourceups
az group list | jq 'map(.name)'
#Selecting the resource group name from each resource
az resource list | jq 'map(.resourceGroup) | group_by(.) | map({ name: .[0], length: length }) | sort_by(.length) | reverse'
#Start by pushing all resource groups with items into a bash variable
RG_NAMES=$(az resource list | jq -r 'map(.resourceGroup) | group_by(.) | map(.[0])')
#Next, we'll use $RG_NAMES as a substitution into a query against az group list
az group list | jq -r "map(.name) | map(select(. as \$NAME | $RG_NAMES | any(. == \$NAME) | not)) | sort" gro

#Grab the first resource from the output
az group list --query "[0].name"