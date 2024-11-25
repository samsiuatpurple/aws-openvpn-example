if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Error: 1. aws profile,  2. suffix and 3. region (e.g. ap-southeast-2) must be provided."
    exit 1
fi

AWS_PROFILE=$1
SUFFIX=$2
REGION=$3

SSH_KEY_PAIR=KeyPair-OpenVPN-$2
STACK_NAME=openvpn-personal-$2

aws cloudformation delete-stack --stack-name $STACK_NAME --profile $AWS_PROFILE
EXIT_STATUS=$?  
if [ $EXIT_STATUS -ne 0 ]; then
  echo "delete-stack failed with exit status $EXIT_STATUS."
  exit $EXIT_STATUS
fi

aws ec2 delete-key-pair --key-name $SSH_KEY_PAIR --region $REGION --profile $AWS_PROFILE
EXIT_STATUS=$?
if [ $EXIT_STATUS -ne 0 ]; then
  echo "delete-key-pair failed with exit status $EXIT_STATUS."
  exit $EXIT_STATUS
fi

rm -f $SSH_KEY_PAIR.pem
echo "Stack $STACK_NAME and key $SSH_KEY_PAIR have been removed"