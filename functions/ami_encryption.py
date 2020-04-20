# Automated AMI Encryption
import copy
import os

import boto3
import json
import logging



# logging init
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    # start logging
    data = json.dumps(event)
    logger.info('Starting ami copy job based on this event:')
    logger.info(data)

    # grab parameters from our event
    resource_id = event['resources'][0]
    source_region = event['region']
    destination_region = event['region']

    # KMS Flag and config
    kms_enabled = bool(os.environ['KMS_ENABLED'])
    dest_kms_key = os.environ['KMS_KEY']

    logger.info('kms enabled: {}'.format(kms_enabled))
    logger.info('kms key: ' + dest_kms_key)

    # init boto3
    source_resource = boto3.resource('ec2', source_region)
    destination_resource = boto3.resource('ec2', destination_region)
    destination_client = boto3.client('ec2', destination_region)

    # source AMI
    source_ami = source_resource.Image(resource_id)
    logger.info('Attempting to copy {} from {} to {}'.format(resource_id, source_region, destination_region))

    if kms_enabled == True and dest_kms_key != '' and dest_kms_key != None and dest_kms_key != 'Default':

        logger.info('kms_enabled is true and kms key param is present. attempting to encrypt destination replica using the following key: {}.'.format(dest_kms_key))
        create_destination_ami = destination_client.copy_image(
            Description='An encrypted root ami based off {} from {}'.format(resource_id, source_region),
            Name="ENC-" + source_ami.name,
            SourceImageId=source_ami.id,
            SourceRegion=source_region,
            Encrypted=True,
            KmsKeyId=dest_kms_key
        )

    elif kms_enabled == True and (dest_kms_key == '' or dest_kms_key == None or dest_kms_key == 'Default'):

        logger.info('kms_enabled is true and kms key param is NOT present. snapshots will be encrypted using the default kms CMK in the destination region.')
        create_destination_ami = destination_client.copy_image(
            Description='An encrypted root ami based off {} from {}'.format(resource_id, source_region),
            Name="ENC-" + source_ami.name,
            SourceImageId=source_ami.id,
            SourceRegion=source_region,
            Encrypted=True
        )

    else:

        logger.info('kms_enabled is false. attempting to copy unencrypted snapshots to destination region.')
        for blockdevice in source_ami.block_device_mappings:
            snapshot = source_resource.Snapshot(blockdevice['Ebs']['SnapshotId'])
            if snapshot.encrypted == True:
                logger.info('snapshot {} is encrypted and associated with {}. since no kms CMK was specified for {} the snapshot will be copied to the destination using the default kms CMK in that region.'.format(snapshot.snapshot_id, source_ami.image_id, destination_region))

        create_destination_ami = destination_client.copy_image(
            Description='Replica of {} from {}'.format(resource_id, source_region),
            Name=source_ami.name,
            SourceImageId=source_ami.id,
            SourceRegion=source_region
        )

    destination_ami = destination_resource.Image(create_destination_ami['ImageId'])

    cur_tags = boto3_tag_list_to_ansible_dict(source_ami.tags)
    new_tags = copy.deepcopy(cur_tags)
    new_tags['source_ami'] = source_ami.id
    new_tags['source_region'] = source_region
    if(kms_enabled == True):
        new_tags['encrypted'] = 'yes'
        new_tags['Name'] = 'ENC-' + source_ami.name

    destination_ami.create_tags(Tags=ansible_dict_to_boto3_tag_list(new_tags))

    logger.info('New AMI in {} is {}'.format(destination_region, destination_ami.id))

    event['destination_ami_id'] = create_destination_ami['ImageId']

    return event

def boto3_tag_list_to_ansible_dict(tags_list):
    tags_dict = {}
    for tag in tags_list:
        if 'key' in tag and not tag['key'].startswith('aws:'):
            tags_dict[tag['key']] = tag['value']
        elif 'Key' in tag and not tag['Key'].startswith('aws:'):
            tags_dict[tag['Key']] = tag['Value']

    return tags_dict


def ansible_dict_to_boto3_tag_list(tags_dict):
    tags_list = []
    for k, v in tags_dict.items():
        tags_list.append({'Key': k, 'Value': v})

    return tags_list