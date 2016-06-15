# begin
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:describe_tags.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    connector_name = @input.get('connector_name')	# Name of the Amazon EC2 Connector
    action = 'describe-tags'	# Contains the name of the operation: describe_tags
    resource_id = @input.get('resource_id')	# Specifies the resource ID of Amazon EC2
    resource_type = @input.get('resource_type')	# Specifies the type of the resource

    # Optional
    @access_key = @input.get('access-key')
    @secret_key = @input.get('security-key')
    region = @input.get('region')	# Amazon EC2 region (default region is "us-east-1")
    request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    @log.info("Flintbit input parameters are, action : #{action} | resource_id : #{resource_id} | resource_type : #{resource_type} | region : #{region} |")

    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "Amazon EC2 connector name (connector_name)" to describe Tags'
    end

    if resource_id.nil? || resource_id.empty?
        raise 'Please provide "Amazon EC2 resource ID (resource_id)" to describe Tags'
    end

    if resource_type.nil? || resource_type.empty?
        raise 'Please provide "Amazon EC2 resource Type (resource_type)" to describe Tags'
    end

    connector_call = @call.connector(connector_name).set('action', action).set('resource-id', resource_id).set('resource-type', resource_type)
                          .set('access-key', @access_key).set('security-key', @secret_key)

    if !region.nil? && !region.empty?
        connector_call.set('region', region)
    else
        @log.trace("region is not provided so using default region 'us-east-1'")
    end

    if request_timeout.nil? || request_timeout.is_a?(String)
        @log.trace("Calling #{connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{connector_name} with given timeout #{request_timeout}...")
        response = connector_call.timeout(request_timeout).sync
    end

    # Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode	# Exit status code
    response_message = response.message	# Execution status messages
    tag_set = response.get('tag-set')	# Set of tags

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @log.info("Amazon EC2 resource Tags are : #{tag_set}")
        @output.set('exit-code', 0).set('message', response_message).setraw('tags', tag_set.to_s)
    else
        @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)
        # @output.exit(1,response_message)					#Use to exit from flintbit
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:describe_tags.rb' flintbit")
# end
