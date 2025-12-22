Feature: SSM Default Host Management Configuration
  As a Security engineer
  I want to ensure SSM is configured correctly
  So that EC2 instances can be managed securely

  Scenario: Ensure IAM role exists for SSM
    Given I have aws_iam_role defined
    When its name is "AWSSystemsManagerDefaultEC2InstanceManagementRole"
    Then it must have name

  Scenario: Ensure SSM service setting is configured
    Given I have aws_ssm_service_setting defined
    Then it must have setting_id
