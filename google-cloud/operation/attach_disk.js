/**
** Author: Anurag
** Creation Date: 8th January 2019
** Summary: GCP Attach Disk Action flintbit. 
** Description: This flintbit is developed to attach a disk to an instance.
**/

log.info("Started executing fb-cloud:google-cloud:operation:attach_disk.js flintbit")
try {

    service_account_credentials = input.get('service-account-credentials')
    project_id = input.get('project-id')
    action = 'attach-disk'
    connector_name = input.get('connector-name')
    zone_name = input.get('zone-name')
    instance_name = input.get('instance-name')
    disk_source = input.get('disk-source')

    // Winrm Commonconnect Call
    response = call.connector(connector_name)
        .set('service-account-credentials', service_account_credentials)
        .set('action', action)
        .set('zone-name', zone_name)
        .set('project-id', project_id)
        .set('instance-name', instance_name)
        .set('disk-source', disk_source)
        .timeout(60000)
        .sync()

    log.trace("Response: " + response)

    // google-cloud Connector Response Meta Parameters
    response_exitcode = response.exitcode()	// Exit status code
    response_message = response.message()	// Execution status messages

    if (response_exitcode == 0) {
        log.info("SUCCESS in executing " + connector_name + " where, exitcode : " + response_exitcode + "| message : " + response_message)
        output.set('exit-code', 0).set('message', response_message).set('disk-details', response.get('operation-details'))
    }
    else {
        log.error("ERROR in executing " + connector_name + " where, exitcode : " + response_exitcode + "| message : " + response_message)
        response = response.toString()
        if (response != "") {
            output.set('message', response_message).set('exit-code', 1).setraw('error-details', response.toString())
        }
        else {
            output.set('message', response_message).set('exit-code', 1)
        }
    }
    //output.set('result', response.get('operation-details'))

} catch (error) {
    log.trace(error)
    output.set('error', error)
}
log.trace("Finished executing attach_disk.js flintbit")

/**
 *
 *rror reading service account credential from stream, expecting  'client_id', 'client_email', 'private_key' and 'private_key_id'.
 */