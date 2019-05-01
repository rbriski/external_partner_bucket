#!/bin/bash

BUCKET_NAME=
FULL_ACCESS_KEY=
FULL_ACCESS_SECRET=
WRITE_ACCESS_KEY=
WRITE_ACCESS_SECRET=

echo "Testing full access read on root path"
AWS_ACCESS_KEY_ID=$FULL_ACCESS_KEY AWS_SECRET_ACCESS_KEY=$FULL_ACCESS_SECRET aws s3 ls s3://$BUCKET_NAME/

echo "Testing write access read on root path"
AWS_ACCESS_KEY_ID=$WRITE_ACCESS_KEY AWS_SECRET_ACCESS_KEY=$WRITE_ACCESS_SECRET aws s3 ls s3://$BUCKET_NAME/

echo "Testing write access write on root path (should fail)"
AWS_ACCESS_KEY_ID=$WRITE_ACCESS_KEY AWS_SECRET_ACCESS_KEY=$WRITE_ACCESS_SECRET aws s3 cp $0 s3://$BUCKET_NAME/

echo "Testing write access write on external path"
AWS_ACCESS_KEY_ID=$WRITE_ACCESS_KEY AWS_SECRET_ACCESS_KEY=$WRITE_ACCESS_SECRET aws s3 cp $0 s3://$BUCKET_NAME/external/

echo "Testing write access read on external path (should fail)"
AWS_ACCESS_KEY_ID=$WRITE_ACCESS_KEY AWS_SECRET_ACCESS_KEY=$WRITE_ACCESS_SECRET aws s3 cp s3://$BUCKET_NAME/$0 $0.download

echo "Clean up"
AWS_ACCESS_KEY_ID=$FULL_ACCESS_KEY AWS_SECRET_ACCESS_KEY=$FULL_ACCESS_SECRET aws s3 rm s3://$BUCKET_NAME/$0
