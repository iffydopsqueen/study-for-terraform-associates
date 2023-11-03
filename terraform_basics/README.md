# Terraform Basics

## Create an AWS resource

### Create an AWS account

You will have to create an AWS account if you don't have any.

### Create an AWS IAM User

Create an IAM user that will be used for the entire study.

**BEST PRACTICE** - Avoid using the `root` account to perform tasks on AWS. It is recommended to create an IAM user for those tasks.

For the entirety of this study, I will create an IAM user with `AdministratorAccess`.

- With this permission, I still have almost all the privileges that the **root** account has.

**BEST PRACTICE** - Users should be only assigned the least privilege they need to perform their job functions.

### Generate AWS Credentials

As the new user, generate an `AWS ACCESS KEY` and `AWS SECRET ACCESS KEY`. These credentials are what you use to interact with AWS API in the CLI.

**Note:** The `AWS SECRET ACCESS KEY` vanishes after creation. So be sure to copy that and save it somewhere no one has access to or simply download the file that was generated for you.

### Configure AWS CLI

In your computer, export the credentials you just generated into your **Terminal**.

- In your **Terminal**, open the file `~/.aws/credentials` to add the credentials

```bash
[default]
region=us-west-2  # whatever region is closest to you
aws_access_key_id=YOUR_OWN_ACCESS_KEY
aws_secret_access_key=YOUR_OWN_SECRET_ACCESS_KEY
```

To confirm your credentials are set, you need to use the AWS CLI to make that confirmation. But first, it has to be installed.

### Install AWS CLI

Refer to this page for step by step instructions on how to do the installation.

[AWS CLI Install](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

### Confirm AWS Credentials

After installation, let's confirm our credentials were properly set.

```bash
# check the ACCESS KEY & SECRETS are correct
aws configure list

# confirm the credentials work
aws sts get-caller-identity
```

If everything checks out, let's go back to configuring our terraform script to provision an EC2 instance.

Remember that whatever `AMI` you are using for your EC2 instance has to be from the same region you configured in your credentials file.

- AMI's are **region** specific.
