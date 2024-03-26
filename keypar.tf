
resource "tls_private_key" "deployer" { #vai gerar uma chave privada 
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "deployer" { #depois vai gerar o componente key pair baseado na chave privada
  key_name   = "deployer-key"
  public_key = tls_private_key.deployer.public_key_openssh
}


resource "local_file" "private_key" { #vai expor o arquivo localmente
  content  = tls_private_key.deployer.private_key_pem
  filename = "${path.module}/deployer-key.pem"
}