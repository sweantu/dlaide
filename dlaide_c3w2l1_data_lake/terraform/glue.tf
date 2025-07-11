resource "aws_glue_job" "reviews_etl_job" {
  name         = "${var.project}-reviews-etl-job"
  role_arn     = aws_iam_role.glue_role.arn
  glue_version = "4.0"

  command {
    name            = "glueetl"
    script_location = "s3://${var.glue_scripts_name}/de-c3w2-reviews-transform-job.py"
    python_version  = 3
  }

  default_arguments = {
    "--enable-job-insights" = "true"
    "--job-language"        = "python"
    "--conf"                = "spark.rpc.message.maxSize=2000"
    "--enable-metrics"      = "true"
    "--s3_bucket"           = var.data_lake_name
    "--source_path"         = "staging/reviews_Toys_and_Games.json.gz"
    "--target_path"         = "toys_reviews/"
    "--compression"         = "snappy"
    "--partition_cols"      = jsonencode(["asin"])
  }

  timeout = 15

  number_of_workers = 2
  worker_type       = "G.1X"
}

resource "aws_glue_job" "metadata_etl_job" {
  name         = "${var.project}-metadata-etl-job"
  role_arn     = aws_iam_role.glue_role.arn
  glue_version = "4.0"

  command {
    name            = "glueetl"
    script_location = "s3://${var.glue_scripts_name}/de-c3w2-metadata-transform-job.py"
    python_version  = 3

  }

  default_arguments = {
    "--enable-job-insights"       = "true"
    "--job-language"              = "python"
    "--additional-python-modules" = "smart_open==7.0.4"
    "--conf"                      = "spark.rpc.message.maxSize=2000"
    "--enable-metrics"            = "true"
    "--s3_bucket"                 = var.data_lake_name
    "--source_path"               = "staging/meta_Toys_and_Games.json.gz"
    "--target_path"               = "toys_metadata/"
    "--compression"               = "gzip"
    "--partition_cols"            = jsonencode([])
  }

  timeout = 10

  number_of_workers = 2
  worker_type       = "G.1X"
}
