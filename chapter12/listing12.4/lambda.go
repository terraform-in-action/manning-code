package main

import (
	"context"
	"fmt"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"

	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/secretsmanager"
)

func HandleRequest(ctx context.Context) error {
	client := secretsmanager.New(session.New())
	config := &secretsmanager.GetSecretValueInput{
		SecretId: aws.String(os.Getenv("SECRET_ID")),
	}
	val, err := client.GetSecretValue(config) #A
	if err != nil {
		return err
	}

	// do something with secret value
	fmt.Printf("Secret is: %s", *val.SecretString)

	return nil
}

func main() {
	lambda.Start(HandleRequest)
}
