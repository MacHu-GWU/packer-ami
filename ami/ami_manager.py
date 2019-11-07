# -*- coding: utf-8 -*-

"""
Manage registered AMI.

ref: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2.html#client
"""

import json
import boto3

AMI_NAME_FILE = "ami-name"
VERSION_FILE = "version"


def jprint(data):
    print(json.dumps(data, indent=4, sort_keys=True))


class TagKey:
    AMIName = "AMIName"
    AMIFullName = "AMIFullName"
    AMIVersion = "AMIVersion"
    Stage = "Stage"
    OSVersion = "OSVersion"
    BaseAMI = "BaseAMI"
    BaseAMIName = "BaseAMIName"
    CreateAt = "CreateAt"


if __name__ == "__main__":
    boto_ses = boto3.Session(profile_name="eq_sanhe")
    ec2_client = boto_ses.client("ec2")

    filters = {
        TagKey.AMIName: "python3.6.8",
        TagKey.Stage: "prod",
    }

    image_filters = [
        {
            "Name": "tag:{}".format(key),
            "Values": [
                value
            ]
        }
        for key, value in filters.items()
    ]

    describe_images_response = ec2_client.describe_images(
        Filters=image_filters,
        Owners=[
            "self"
        ]
    )


    def tag_list_to_dict(tags):
        return {
            dct["Key"]: dct["Value"]
            for dct in tags
        }


    latest_ami_id = list(sorted(
        describe_images_response["Images"],
        key=lambda dct: int(tag_list_to_dict(dct["Tags"])[TagKey.AMIVersion]),
        reverse=True
    ))[0]["ImageId"]

    jprint(describe_images_response)
    print(latest_ami_id)
