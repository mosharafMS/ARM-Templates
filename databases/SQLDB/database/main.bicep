// ----------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
//
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, 
// EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES 
// OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
// ----------------------------------------------------------------------------------


param databaseName string
param logicalServerName string
param tags object  = {}

param location string
param sku object = {
    name:'GP_Gen5_2'
    size: '2GB'
    capacity:2
}
param properties object = {
    collaction:'SQL_Latin1_General_CP1_CI_AS'
    autoPauseDelay:60
}

resource logicalServer 'Microsoft.Sql/servers@2021-05-01-preview' existing ={
    name : logicalServerName
}


resource db 'Microsoft.Sql/servers/databases@2021-05-01-preview'= {
    name : databaseName
    location:location
    parent:logicalServer
    tags:tags
    sku:{
        name: sku.name
        size: sku.size
        capacity: sku.capacity
    }
    properties:{
       collation: properties.collation
       autoPauseDelay: properties.autoPauseDelay
    }
}
    
