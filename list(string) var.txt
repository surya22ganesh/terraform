resource "aws_iam_user" "iam_users" {
  count = length(var.iam_user_var)
  name = var.iam_user_var[count.index]
}

variable "iam_user_var" {
  description = "value"
  type = list(string)
  default = [ "user1","user2","user3" ]
}