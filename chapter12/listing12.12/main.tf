resource "aws_codepipeline" "codepipeline" {
  name     = "${local.namespace}-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        FullRepositoryId = var.vcs_repo.identifier
        BranchName       = var.vcs_repo.branch
        ConnectionArn    = aws_codestarconnections_connection.github.arn
      }
    }
  }

  stage {
    name = "Plan"

    action {
      name            = "Plan"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName          = aws_codebuild_project.project[0].name
        EnvironmentVariables = local.environment
      }
    }
  }

  dynamic "stage" {
    for_each = var.auto_apply ? [] : [1]
    content {
      name = "Approval"

      action {
        name     = "Approval"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"

        configuration = {
          CustomData      = "Please review output of plan and approve"
          NotificationArn = aws_sns_topic.codepipeline.arn
        }
      }
    }
  }

  stage {
    name = "Apply"

    action {
      name            = "Apply"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName          = aws_codebuild_project.project[1].name
        EnvironmentVariables = local.environment
      }
    }
  }
