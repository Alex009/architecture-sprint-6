docker run --rm -it \
  -v $(pwd)/terraform:/app \
  -v ~/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub \
  -w /app \
  hashicorp/terraform:latest $@ -var-file="yandex.tfvars"
