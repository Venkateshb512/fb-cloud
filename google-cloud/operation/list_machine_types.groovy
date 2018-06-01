// begin
log.trace("Started execution 'fb-cloud:google-cloud:operation:list_machine_types.groovy' flintbit...") // execution Started
try{
    // Flintbit input parametes
    // Mandatory
    connector_name = input.get('connector_name') // google-cloud connector name
    action = "list-machine-types" // name of the operation: list-machine-types
    project_id = input.get('project-id') // project-id of the google cloud-platform 
    zone_name = input.get('zone-name') // zone-name of the project id
    service_account_credenetials = input.get('service-account-credentials') //service account credentials as json for the given project-id
   
    // Optional
    request_timeout = input.get('timeout')	// Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    //initialize the connector with the action and other parameters
    connector_call = call.connector(connector_name)
                         .set('action', action)                         
                         
    // checking connector name is nil or empty
    if (connector_name == null || connector_name == ""){
       throw new Exception ( 'Please provide "google-cloud connector name (connector_name)" to list machine types')
    }

    //checking project-id is nil or empty
    if( project_id == null || project_id == ""){
       throw new Exception ( 'Please provide "Please provide project id (project-id)" to list machine types')
    }
    else{
        connector_call.set('project-id', project_id)
    }

     //checking project-id is nil or empty
    if( zone_name == null || zone_name == ""){
       throw new Exception ( 'Please provide "Please provide zone name(zone-name)" to list machine types')
    }
    else{
        connector_call.set('zone-name', zone_name)
    }

  //checking service-account-credentials is nil or empty
    if( service_account_credenetials == null || service_account_credenetials == ""){
       throw new Exception ( 'Please provide "Please provide service account credentials (service-account-credentials)" to list machine types')
    }
    else{
        connector_call.set('service-account-credentials', service_account_credenetials)
    }

    //checking that the request timeout provided or not
    if( request_timeout == null || request_timeout instanceof String ){
        log.trace("Calling ${connector_name} with default timeout...")
        // calling google cloud connector
        response = connector_call.sync()
    }
    else{
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        // calling google-cloud connector
        response = connector_call.timeout(request_timeout).sync()
    }

    // google-cloud  Connector Response Meta Parameters	
    response_exitcode = response.exitcode() // Exit status code
    response_message =  response.message() // Execution status message

    //list of the regions
    machine_type_list=response.get('machine-type-list')

    if (response_exitcode == 0){
        log.info("Success in executing ${connector_name} Connector, where exitcode :: ${response_exitcode} | message :: ${response_message}")      
            output.set('exit-code', 0).set('message', 'success').set('machine-type-list',machine_type_list)       
    }
    else{
        log.error("ERROR in executing ${connector_name} where, exitcode :: ${response_exitcode} | message :: ${response_message}")
        output.set('exit-code', -1).set('message', response_message)
       }
}
catch (Exception  e){
    log.error(e.message)
    output.set('exit-code', -1).set('message', e.message)
}

log.trace("Finished execution 'fb-cloud:google-cloud:operation:list_machine_types.groovy' flintbit...")
// end
