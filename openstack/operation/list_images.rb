# begin
@log.trace("Started executing 'fb-cloud:openstack:operation:list_images.rb' flintbit...")
begin
     # Flintbit Input Parameters
    # Mandatory
    connector_name = @input.get('connector_name')
    action = 'list-images'
    @protocol = @input.get('protocol')
    @target = @input.get('target')
    @port = @input.get('port')
    @version = @input.get('version')
    @username = @input.get('username')
    @password = @input.get('password')
    @domain_id = @input.get('domain-id')
 
    #optional 
    @project_id = @input.get('project-id')
    request_timeout = @input.get('timeout')

    connector_call = @call.connector(connector_name)
			  .set('action', action)
 			  .set('protocol', @protocol)
			  .set('target', @target)
			  .set('password', @password)
			  .set('domain-id', @domain_id)
			  .set('port', @port)
			  .set('version', @version)
			  .set('username', @username)
			  .set('project-id', @project_id)

    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "openstack connector name (connector_name)" to list images'
    end

    if @domain_id.nil? || @domain_id.empty?
        raise 'Please provide "openstack domain id (@domain_id)" to list images'
    end

     if @target.nil? || @target.empty?
        raise 'Please provide "openstack target (@target)" to list images'
    end

     if @username.nil? || @username.empty?
        raise 'Please provide "openstack username (@username)"to list images'
    end

    if @password.nil? || @password.empty?
        raise 'Please provide "openstack password (@password)" to list images'
    end

    if request_timeout.nil? || request_timeout.is_a?(String)
        @log.trace("Calling #{connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{connector_name} with given timeout #{request_timeout}...")
        response = connector_call.timeout(request_timeout).sync
    end

    #fetching response 
    response_exitcode = response.exitcode
    response_message = response.message

    image_list=response.get('image-list')

    
    if response_exitcode == 0
        @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 0).set('message',response_message).set('image-list',image_list)

    else
        @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)

     end

rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)

end

@log.trace("Finished executing 'fb-cloud:openstack:operation:list_images.rb' flintbit")
# end
