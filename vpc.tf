resource "aws_vpc" "my-vpc" { #criando uma vpc
  cidr_block = "10.0.0.0/16"   #/16 é a quantidade de IPs que posso utilizar dentro da vpc

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_internet_gateway" "this" {

  vpc_id = aws_vpc.my-vpc.id  #anexando a vpc que criei

  tags = {
    Name = "terraform IGW"
  }

}

resource "aws_subnet" "this" {   #fica mais facil usando como uma lista

  for_each = {
    "pub_a" : ["10.0.0.0/24", "${var.aws_region}a", "Public A"]
    "pub_b" : ["10.0.1.0/24", "${var.aws_region}b", "Public B"]
    "pvt_a" : ["10.0.2.0/24", "${var.aws_region}a", "Private A"]
    "pvt_b" : ["10.0.3.0/24", "${var.aws_region}b", "private B"]

  }

  vpc_id = aws_vpc.my-vpc.id       #aqui o for_each está gerando os valores

  cidr_block = each.value[0] #"10.0.0.0/24"

  availability_zone = each.value[1] #${var.aws_region}a

  tags = {
    Name = each.value[2] #"private B"
  }

}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my-vpc.id #anexando a minha vpc

  route { #criando route table publica
    cidr_block = "0.0.0.0/0"  #qualquer endereço da internet pode acessar atravez do internet gateway

    gateway_id = aws_internet_gateway.this.id

  }

  tags = {
    Name = "Route Table public"
  }


}


resource "aws_route_table" "private" { #essa não aceita conexões da internet
  vpc_id = aws_vpc.my-vpc.id



  tags = {
    Name = "Route Table private"
  }


}

resource "aws_route_table_association" "this" {

  for_each = { for k, v in aws_subnet.this : v.tags.Name => v.id } #iterando sobre as subnets, "v.tags.Name" esta retornando "Public A" etc

  subnet_id = each.value

  route_table_id = substr(each.key, 0, 3) == "Pub" ? aws_route_table.public.id : aws_route_table.private.id #estou iltrando o valor que esta retornando "substr(each.key, 0, 3)" e se as 3 primeiras letras forem "Pub" é da ssubnet publica e vice versa.

}
