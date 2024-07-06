terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.55.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  alias  = "new"
  region = "us-west-2"
}


resource "aws_iam_user" "test" {
  name = "akua"

}

data "aws_iam_policy_document" "fuse" {
  statement {
    sid = "AkuaPolicy"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
      "s3:DescribeJob",
    ]

    resources = [
      "arn:aws:s3:::talktalk-1981/*",
    ]
  }


}

resource "aws_iam_policy" "policy1" {
  name   = "akuapolicy"
  path   = "/"
  policy = data.aws_iam_policy_document.fuse.json
}




resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.test.name
  policy_arn = aws_iam_policy.policy1.arn
}


resource "aws_iam_user_policy_attachment" "test-attach2" {
  user       = aws_iam_user.test.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}


resource "aws_instance" "this" {
  ami           = "ami-053a617c6207ecc7b"
  instance_type = "t2.micro"

  tags = {
    Name = "NanaAba"
  }
}


resource "aws_instance" "that" {
  ami           = "ami-0cf2b4e024cdb6960"
  provider = aws.new
  instance_type = "t2.micro"

  tags = {
    Name = "Aba"
  }
}

output "ec2ip" {
  value = aws_instance.this.public_ip
}

output "akuaid" {
  value = aws_iam_user.test.id
}
