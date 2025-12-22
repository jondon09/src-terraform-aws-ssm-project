Feature: SSM Default Host Management Configuration
  As a Security engineer
  I want to ensure SSM is configured correctly
  So that EC2 instances can be managed securely

  Scenario: Ensure IAM role exists for SSM
    Given I have aws_iam_role defined
    Then it must have name
    And its name must be "AWSSystemsManagerDefaultEC2InstanceManagementRole"

  Scenario: Ensure IAM role can only be assumed by SSM service
    Given I have aws_iam_role defined
    When it has assume_role_policy
    Then it must contain "ssm.amazonaws.com"

  Scenario: Ensure correct policy is attached to SSM role
    Given I have aws_iam_role_policy_attachment defined
    Then it must have policy_arn
    And its policy_arn must be "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"

  Scenario: Ensure SSM service setting is configured
    Given I have aws_ssm_service_setting defined
    Then it must have setting_id
    And it must have setting_value