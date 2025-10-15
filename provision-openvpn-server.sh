if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Error: 1. aws profile,  2. suffix and 3. region (e.g. ap-southeast-2) must be provided."
    exit 1
fi

AWS_PROFILE=$1
SUFFIX=$2
REGION=$3

VPC_ID=OpenVPN-VPC-$2
INSTANCE_NAME=OpenVPN-AS-$2
STACK_NAME=openvpn-personal-$2

jq  --arg VPC_ID "$VPC_ID" \
    --arg INSTANCE_NAME "$INSTANCE_NAME" \
    '.Parameters.VpcId=$VPC_ID | .Parameters.InstanceName=$INSTANCE_NAME' parameters.json >tmp.json && mv tmp.json parameters.json

EXIT_STATUS=$?
if [ $EXIT_STATUS -ne 0 ]; then
    echo "Command failed with exit status $EXIT_STATUS."
    exit $EXIT_STATUS
fi

aws cloudformation deploy \
    --template-file openvpn-cfn.yaml \
    --parameter-overrides file://parameters.json \
    --stack-name $STACK_NAME \
    --profile $AWS_PROFILE \
    --capabilities CAPABILITY_IAM \
    --region $REGION

EXIT_STATUS=$?
if [ $EXIT_STATUS -ne 0 ]; then
    echo "Command failed with exit status $EXIT_STATUS."
    exit $EXIT_STATUS
fi

echo "Admin portal url"
aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --profile $AWS_PROFILE \
    --region $REGION \
    | sed -n 's/.*"\(https:\/\/[^[:space:],]*\)".*/\1/p' 
