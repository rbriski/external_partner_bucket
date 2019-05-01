## Setup

1. Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
1. Install [Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
1. Clone this repo
1. `cd external_partner_bucket`

## Initialize terraform
### Run ```terraform init```

## Variables
I've set some variables but feel free to change them.  They're in `terraform.tfvars`

##  Apply the changes
### Run `terraform apply`

Terraform will create the policies, users and buckets.  It will output the name of the bucket
along with the access and secret keys for those users

The output will look like:
```
Outputs:

bucket_name = [
    your-bucket-name
]
full_access_key = [
    <Access ID>
]
full_access_secret = [
    <Secret key>
]
write_access_key = [
    <Access ID>
]
write_access_secret = [
    <Secret key>
]
```

## Test the setup
Take the outputs and populate the `test.sh` file with the correct values.  When you run
`test.sh` it will run commands against S3.  You will notice that the full access user can 
do as it pleases, while the external user can only write to the specified `external` path.

## Bucket policy
If you look at the actual bucket policy, it will look similar to this:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::709172811061:user/loom/loom-full"
            },
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::loom.raybeam/*",
                "arn:aws:s3:::loom.raybeam"
            ]
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::709172811061:user/loom/loom-external"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::loom.raybeam",
            "Condition": {
                "StringLike": {
                    "s3:prefix": [
                        "external/",
                        ""
                    ]
                }
            }
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::709172811061:user/loom/loom-external"
            },
            "Action": [
                "s3:PutObjectAcl",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::loom.raybeam/external/*",
                "arn:aws:s3:::loom.raybeam/external/"
            ]
        }
    ]
}
```

## Teardown
You can run `terraform destroy` to remove everything.