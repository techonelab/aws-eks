# aws-eks
a simple aws-eks cluster that uses localstack as local provider to mimic aws like environment.

NOTE: we will not use awslocal cli for this lab, instead, you need to modify and point the aws endpoint to localstack as suggested from localstack documentation if wanted to use aws native cli instead (refer to provider.tf, you may need to check localstack for updated list of services)

Requirements:
- terraform or opentofu
- kubectl
- docker

Steps:
1. docker run --rm -it -p 4566:4566 -p 4510-4559:4510-4559 -e DEBUG=1 -v /var/run/docker.sock:/var/run/docker.sock -e LOCALSTACK_API_KEY=<your-key-here> localstack/localstack-pro
   - localstack (OSS) doesn't support all aws service so we highly recommend to use localstack-pro

2. go to prereq directory (refer to README). 

3. go back to root directory:
   - tf init
   - tf apply --auto-approve 
   - once infrastructure and eks cluster has been provisioned you may need to wait for couple of minutes to allow the eks cluster fully initialize

4. kubectl cluster-info, and kubectl get pods -A to initially interact 

some helpful cmdlets during setup:
always append --endpoint-url=http://localhost:<port> when using aws cli
aws eks list-cluster --endpoint-url=http://localhost:<port>
aws sts get-caller-identity --endpoint-url=http://localhost:<port>
aws eks --region us-east-1 update-kubeconfig --name demo-aws-eks-project-cluster --endpoint-url=http://localhost:<port>
docker run --rm -it -p 4566:4566 -p 4510-4559:4510-4559 -e DEBUG=1 -v /var/run/docker.sock:/var/run/docker.sock -e LOCALSTACK_API_KEY=<your-key-here> localstack/localstack-pro

![localstack](https://raw.githubusercontent.com/localstack/localstack/master/doc/localstack-readme-banner.svg)

powered by: [localstack.cloud](https://localstack.cloud/)
