data "aws_caller_identity" "current" {}

resource "aws_kms_key" "control_tower" {
  description         = "KMS key used to encrypt control tower logs"
  enable_key_rotation = true
}

resource "aws_kms_key_policy" "control_tower" {
  key_id = aws_kms_key.control_tower.key_id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "Enable IAM User Permissions",
          "Effect" : "Allow",
          "Principal" : { "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" },
          "Action" : "kms:*",
          "Resource" : "*"
        },
        {
          "Sid" : "Allow Config to use KMS for encryption",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "config.amazonaws.com"
          },
          "Action" : [
            "kms:Decrypt",
            "kms:GenerateDataKey"
          ],
          "Resource" : "arn:aws:kms:${var.key-region}:${data.aws_caller_identity.current.account_id}:key/${aws_kms_key.control_tower.key_id}"
        },
        {
          "Sid" : "Allow CloudTrail to use KMS for encryption",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "cloudtrail.amazonaws.com"
          },
          "Action" : [
            "kms:GenerateDataKey*",
            "kms:Decrypt"
          ],
          "Resource" : "arn:aws:kms:${var.key-region}:${data.aws_caller_identity.current.account_id}:key/${aws_kms_key.control_tower.key_id}",
          "Condition" : {
            "StringEquals" : {
              "aws:SourceArn" : "arn:aws:cloudtrail:${var.key-region}:${data.aws_caller_identity.current.account_id}:trail/aws-controltower-BaselineCloudTrail"
            },
            "StringLike" : {
              "kms:EncryptionContext:aws:cloudtrail:arn" : "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"
            }
          }
        }
      ]
    }
  )
}

# Add an alias to the key
resource "aws_kms_alias" "control_tower" {
  name          = "alias/${var.key-alias}"
  target_key_id = aws_kms_key.control_tower.key_id
}