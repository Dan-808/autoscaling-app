output "vpc_id" {
  value = aws_vpc.my-vpc.id

}

output "igw_id" {
  value = aws_internet_gateway.this.id

}


output "subnet_ids" {
  value = { for k, v in aws_subnet.this : v.tags.Name => v.id }    #"k" quer dizer que estou acessar a chave da minha subnet e "v" representa o valor : e estou retornando o nome da minha tag e também o id da subnet

}

output "public_route_table_id" {

  value = aws_route_table.public.id

}

output "private_route_table_id" {

  value = aws_route_table.private.id

}

output "aws_route_table_association_ids" {
  value = [for k, v in aws_route_table_association.this : v.id]

}

output "sg_web_id" {

  value = aws_security_group.web.id

}

output "sg_db_id" {

  value = aws_security_group.db.id

}

output "sg_alb_id" {

  value = aws_security_group.alb.id

}

output "alb_id" {

  value = aws_lb.this.id

}