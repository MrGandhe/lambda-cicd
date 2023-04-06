
data "archive_file" "code_archive" {
  type        = "zip"
  source_dir = "${path.module}/python/"
  output_path = "${path.module}/python.zip"
}

resource "aws_s3_bucket_object" "function" {
  bucket = aws_s3_bucket.bucket.id
  key    = "python.zip"
  source = data.archive_file.code_archive.output_path
} 

resource "aws_lambda_function" "func" {
    # If the file is not in the current working directory you will need to include a
    # path.module in the filename.
    /* filename      = var.lambda_file_name */
    function_name = var.lambda_function_name
    role          = aws_iam_role.iam_for_lambda.arn
    handler       = var.lambda_file_handler
    runtime       = var.lambda_runtime
    memory_size   = var.lambda_memory_size
    timeout = 3
    s3_bucket = aws_s3_bucket_object.function.bucket
    s3_key =  aws_s3_bucket_object.function.key
    layers = [aws_lambda_layer_version.my_custom_layer.arn]
    environment {
      
      variables = var.env_vars

    }
       
}
resource "aws_lambda_layer_version" "my_custom_layer" {
  layer_name = "lambda_layer"
  filename = "D:/aws2/Lambda-CICD-main/Lambda-CICD-main/New Text Document.zip"
  compatible_runtimes = ["python3.9"]
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "lambdalog"
  retention_in_days = 14
  tags              = {}
}   
    
resource "aws_s3_bucket" "bucket" {
  bucket = var.lambda_bucket
}

