
const amplifyconfig =
''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "yatree": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://api.yatre-e.com/",
                    "region": "us-east-1",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS"
                }
            }
        }
    },
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-east-1:1ea764b2-9bd5-46af-a44d-58d8ac31087e",
                            "Region": "us-east-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-east-1_Q5nqpHVti",
                        "AppClientId": "2sfj6pcskb2j282ojp7qf7as8i",
                        "Region": "us-east-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "OAuth": {
                            "WebDomain": "oauth.yatre-e.com",
                            "AppClientId": "2sfj6pcskb2j282ojp7qf7as8i",
                            "SignInRedirectURI": "yatreedestination://",
                            "SignOutRedirectURI": "yatreedestination://",
                            "Scopes": [
                                "phone",
                                "email",
                                "openid",
                                "profile",
                                "aws.cognito.signin.user.admin"
                            ]
                        },
                        "authenticationFlowType": "CUSTOM_AUTH"
                    }
                },
                "AppSync": {
                    "Default": {
                        "ApiUrl": "https://api.yatre-e.com/",
                        "Region": "us-east-1",
                        "AuthMode": "AMAZON_COGNITO_USER_POOLS",
                        "ClientDatabasePrefix": "yatree_AMAZON_COGNITO_USER_POOLS"
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "yatree-app-dev230905-dev",
                        "Region": "us-east-1"
                    }
                },
                "PinpointAnalytics": {
                    "Default": {
                        "AppId": "301b37aecafc4a349c1164369120fcb8",
                        "Region": "us-east-1"
                    }
                },
                "PinpointTargeting": {
                    "Default": {
                        "Region": "us-east-1"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "yatree-app-dev230905-dev",
                "region": "us-east-1",
                "defaultAccessLevel": "guest"
            }
        }
    },
    "analytics": {
        "plugins": {
            "awsPinpointAnalyticsPlugin": {
                "pinpointAnalytics": {
                    "appId": "301b37aecafc4a349c1164369120fcb8",
                    "region": "us-east-1"
                },
                "pinpointTargeting": {
                    "region": "us-east-1"
                }
            }
        }
    }
}''';
