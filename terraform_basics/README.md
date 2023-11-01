# Terraform Basics

## Create an AWS resource

First, you will have to create an AWS account if you don't hav e any.

Second, create an IAM user that will be used for the entire study.
Best practice - Avoid using the `root` account to perform tasks on AWS.

Third, for the entire of this study, I will create an IAM user with `AdministratorAccess`. That way I still have almost all the privileges that my **root** account has.
Best practice - Users should be only assigned the least privilege they need to perform their job functions.

Fourth, as the new user, generate an `AWS ACCESS KEY` and `AWS SECRET ACCESS KEY`. These credentials are what you use to interact with the AWS API in the CLI
Note: The `AWS SECRET ACCESS KEY` vanishes after creation. So be sure to copy that and save it somewhere no one has access to.

Fifth, in your computer, export those credentials by using the **Terminal**.
In your **Terminal**, open the file `~/.aws/credentials` to add your credentials

```bash
[default]
region=us-west-2  # whatever region is closest to you
aws_access_key_id=YOUR_OWN_ACCESS_KEY
aws_secret_access_key=YOUR_OWN_SECRET_ACCESS_KEY
```

Now to be able to confirm our credentials are set, we need to use the AWS CLI. But first, it has to be installed.
Refer to this page for step by step instructions on how to do the installation.

[AWS CLI Install](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

After installation, we now need to confirm our credentials were properly set.

```bash
# check the ACCESS KEY & SECRETS are correct
aws configure list

# confirm your credentials work
aws sts get-caller-identity
```

If everything checks out, let's go back to configuring our terraform script.

Remember that whatever `AMI` you are using for your EC2's, has to be from the same region you configured in your credentials file.

- AMI is **region** specific
