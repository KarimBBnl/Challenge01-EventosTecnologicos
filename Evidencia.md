cd "/c/Users/karim/Desktop/2ºDAM/Programación/Challengue1-EventosTecnologicos"

export AWS_ACCESS_KEY_ID="TU_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="TU_SECRET_KEY"
export AWS_SESSION_TOKEN="TU_SESSION_TOKEN"
export AWS_DEFAULT_REGION="us-east-1"

aws sts get-caller-identity

./terraform.exe init
./terraform.exe fmt main.tf
./terraform.exe validate
./terraform.exe plan
./terraform.exe apply -auto-approve

BUCKET=$(./terraform.exe output -raw bucket_name)
ENDPOINT=$(./terraform.exe output -raw website_endpoint)

echo "Bucket: $BUCKET"
echo "http://$ENDPOINT" | tee URL.txt

aws s3 ls "s3://$BUCKET/"
curl -I "http://$ENDPOINT"