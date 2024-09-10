# NOTE 
# count & index works with list only.

variable "iam_users_var" {
  type = list(string)
  description = "iam users"
  default = ["user2","user3","user4"]
}

resource "aws_iam_user" "amy_iam_users" {
  count = length(var.iam_users_var)
  name  = var.iam_users_var[count.index]
}

# NOTE 
# for_each works with Set only.

variable "iam_users_var" {
  type        = set(string)
  description = "iam users"
  default     = ["user2", "user3", "user4"]
}

resource "aws_iam_user" "amy_iam_users" {
  for_each = var.iam_users_var
  name     = each.value
}


# FOR LOOP

variable "iam_users_var" {
  type        = set(string)
  description = "iam users"
  default     = ["user2", "user3", "user4"]
}

output "iam_user_output" {
  value = [for user in var.iam_users_var : "user name is: ${user}"]
}
