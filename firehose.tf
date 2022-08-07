#Create the kinesis resource
resource "aws_kinesis_stream" "kinesis-firehose-stream" {
  name             = "kinesis-firehose-stream"
  shard_count      = 1
  retention_period = 48

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

}
#Create the firehose_delivery_stream in kinesis with extended s3 configuration
resource "aws_kinesis_firehose_delivery_stream" "firehose_extended_s3_stream" {
  name        = "kinesis-firehose-extended-s3-test-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.iam_role_firehose_to_s3.arn
    bucket_arn = local.destination_bucket_arns
    prefix = "AWSManagedAD/"
    kms_key_arn = local.kms_key_map

    cloudwatch_logging_options {
      enabled = true
      log_group_name = [module.ec2_os_log_group_us_east_1]
    }

  }
}

#PTYPE Firehose Logging Delivery to Logging Framework
resource "aws_s3_bucket" "ptype_firehose_delivery_bucket" {
  bucket = local.ptype_bucket_destination_arns
  role = aws_iam_role.iam_role_firehose_to_s3
  bucket_arn = local.firehose_arns_ptype
  

}
